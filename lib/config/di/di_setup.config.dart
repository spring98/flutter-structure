// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:structure/feature/home/domain/use_cases/index.dart' as _i14;
import 'package:structure/feature/home/view/home_view_model.dart' as _i15;
import 'package:structure/feature/image/data/data_source/local/image_local_data_source.dart'
    as _i3;
import 'package:structure/feature/image/data/data_source/local/image_local_data_source_impl.dart'
    as _i4;
import 'package:structure/feature/image/data/data_source/remote/image_remote_data_source.dart'
    as _i5;
import 'package:structure/feature/image/data/data_source/remote/image_remote_data_source_impl.dart'
    as _i6;
import 'package:structure/feature/image/data/repository/image_repository_impl.dart'
    as _i8;
import 'package:structure/feature/image/domain/repository/image_repository.dart'
    as _i7;
import 'package:structure/feature/image/domain/use_cases/create_image_use_case.dart'
    as _i10;
import 'package:structure/feature/image/domain/use_cases/delete_all_image_use_case.dart'
    as _i11;
import 'package:structure/feature/image/domain/use_cases/fetch_image_use_case.dart'
    as _i12;
import 'package:structure/feature/image/domain/use_cases/fetch_meta_images_use_case.dart'
    as _i13;
import 'package:structure/feature/image/domain/use_cases/update_image_use_case.dart'
    as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.ImageLocalDataSource>(
        () => _i4.ImageLocalDataSourceImpl());
    gh.singleton<_i5.ImageRemoteDataSource>(
        () => _i6.ImageRemoteDataSourceImpl());
    gh.singleton<_i7.ImageRepository>(() => _i8.ImageRepositoryImpl(
          gh<_i5.ImageRemoteDataSource>(),
          gh<_i3.ImageLocalDataSource>(),
        ));
    gh.singleton<_i9.UpdateImageUseCase>(
        () => _i9.UpdateImageUseCase(gh<_i7.ImageRepository>()));
    gh.singleton<_i10.CreateImageUseCase>(
        () => _i10.CreateImageUseCase(gh<_i7.ImageRepository>()));
    gh.singleton<_i11.DeleteAllImageUseCase>(
        () => _i11.DeleteAllImageUseCase(gh<_i7.ImageRepository>()));
    gh.singleton<_i12.FetchImageUseCase>(
        () => _i12.FetchImageUseCase(gh<_i7.ImageRepository>()));
    gh.singleton<_i13.FetchMetaImagesUseCase>(
        () => _i13.FetchMetaImagesUseCase(gh<_i7.ImageRepository>()));
    gh.singleton<_i14.HomeUseCases>(() => _i14.HomeUseCases(
          gh<_i10.CreateImageUseCase>(),
          gh<_i13.FetchMetaImagesUseCase>(),
          gh<_i12.FetchImageUseCase>(),
          gh<_i9.UpdateImageUseCase>(),
          gh<_i11.DeleteAllImageUseCase>(),
        ));
    gh.factory<_i15.HomeViewModel>(
        () => _i15.HomeViewModel(gh<_i14.HomeUseCases>()));
    return this;
  }
}
