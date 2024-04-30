// ignore_for_file: sized_box_for_whitespace, avoid_print, prefer_const_constructors, non_constant_identifier_names
import 'dart:typed_data';
import 'package:structure/feature/image/domain/model/image_model.dart';
import 'package:synchronized/synchronized.dart';

class MemoryCache {
  /// 파일을 인메모리 저장
  static final Map<String, ImageModel> _cachedFile = {};

  static Uint8List? getImage(String imageId, DateTime requestUpdateTime) {
    // 데이터가 있는 지 확인
    if (!_cachedFile.containsKey(imageId) || _cachedFile[imageId] == null) {
      return null;
    }

    // 메모리 데이터가 최신이 아닌 경우
    if (_cachedFile[imageId]!.updateTime.isBefore(requestUpdateTime)) {
      _cachedFile.remove(imageId);
      return null;
    }

    return _cachedFile[imageId]!.image;
  }

  static void setImage(String imageId, DateTime updateTime, Uint8List image) {
    String? oldestKey;
    DateTime oldestDate = DateTime.now();
    int size = 0;

    _cachedFile.forEach((key, value) {
      if (value.updateTime.isBefore(oldestDate)) {
        oldestDate = value.updateTime;
        oldestKey = key;
      }
      size += value.image.length;
    });

    // 최대 개수 초과 시 가장 오래된 이미지 삭제
    if (_cachedFile.length == 4 || size > 1000) {
      // 넣으려고 하는 데이터(updateTime)가 더 최신일 때만 업데이트하기
      if (updateTime.isAfter(oldestDate)) {
        _cachedFile.remove(oldestKey);
        _cachedFile[imageId] = ImageModel(
          imageId: imageId,
          updateTime: updateTime,
          image: image,
          type: SourceType.ram,
        );
      }
    }

    // 최대 개수 초과되지 않았을 때
    else {
      _cachedFile[imageId] = ImageModel(
        imageId: imageId,
        updateTime: updateTime,
        image: image,
        type: SourceType.ram,
      );
    }
  }
}
