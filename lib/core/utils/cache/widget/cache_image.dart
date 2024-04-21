// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class CacheImage extends StatefulWidget {
//   final String? fileId;
//   final DateTime updateTime;
//   final bool isWorker;
//
//   const CacheImage({
//     Key? key,
//     required this.fileId,
//     required this.updateTime,
//     required this.isWorker,
//   }) : super(key: key);
//
//   @override
//   State<CacheImage> createState() => _CacheImageState();
// }
//
// class _CacheImageState extends State<CacheImage> {
//   final _workerUseCase = getIt<FetchWorkerByteFileUseCase>();
//   final _userUseCase = getIt<FetchUserByteFileUseCase>();
//   Future<Result<Uint8List>>? _imageFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeImageFuture();
//   }
//
//   void _initializeImageFuture() {
//     if (widget.fileId != null) {
//       _imageFuture = widget.isWorker
//           ? _workerUseCase(widget.fileId!, widget.updateTime)
//           : _userUseCase(widget.fileId!, widget.updateTime);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.fileId == null) {
//       return _emptyImage();
//     }
//
//     // 인메모리 캐시에 해당 파일이 없는 경우
//     // 서버에 해당 파일을 요청
//     return FutureBuilder<Result<Uint8List>>(
//       future: _imageFuture,
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//             return _emptyImage();
//
//           case ConnectionState.done:
//           case ConnectionState.active:
//             // 서버에 해당 이미지 파일이 없을 때
//             if (snapshot.data == null) {
//               return _emptyImage();
//             }
//
//             final result = snapshot.data!;
//             switch (result) {
//               // 성공적으로 서버로 부터 이미지 파일을 받는 경우
//               case Success<Uint8List>():
//                 return SizedBox(
//                   width: 40.w,
//                   height: 40.w,
//                   child: Image.memory(
//                     result.data,
//                     fit: BoxFit.cover,
//                     gaplessPlayback: true,
//                   ),
//                 );
//
//               // 서버로 부터 이미지 파일을 받는 데 실패 한 경우
//               case Error<Uint8List>():
//                 return _emptyImage();
//             }
//         }
//       },
//     );
//   }
//
//   Widget _emptyImage() {
//     return Container(
//       width: 40.w,
//       height: 40.w,
//       color: Colors.grey,
//     );
//   }
// }
