// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageEntityAdapter extends TypeAdapter<ImageEntity> {
  @override
  final int typeId = 0;

  @override
  ImageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageEntity(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, ImageEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imageId)
      ..writeByte(1)
      ..write(obj.updateTime)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
