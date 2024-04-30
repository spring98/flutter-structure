// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cipher {
  // static const FlutterSecureStorage _storage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(encryptedSharedPreferences: true),
  // );
  //
  static final Cipher instance = Cipher._internal();
  Cipher._internal() {
    print('secure storage initialized');
  }
  //
  // Future<void> write(String key, String value) async {
  //   try {
  //     await _storage.write(key: key, value: value);
  //   } catch (e) {
  //     print('Error writing to secure storage: $e');
  //     // Handle exceptions or rethrow to be handled at a higher level
  //   }
  // }
  //
  // Future<String?> read(String key) async {
  //   try {
  //     String? value = await _storage.read(key: key);
  //     print('Read from secure storage: $value');
  //     return value;
  //   } catch (e) {
  //     print('Error reading from secure storage: $e');
  //     // Handle exceptions or rethrow to be handled at a higher level
  //     return null;
  //   }
  // }

  final key = Key.fromUtf8('a00aa00000aaaaaaafdfdfdf98989889');
  final iv = IV.fromUtf8('aa00aaaa00aadfff');

  Uint8List encryptImage(Uint8List image) {
    // AES 알고리즘 중 CBC 모드를 사용해서 Raw Uint8List >> Encrypted Uint8List 암호화
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(image, iv: iv);

    return encrypted.bytes;
  }

  Uint8List decryptImage(Uint8List encryptedImage) {
    // AES 알고리즘 중 CBC 모드를 사용해서 Encrypted Uint8List >> Raw Uint8List 복호화
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decryptBytes(Encrypted(encryptedImage), iv: iv);

    return Uint8List.fromList(decrypted);
  }

  String imageToHash(Uint8List data) {
    return sha256.convert(data).toString();
  }

  Future<void> generateKey() async {}
}
