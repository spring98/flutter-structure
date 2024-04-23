import 'dart:typed_data';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';

abstract class ImageLocalDataSource {
  Future<Result<ImageEntity>> getImage(String fileId);
  Future<ResultModel> setImage(
      String fileId, DateTime updateTime, Uint8List file);
}
