import 'dart:typed_data';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/data/model/dto/meta_image_dto.dart';

abstract class ImageRemoteDataSource {
  Future<Result<Uint8List>> fetchImage(String imageId);
  Future<Result<List<MetaImageDto>>> fetchImages();
  Future<ResultModel> createImage();
  Future<ResultModel> updateImage(String imageId);
}
