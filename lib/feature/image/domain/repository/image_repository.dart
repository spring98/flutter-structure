import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/image_meta_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';

abstract class ImageRepository {
  Future<ResultModel> createImage();

  Future<Result<List<ImageMetaModel>>> fetchImages();

  Future<Result<ImageModel>> fetchImage(
      String imageId, DateTime requestUpdateTime);

  Future<ResultModel> updateImage(String imageId);
}
