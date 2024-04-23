import 'dart:typed_data';

enum SourceType { server, disk, ram }

extension SourceTypeExtension on SourceType {
  String name() {
    return switch (this) {
      SourceType.server => 'SERVER',
      SourceType.disk => 'DISK',
      SourceType.ram => 'RAM',
    };
  }
}

class ImageModel {
  final String imageId;
  final DateTime updateTime;
  final Uint8List image;
  final SourceType type;

  ImageModel({
    required this.imageId,
    required this.updateTime,
    required this.image,
    required this.type,
  });
}
