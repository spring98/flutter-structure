import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:structure/config/di/di_setup.dart';
import 'package:structure/config/model/sealed_result.dart';
import 'package:structure/core/utils/cache/widget/cache_image.dart';
import 'package:structure/core/utils/cipher/index.dart';
import 'package:structure/feature/home/view/home_view_model.dart';
import 'package:structure/feature/image/domain/model/meta_image_model.dart';
import 'package:structure/feature/image/domain/model/image_model.dart';
import 'package:structure/feature/image/domain/use_cases/fetch_image_use_case.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Random Image Generator Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, p, child) {
          if (p.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(0),
            child: RefreshIndicator(
              displacement: 4,
              onRefresh: () async => p.fetchMetaImages(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      itemCount: p.images.length,
                      itemBuilder: (context, index) {
                        return _card(p, p.images[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(child: _buttons()),
    );
  }

  Widget _card(HomeViewModel p, MetaImageModel model) {
    Color clickedColor = Colors.white;

    if (p.imageId == model.imageId) {
      clickedColor = const Color(0xFFFFEDEA);
    }

    return Container(
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFDADADA),
          ),
        ),
        color: clickedColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            p.updateId(model.imageId);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CacheImage(
                        fileId: model.imageId, updateTime: model.updateTime),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: '),
                        Text('Update: '),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.imageId,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(intl.DateFormat('MM월 dd일 HH:mm:ss.SSS')
                              .format(model.updateTime)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _card(HomeViewModel p, MetaImageModel model) {
  //   Color clickedColor = Colors.white;
  //
  //   if (p.imageId == model.imageId) {
  //     clickedColor = const Color(0xFFFFEDEA);
  //   }
  //
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: const Border(
  //         bottom: BorderSide(
  //           color: Color(0xFFDADADA),
  //         ),
  //       ),
  //       color: clickedColor,
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: () {
  //           p.updateId(model.imageId);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   CacheImage(
  //                       fileId: model.imageId, updateTime: model.updateTime),
  //                   const SizedBox(width: 20),
  //                   const Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('ID: '),
  //                       Text('Update: '),
  //                       Text('Image Hash: '),
  //                       Text('Encrypt Hash: '),
  //                       Text('Decrypt Hash: '),
  //                     ],
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: FutureBuilder<Result<ImageModel>>(
  //                         future: getIt<FetchImageUseCase>()(
  //                             model.imageId, model.updateTime),
  //                         builder: (context, snapshot) {
  //                           switch (snapshot.connectionState) {
  //                             case ConnectionState.none:
  //                             case ConnectionState.waiting:
  //                               return Container();
  //
  //                             case ConnectionState.done:
  //                             case ConnectionState.active:
  //                               // 서버에 해당 이미지 파일이 없을 때
  //                               if (snapshot.data == null) {
  //                                 return Container();
  //                               }
  //
  //                               final result = snapshot.data!;
  //                               switch (result) {
  //                                 // 성공적으로 서버로 부터 이미지 파일을 받는 경우
  //                                 case Success<ImageModel>():
  //                                   final image = result.data.image;
  //                                   final encrypted =
  //                                       Cipher.instance.encryptImage(image);
  //                                   final decrypted =
  //                                       Cipher.instance.decryptImage(encrypted);
  //
  //                                   return Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         model.imageId,
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                       Text(intl.DateFormat(
  //                                               'MM월 dd일 HH:mm:ss.SSS')
  //                                           .format(model.updateTime)),
  //                                       Text(
  //                                         Cipher.instance.imageToHash(image),
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                       Text(
  //                                         Cipher.instance
  //                                             .imageToHash(encrypted),
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                       Text(
  //                                         Cipher.instance
  //                                             .imageToHash(decrypted),
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                     ],
  //                                   );
  //
  //                                 // 서버로 부터 이미지 파일을 받는 데 실패 한 경우
  //                                 case Error<ImageModel>():
  //                                   return Container();
  //                               }
  //                           }
  //                         }),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buttons() {
    final p = context.read<HomeViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _button(
              title: 'Create',
              onTap: () => p.createImage(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _button(
              title: 'Update',
              onTap: () => p.updateImage(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _button(
              title: 'Delete Disk',
              onTap: () => p.deleteAllImage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        color: Colors.green,
        child: Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}
