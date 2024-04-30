import 'package:structure/core/utils/cipher/index.dart';
import 'package:structure/feature/image/data/model/dto/image_dto.dart';
import 'package:structure/feature/image/data/model/dto/meta_image_dto.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'package:structure/feature/image/domain/model/meta_image_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';

extension ToImageMetaModel on MetaImageDto {
  MetaImageModel toImageModel() {
    assert(imageId != null);
    assert(updateTime != null);

    return MetaImageModel(
      imageId: imageId!,
      updateTime: DateTime.tryParse(updateTime!) ?? DateTime.now(),
    );
  }
}

extension ToImageMetaDto on MetaImageModel {
  MetaImageDto toImageDto() {
    return MetaImageDto(
      imageId: imageId,
      updateTime: updateTime.toString(),
    );
  }
}

extension ToImageModelFromEntity on ImageEntity {
  ImageModel toImageModel() {
    return ImageModel(
      imageId: imageId,
      updateTime: updateTime,
      image: Cipher.instance.decryptImage(image),
      type: SourceType.disk,
    );
  }
}

extension ToImageEntity on ImageModel {
  ImageEntity toImageEntity() {
    return ImageEntity(
      imageId,
      updateTime,
      Cipher.instance.encryptImage(image),
    );
  }
}

extension ToImageModelFromDto on ImageDto {
  ImageModel toImageModel() {
    return ImageModel(
      imageId: imageId,
      updateTime: updateTime,
      image: Cipher.instance.decryptImage(image),
      type: SourceType.ram,
    );
  }
}

extension ToImageDto on ImageModel {
  ImageDto toImageDto() {
    return ImageDto(
      imageId: imageId,
      updateTime: updateTime,
      image: Cipher.instance.encryptImage(image),
    );
  }
}
