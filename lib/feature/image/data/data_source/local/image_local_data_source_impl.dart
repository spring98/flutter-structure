import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/data/data_source/local/image_local_data_source.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';

@Singleton(as: ImageLocalDataSource)
class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  static const db = 'image.db';

  @override
  Future<Result<ImageEntity>> getByteFile(String imageId) async {
    try {
      final box = await Hive.openBox<ImageEntity>(db);
      final data = box.get(imageId);

      if (data == null) {
        return Result.error('데이터 에러');
      }

      return Result.success(data);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<ResultModel> setByteFile(
      String imageId, DateTime updateTime, Uint8List file) async {
    try {
      final box = await Hive.openBox<ImageEntity>(db);
      await box.put(imageId, ImageEntity(imageId, updateTime, file));

      return ResultModel(isSuccess: true);
    } catch (e) {
      return ResultModel(isSuccess: false, message: e.toString());
    }
  }
}
