import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:structure/config/di/di_setup.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/feature/image/domain/model/file_model.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_image_use_case.dart';

class CacheImage extends StatefulWidget {
  final String fileId;
  final DateTime updateTime;

  const CacheImage({
    Key? key,
    required this.fileId,
    required this.updateTime,
  }) : super(key: key);

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  final _useCase = getIt<FetchImageUseCase>();
  Future<Result<FileModel>>? _imageFuture;

  @override
  void initState() {
    super.initState();
    _initializeImageFuture();
  }

  void _initializeImageFuture() {
    _imageFuture = _useCase(widget.fileId, widget.updateTime);
  }

  @override
  Widget build(BuildContext context) {
    // 인메모리 캐시에 해당 파일이 없는 경우
    // 서버에 해당 파일을 요청
    return FutureBuilder<Result<FileModel>>(
      future: _imageFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _emptyImage();

          case ConnectionState.done:
          case ConnectionState.active:
            // 서버에 해당 이미지 파일이 없을 때
            if (snapshot.data == null) {
              return _emptyImage();
            }

            final result = snapshot.data!;
            switch (result) {
              // 성공적으로 서버로 부터 이미지 파일을 받는 경우
              case Success<FileModel>():
                return Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.memory(
                        result.data.image,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                    Text(
                      result.data.type.name(),
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                );

              // 서버로 부터 이미지 파일을 받는 데 실패 한 경우
              case Error<FileModel>():
                return _emptyImage();
            }
        }
      },
    );
  }

  Widget _emptyImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey,
    );
  }
}
