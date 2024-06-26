import 'package:injectable/injectable.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@singleton
class FetchImageUseCase {
  final ImageRepository _repository;

  FetchImageUseCase(this._repository);

  Future<Result<ImageModel>> call(
      String imageId, DateTime requestUpdateTime) async {
    return _repository.fetchImage(imageId, requestUpdateTime);
  }
}
