import 'package:injectable/injectable.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@singleton
class FetchImagesUseCase {
  final ImageRepository _repository;

  FetchImagesUseCase(this._repository);

  Future<Result<List<ImageModel>>> call() async {
    return _repository.fetchImages();
  }
}
