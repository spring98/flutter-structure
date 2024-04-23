import 'package:injectable/injectable.dart';
import 'package:structure/config/model/result.dart';
import 'package:structure/feature/image/domain/repository/image_repository.dart';

@singleton
class CreateImageUseCase {
  final ImageRepository _repository;

  CreateImageUseCase(this._repository);

  Future<ResultModel> call() async {
    return _repository.createImage();
  }
}
