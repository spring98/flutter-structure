// ignore_for_file: sized_box_for_whitespace, avoid_print, prefer_const_constructors, non_constant_identifier_names
import 'dart:typed_data';
import 'package:structure/feature/image/domain/model/image_model.dart';

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
    _cachedFile[imageId] = ImageModel(
      imageId: imageId,
      updateTime: updateTime,
      image: image,
      type: SourceType.ram,
    );
  }
}
