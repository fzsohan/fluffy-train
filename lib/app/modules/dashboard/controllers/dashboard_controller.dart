import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/api_paths.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/page_navigation.dart';

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  TabController? dashboardTabController;
  RxInt initialDashboardIndex = 0.obs;
  RxInt currentDashboardIndex = 0.obs;
  @override
  onInit() {
    dashboardTabController = TabController(
      vsync: this,
      length: 4,
      initialIndex: initialDashboardIndex.value,
    );
    super.onInit();
    fetchNotificationCount();
  }

  //<==================== Change App Tabbar
  void changeDashboardTabbar(int index) {
    if (index != 3) {
      dashboardTabController!.index = index >= 0 && index < 4 ? index : 0;
      currentDashboardIndex.value = index >= 0 && index < 4 ? index : 0;
    } else {
      dashboardTabController!.index = currentDashboardIndex.value;
      PageNavigationService.generalNavigation(Routes.weatherSearchScreen);
      // showGeneralDialog(
      //   context: Get.context!,
      //   barrierDismissible: true,
      //   transitionDuration: const Duration(milliseconds: 400),
      //   barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
      //   barrierColor: Colors.black.withValues(alpha: 0.5),
      //   pageBuilder: (BuildContext context, _, __) {
      //     return const CustomDrawer();
      //   },
      //   transitionBuilder: (context, animation, secondaryAnimation, child) {
      //     return CustomSlideTransition(animation: animation, child: child);
      //   },
      // );
    }
  }

  Rx<ApiCallStatus> notificationCountApiCallStatus = ApiCallStatus.holding.obs;
  RxInt notificationCount = 0.obs;
  Future<void> fetchNotificationCount() async {
    await BaseClient.safeApiCall(
      ApiPaths.notificationOverview,
      RequestType.get,
      onLoading: () {
        notificationCountApiCallStatus.value = ApiCallStatus.loading;
      },
      onSuccess: (response) {
        notificationCount.value = response.data['result'] ?? 0;
        notificationCountApiCallStatus.value = ApiCallStatus.success;
      },

      onError: (error) {
        notificationCountApiCallStatus.value = ApiCallStatus.error;
      },
    );
  }
}
