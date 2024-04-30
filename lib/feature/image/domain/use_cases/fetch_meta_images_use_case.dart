import 'package:injectable/injectable.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/meta_image_model.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@singleton
class FetchMetaImagesUseCase {
  final ImageRepository _repository;

  FetchMetaImagesUseCase(this._repository);

  Future<Result<List<MetaImageModel>>> call() async {
    return _repository.fetchMetaImages();
  }
}
