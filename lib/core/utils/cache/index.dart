// ignore_for_file: sized_box_for_whitespace, avoid_print, prefer_const_constructors, non_constant_identifier_names

import 'dart:typed_data';

class MemoryCache {
  /// 파일을 인메모리 저장
  static final Map<String, Uint8List> _cachedFile = {};

  static Uint8List? getFile(String fileId) {
    if (!_cachedFile.containsKey(fileId)) {
      return null;
    }

    return _cachedFile[fileId];
  }

  static void setFile(String fileId, Uint8List data) {
    _cachedFile[fileId] = data;
  }
}
