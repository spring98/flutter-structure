import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:structure/core/utils/cache/widget/cache_image.dart';
import 'package:structure/feature/home/view/home_view_model.dart';
import 'package:structure/feature/image/domain/model/image_meta_model.dart';

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
          'Random Image Generator',
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
              onRefresh: () async => p.fetchImages(),
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

  Widget _card(HomeViewModel p, ImageMetaModel model) {
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
