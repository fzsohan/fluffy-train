import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/app/services/weather_service.dart';
import '../../config/translations/strings_enum.dart';
import '../components/custom_snackbar.dart';
import '../data/local/my_shared_pref.dart';
import '../routes/app_pages.dart';
import 'api_exceptions.dart';
import 'package:logger/logger.dart';
import 'page_navigation.dart';

enum RequestType { get, post, put, delete }

class BaseClient {
  // request timeout (default 10 seconds)
  static const int _timeoutInSeconds = 60;
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL']!,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'is-dev': false, //dotenv.env['IS_DEV_MODE'] ?? 'false',
            },
            connectTimeout: Duration(seconds: _timeoutInSeconds), // CHANGE
            receiveTimeout: Duration(seconds: _timeoutInSeconds), // CHANGE
            sendTimeout: Duration(seconds: _timeoutInSeconds),
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );

  /// 🔒 CHANGE: one-shot guard + small throttle to avoid multiple 401 snackbars at once
  static bool _unauthorizedShown = false; // CHANGE
  static DateTime? _lastUnauthorizedAt; // CHANGE
  static const Duration _unauthorizedThrottle = Duration(seconds: 3); // CHANGE

  /// CHANGE: call this after you handle 401 (logout/navigation) to re-enable future prompts
  static void resetUnauthorizedGuard() {
    // CHANGE
    _unauthorizedShown = false;
    _lastUnauthorizedAt = null;
  }

  /// dio getter (used for testing)
  static get dio => _dio;

  /// perform safe api request
  static safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function(int total, int progress)?
    onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;

      // 1️⃣ Get token and prepare headers
      final token = MySharedPref.getToken();
      final tokenType = MySharedPref.getTokenType() ?? 'Bearer';

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',

        if (token != null) 'Authorization': '$tokenType $token',
      };
      final mergedHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          options: Options(headers: mergedHeaders),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: mergedHeaders),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: mergedHeaders),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: mergedHeaders),
        );
      }
      // 3) return response (api done successfully)

      if (response.data['status'] == 'SUCCESS') {
        //SUCCESS, ERROR, VALIDATE_ERROR,SERVER_ERROR
        try {
          final decryptedData = WeatherService().decryptData(
            response.data['data'],
          );
          if (kDebugMode) {
            debugPrint("🔓 Decrypted Data: $decryptedData");
          }

          final newResponse = Response(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            data: {...response.data, 'data': decryptedData['result']},
          );

          await onSuccess(newResponse);
        } catch (e, st) {
          debugPrint("❌ Decryption error: $e");
          debugPrint("📌 StackTrace: $st");
          _handleUnexpectedException(error: e, url: url, onError: onError);
        }
        // } else if (response.data['status'] == 403) {
        //   PageNavigationService.removeAllAndNavigate(Routes.loginScreen);
      } else {
        _handleDioError(
          error: DioException(
            type: DioExceptionType.badResponse,
            response: response,
            message: response.data['message'],
            requestOptions: RequestOptions(),
          ),
          url: url,
          onError: onError,
        );
      }
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url, onError: onError);
    } on SocketException {
      // No internet connection
      _handleSocketException(url: url, onError: onError);
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(url: url, onError: onError);
    } catch (error, stackTrace) {
      // print the line of code that throw unexpected exception
      Logger().e(stackTrace);
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// download file
  static download({
    required String url, // file url
    required String savePath, // where to save file
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    required Function onSuccess,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
          receiveTimeout: const Duration(seconds: _timeoutInSeconds),
          sendTimeout: const Duration(seconds: _timeoutInSeconds),
        ),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException({
    Function(ApiException)? onError,
    required String url,
    required Object error,
  }) {
    if (onError != null) {
      onError(ApiException(message: error.toString(), url: url));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException({
    Function(ApiException)? onError,
    required String url,
  }) {
    if (onError != null) {
      onError(ApiException(message: Strings.serverNotResponding.tr, url: url));
    } else {
      _handleError(Strings.serverNotResponding.tr);
    }
  }

  /// handle timeout exception
  static _handleSocketException({
    Function(ApiException)? onError,
    required String url,
  }) {
    if (onError != null) {
      onError(ApiException(message: Strings.noInternetConnection.tr, url: url));
    } else {
      _handleError(Strings.noInternetConnection.tr);
    }
  }

  /// handle Dio error
  static _handleDioError({
    required DioException error,
    Function(ApiException)? onError,
    required String url,
  }) {
    // no internet connection
    if (error.type == DioExceptionType.connectionError) {
      return _handleSocketException(url: url, onError: onError);
    }

    // ✅ CHANGE: Handle 401 only once (with throttle) to avoid multiple snackbars
    if (error.response?.statusCode == 401) {
      // CHANGE
      final now = DateTime.now(); // CHANGE
      if (_unauthorizedShown && // CHANGE
          _lastUnauthorizedAt != null && // CHANGE
          now.difference(_lastUnauthorizedAt!) < _unauthorizedThrottle) {
        // CHANGE
        return; // silently ignore duplicates                               // CHANGE
      } // CHANGE
      _unauthorizedShown = true; // CHANGE
      _lastUnauthorizedAt = now; // CHANGE

      final exception = ApiException(
        // CHANGE
        message: 'Unauthorized request. Please login again.', // CHANGE
        url: url, // CHANGE
        statusCode: 401, // CHANGE
        response: error.response, // CHANGE
      ); // CHANGE

      MySharedPref.clearToken();
      PageNavigationService.removeAllAndNavigate(Routes.weatherSearchScreen);

      return onError != null
          ? onError(exception)
          : _handleError(exception.toString()); // CHANGE
    }
    // 404 error
    if (error.response?.statusCode == 404) {
      if (onError != null) {
        return onError(
          ApiException(
            message: error.response?.data['message'] ?? Strings.urlNotFound.tr,
            url: url,
            statusCode: 404,
          ),
        );
      } else {
        return _handleError(Strings.urlNotFound.tr);
      }
    }

    // no internet connection
    if (error.message != null &&
        error.message!.toLowerCase().contains('socket')) {
      if (onError != null) {
        return onError(
          ApiException(message: Strings.noInternetConnection.tr, url: url),
        );
      } else {
        return _handleError(Strings.noInternetConnection.tr);
      }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      var exception = ApiException(
        message: Strings.serverError.tr,
        url: url,
        statusCode: 500,
      );

      if (onError != null) {
        return onError(exception);
      } else {
        return handleApiError(exception);
      }
    }

    var exception = ApiException(
      url: url,
      message: error.message ?? 'Un Expected Api Error!',
      response: error.response,
      statusCode: error.response?.statusCode,
    );
    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason (the dio message)
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    CustomSnackBar.showCustomErrorToast(message: msg);
  }
}
