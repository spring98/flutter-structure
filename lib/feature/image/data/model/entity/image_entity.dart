import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'image_entity.g.dart';

@HiveType(typeId: 0)
class ImageEntity extends HiveObject {
  @HiveField(0)
  final String imageId;

  @HiveField(1)
  final DateTime updateTime;

  @HiveField(2)
  final Uint8List image;

  ImageEntity(this.imageId, this.updateTime, this.image);
}
