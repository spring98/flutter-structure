import 'package:injectable/injectable.dart';
import 'package:structure/feature/image/domain/use_cases/create_image_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_image_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_images_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/update_image_use_case.dart';

@singleton
class HomeUseCases {
  final CreateImageUseCase createImageUseCase;
  final FetchImagesUseCase fetchImagesUseCase;
  final FetchImageUseCase fetchImageUseCase;
  final UpdateImageUseCase updateImageUseCase;

  HomeUseCases(
    this.createImageUseCase,
    this.fetchImagesUseCase,
    this.fetchImageUseCase,
    this.updateImageUseCase,
  );
}
