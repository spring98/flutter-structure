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

class FileModel {
  final Uint8List image;
  final SourceType type;

  FileModel(this.image, this.type);
}
