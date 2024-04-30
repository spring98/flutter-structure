import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/image_meta_model.dart';
import 'package:structure/feature/home/domain/use_cases/index.dart';

@injectable
class HomeViewModel extends ChangeNotifier {
  final HomeUseCases _useCases;

  HomeViewModel(this._useCases) {
    fetchImages();
  }

  bool isLoading = false;
  String? imageId;
  void updateId(String? id) {
    imageId = id;
    notifyListeners();
  }

  Future<void> createImage() async {
    isLoading = true;
    notifyListeners();

    await _useCases.createImageUseCase();

    fetchImages();
  }

  List<ImageMetaModel> images = [];
  Future<void> fetchImages() async {
    isLoading = true;
    notifyListeners();

    final result = await _useCases.fetchImagesUseCase();

    switch (result) {
      case Success<List<ImageMetaModel>>():
        images = result.data.toList();

      case Error<List<ImageMetaModel>>():
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateImage() async {
    if (imageId == null) {
      return;
    }

    isLoading = true;
    notifyListeners();

    await _useCases.updateImageUseCase(imageId!);

    fetchImages();
  }

  Future<void> deleteAllImage() async {
    isLoading = true;
    notifyListeners();

    await _useCases.deleteAllImageUseCase();

    isLoading = false;
    notifyListeners();
  }
}
