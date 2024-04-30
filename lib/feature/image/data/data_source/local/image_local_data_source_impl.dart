import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/core/utils/cipher/index.dart';
import 'package:structure/feature/image/data/data_source/local/image_local_data_source.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'package:synchronized/synchronized.dart';

@Singleton(as: ImageLocalDataSource)
class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  static const db = 'image.db';
  final lock = Lock();

  @override
  Future<Result<ImageEntity>> getImage(String imageId) async {
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
  Future<ResultModel> setImage(ImageEntity imageEntity) async {
    await lock.synchronized(() async {
      try {
        final box = await Hive.openBox<ImageEntity>(db);
        DateTime updateTime = imageEntity.updateTime;
        String imageId = imageEntity.imageId;

        // 이미지 사이즈 계산 및 오래된 이미지 키 찾기
        String? oldImageId;
        DateTime oldUpdateTime = DateTime.now();

        for (var imageEntity in box.values) {
          if (imageEntity.updateTime.isBefore(oldUpdateTime)) {
            oldUpdateTime = imageEntity.updateTime;
            oldImageId = imageEntity.imageId;
          }
        }

        // 최대 개수 초과 시 가장 오래된 이미지 삭제
        if (oldImageId != null && box.values.length == 4) {
          // 넣으려고 하는 데이터(updateTime)가 더 최신일 때만 업데이트하기
          if (updateTime.isAfter(oldUpdateTime)) {
            await deleteImage(oldImageId);
            await box.put(imageId, imageEntity);
          }
        }

        // 최대 개수 초과되지 않았을 때
        else {
          await box.put(imageId, imageEntity);
        }

        return ResultModel(isSuccess: true);
      } catch (e) {
        return ResultModel(isSuccess: false, message: e.toString());
      }
    });

    return ResultModel(isSuccess: true);
  }

  @override
  Future<ResultModel> deleteImage(String imageId) async {
    try {
      final box = await Hive.openBox<ImageEntity>(db);
      await box.delete(imageId);
      await box.flush();

      return ResultModel(isSuccess: true);
    } catch (e) {
      return ResultModel(isSuccess: false, message: e.toString());
    }
  }

  @override
  Future<ResultModel> deleteAllImage() async {
    try {
      final box = await Hive.openBox<ImageEntity>(db);
      await box.clear();

      return ResultModel(isSuccess: true);
    } catch (e) {
      return ResultModel(isSuccess: false, message: e.toString());
    }
  }
}
