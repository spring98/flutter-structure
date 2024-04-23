import 'package:injectable/injectable.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@singleton
class UpdateImageUseCase {
  final ImageRepository _repository;

  UpdateImageUseCase(this._repository);

  Future<ResultModel> call(String imageId) async {
    return _repository.updateImage(imageId);
  }
}
