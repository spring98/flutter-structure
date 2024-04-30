import 'dart:typed_data';

class ImageDto {
  final String imageId;
  final DateTime updateTime;
  final Uint8List image;

  ImageDto({
    required this.imageId,
    required this.updateTime,
    required this.image,
  });
}
