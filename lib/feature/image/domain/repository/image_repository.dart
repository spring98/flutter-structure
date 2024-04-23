import 'dart:typed_data';

import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/file_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';

abstract class ImageRepository {
  Future<ResultModel> createImage();

  Future<Result<List<ImageModel>>> fetchImages();

  Future<Result<FileModel>> fetchImage(
      String imageId, DateTime requestUpdateTime);

  Future<ResultModel> updateImage(String imageId);
}
