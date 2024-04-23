import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/core/utils/cache/index.dart';
import 'package:structure/feature/image/data/data_source/local/image_local_data_source.dart';
import 'package:structure/feature/image/data/data_source/remote/image_remote_data_source.dart';
import 'package:structure/feature/image/data/mapper/image_mapper.dart';
import 'package:structure/feature/image/data/model/dto/image_dto.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'package:structure/feature/image/domain/model/image_meta_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@Singleton(as: ImageRepository)
class ImageRepositoryImpl extends ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;
  final ImageLocalDataSource _localDataSource;

  ImageRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<ResultModel> createImage() async {
    return _remoteDataSource.createImage();
  }

  /*
     *  파라미터 수정하기: fileId, updateTime
     *
     *  로직
     *    1. fileId 로 로컬 데이터 소스에서 조회
     *      if 로컬 데이터 소스 조회에 실패
     *        리모트 데이터 소스로 이동(2번으로 이동 - no data)
     *
     *      if 로컬 데이터 소스 조회에 성공
     *        조회한 데이터의 updateTime 과 요청한 updateTime 비교
     *          if 조회한 데이터가 최신
     *             return Result.success(local-latest data)
     *
     *          if 조회한 데이터가 과거
     *             리모트 데이터 소스로 이동(2번으로 이동 - legacy data)
     *
     *    2. fileId 로 리모트 데이터 소스에서 조회
     *      if 리모트 데이터 소스 조회에 실패
     *        if legacy data 존재
     *            return Result.success(local-legacy data)
     *        else
     *            return Result.error()
     *
     *      if 리모트 데이터 소스 조회에 성공
     *        return Result.success(remote-latest data)
     */
  @override
  Future<Result<ImageModel>> fetchImage(
      String imageId, DateTime requestUpdateTime) async {
    final memoryResult = MemoryCache.getImage(imageId, requestUpdateTime);

    // 메모리(램)에 데이터가 있는 경우
    if (memoryResult != null) {
      print('[IMAGE] 램에서 꺼냄');
      return Result.success(
        ImageModel(
          imageId: imageId,
          updateTime: requestUpdateTime,
          image: memoryResult,
          type: SourceType.ram,
        ),
      );
    }

    // 메모리(램)에 데이터가 없는 경우 로컬(디스크)에서 조회
    final localResult = await _localDataSource.getImage(imageId);

    switch (localResult) {
      // 로컬 데이터(디스크)에서 성공적으로 데이터를 가져온 경우
      case Success<ImageEntity>():
        final localImage = localResult.data.toImageModel();

        // 로컬 데이터(디스크)가 최신인 경우 메모리(램)에 저장 후 그대로 반환
        if (!localImage.updateTime.isBefore(requestUpdateTime)) {
          print('[IMAGE] 디스크에서 꺼냄');

          MemoryCache.setImage(imageId, requestUpdateTime, localImage.image);
          return Result.success(localImage);
        }

        // 로컬 데이터(디스크)가 오래된 경우 리모트(서버)에서 가져옴
        return _fetchImage(imageId, requestUpdateTime,
            legacyFile: localImage.image);

      // 로컬 데이터(디스크)에서 데이터를 가져오는데 실패한 경우
      case Error<ImageEntity>():
        // 리모트(서버) 에서 가져옴
        return _fetchImage(imageId, requestUpdateTime, legacyFile: null);
    }
  }

  Future<Result<ImageModel>> _fetchImage(
    String fileId,
    DateTime requestUpdateTime, {
    Uint8List? legacyFile,
  }) async {
    final remoteResult = await _remoteDataSource.fetchImage(fileId);

    switch (remoteResult) {
      // 리모트(서버)에서 성공적으로 가져온 경우 메모리(램), 로컬(디스크)에 저장하고, 해당 데이터를 반환
      case Success<Uint8List?>():
        print('[IMAGE] 서버에서 꺼냄');
        final data = remoteResult.data;
        if (data == null) {
          return Result.error('데이터 에러');
        }

        MemoryCache.setImage(fileId, requestUpdateTime, data);
        _localDataSource.setImage(fileId, requestUpdateTime, data);

        return Result.success(
          ImageModel(
            imageId: fileId,
            image: data,
            updateTime: requestUpdateTime,
            type: SourceType.server,
          ),
        );

      // 리모트(서버)에서 데이터를 가져오지 못한 경우
      case Error<Uint8List?>():
        // 오래된 데이터라도 반환
        if (legacyFile != null) {
          return Result.success(
            ImageModel(
              imageId: fileId,
              image: legacyFile,
              updateTime: requestUpdateTime,
              type: SourceType.disk,
            ),
          );
        }

        // 오래된 데이터도 없으면 에러 반환
        return Result.error(remoteResult.e);
    }
  }

  @override
  Future<Result<List<ImageMetaModel>>> fetchImages() async {
    final result = await _remoteDataSource.fetchImages();
    switch (result) {
      case Success<List<ImageMetaDto>>():
        final data = result.data
            .where((e) => e.imageId != null && e.updateTime != null)
            .map((e) => e.toImageModel())
            .toList();

        data.sort((a, b) => b.updateTime.compareTo(a.updateTime));

        return Result.success(data);
      case Error<List<ImageMetaDto>>():
        return Result.error(result.e);
    }
  }

  @override
  Future<ResultModel> updateImage(String imageId) async {
    return _remoteDataSource.updateImage(imageId);
  }
}
