import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/core/utils/image/widget/random_image_generator.dart';
import 'package:structure/feature/image/data/data_source/remote/image_remote_data_source.dart';
import 'package:structure/feature/image/data/model/dto/image_dto.dart';
import 'package:uuid/uuid.dart';

@Singleton(as: ImageRemoteDataSource)
class ImageRemoteDataSourceImpl extends ImageRemoteDataSource {
  final _store = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();

  @override
  Future<ResultModel> createImage() async {
    final id = const Uuid().v4();
    try {
      final randomImage =
          await RandomImageGenerator.createImageFromCanvas(256, 256);

      await _storage.child("images/$id.png").putData(
            randomImage,
            SettableMetadata(contentType: 'image/png'),
          );

      await _store.collection("images").doc(id).set({
        'imageId': id,
        'updateTime':
            DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now()),
      });

      return ResultModel(isSuccess: true);
    } catch (e) {
      return ResultModel(isSuccess: false, message: e.toString());
    }
  }

  @override
  Future<Result<Uint8List?>> fetchImage(String imageId) async {
    try {
      final result = await _storage.child("images/$imageId.png").getData();

      print('${result?.length} 바이트');
      return Result.success(result);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<List<ImageDto>>> fetchImages() async {
    try {
      final snapshot = await _store.collection("images").get();

      final result =
          snapshot.docs.map((e) => ImageDto.fromJson(e.data())).toList();

      return Result.success(result);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<ResultModel> updateImage(String imageId) async {
    try {
      await _store.collection("images").doc(imageId).update({
        'imageId': imageId,
        'updateTime':
            DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now()),
      });

      return ResultModel(isSuccess: true);
    } catch (e) {
      return ResultModel(isSuccess: false);
    }
  }
}
