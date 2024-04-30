import 'package:injectable/injectable.dart';
import 'package:structure/feature/image/domain/use_cases/create_image_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/delete_all_image_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_image_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_meta_images_use_case.dart';
import 'package:structure/feature/image/domain/use_cases/update_image_use_case.dart';

@singleton
class HomeUseCases {
  final CreateImageUseCase createImageUseCase;
  final FetchMetaImagesUseCase fetchImagesUseCase;
  final FetchImageUseCase fetchImageUseCase;
  final UpdateImageUseCase updateImageUseCase;
  final DeleteAllImageUseCase deleteAllImageUseCase;

  HomeUseCases(
    this.createImageUseCase,
    this.fetchImagesUseCase,
    this.fetchImageUseCase,
    this.updateImageUseCase,
    this.deleteAllImageUseCase,
  );
}
