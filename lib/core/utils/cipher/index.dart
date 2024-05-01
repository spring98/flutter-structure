// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cipher {
  static final Cipher instance = Cipher._internal();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  late Key key;
  late IV iv;

  Cipher._internal() {
    print('secure storage initialized');
  }

  Future<void> initKeys() async {
    String? storedKey = await read('encryption_key');
    String? storedIv = await read('encryption_iv');

    if (storedKey == null || storedIv == null) {
      // 키와 벡터가 없는 경우 새로 생성해서 저장
      var newKey = Key.fromSecureRandom(32);
      var newIv = IV.fromSecureRandom(16);
      await write('encryption_key', base64Url.encode(newKey.bytes));
      await write('encryption_iv', base64Url.encode(newIv.bytes));
      key = newKey;
      iv = newIv;

      return;
    }

    key = Key.fromBase64(storedKey);
    iv = IV.fromBase64(storedIv);
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
    }
  }

  Future<String?> read(String key) async {
    try {
      String? value = await _storage.read(key: key);
      print('Read from secure storage: $value');
      return value;
    } catch (e) {
      print('Error reading from secure storage: $e');
      return null;
    }
  }

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
}
