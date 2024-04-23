import 'package:structure/feature/image/data/model/dto/image_dto.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';

extension ToImageModel on ImageDto {
  ImageModel toImageModel() {
    assert(imageId != null);
    assert(updateTime != null);

    return ImageModel(
      imageId: imageId!,
      updateTime: DateTime.tryParse(updateTime!) ?? DateTime.now(),
    );
  }
}

extension ToImageDto on ImageModel {
  ImageDto toImageDto() {
    return ImageDto(
      imageId: imageId,
      updateTime: updateTime.toString(),
    );
  }
}

// extension ToImageModelFromEntity on ImageEntity {
//   ImageModel toImageModel() {
//     return ImageModel( fileId, updateTime, file);
//   }
// }
