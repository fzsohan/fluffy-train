

import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {

  /// Derives a 32-byte AES key from the secret using 
  Uint8List _getEncryptionKey() {
    final secretBytes = utf8.encode(dotenv.env['ENCRYPTION_KEY'] ?? '');
    final digest = .convert(secretBytes);
    return Uint8List.fromList(digest.bytes);
  }

  /// Decrypts the base64 `iv:encrypted` string back into a Dart object
  Map<String, dynamic> decryptData(String token) {
    final parts = token.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid token format');
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedData = parts[1];

    final key = encrypt.Key(_getEncryptionKey());
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

    final result = jsonDecode(decrypted);
    final type = result is List ? 'array' : result.runtimeType.toString();

    return {'type': type, 'result': result};
  }
}
