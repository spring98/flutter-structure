import 'package:structure/feature/image/data/model/dto/image_dto.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'package:structure/feature/image/domain/model/image_meta_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';

extension ToImageMetaModel on ImageMetaDto {
  ImageMetaModel toImageModel() {
    assert(imageId != null);
    assert(updateTime != null);

    return ImageMetaModel(
      imageId: imageId!,
      updateTime: DateTime.tryParse(updateTime!) ?? DateTime.now(),
    );
  }
}

extension ToImageMetaDto on ImageMetaModel {
  ImageMetaDto toImageDto() {
    return ImageMetaDto(
      imageId: imageId,
      updateTime: updateTime.toString(),
    );
  }
}

extension ToImageModel on ImageEntity {
  ImageModel toImageModel() {
    return ImageModel(
      imageId: imageId,
      updateTime: updateTime,
      image: image,
      type: SourceType.disk,
    );
  }
}
