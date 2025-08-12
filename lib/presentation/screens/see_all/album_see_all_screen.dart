import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/see_all/model/see_all_album_model.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';

import 'controller/see_all_controller.dart';

class AlbumSeeAllScreen extends StatefulWidget {
  const AlbumSeeAllScreen({super.key});

  @override
  State<AlbumSeeAllScreen> createState() => _AlbumSeeAllScreenState();
}

class _AlbumSeeAllScreenState extends State<AlbumSeeAllScreen> {
  final controller = Get.find<SeeAllController>();
  final pagingController = PagingController<int, SeeAllAlbumItem>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getAllAlbum(
        pageKey: pageKey,
        pagingController: pagingController,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Album"),
      ),
      body: PagedGridView<int, SeeAllAlbumItem>(
        pagingController: pagingController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        builderDelegate: PagedChildBuilderDelegate<SeeAllAlbumItem>(
          itemBuilder: (context, item, index) {
            final data = AudioPlayerModel(
              id: item.id ?? "",
              title: item.name ?? "",
              image: item.coverImage ?? "",
              duration: "",
              url: "",
            );
            return CreatorCard(
              data: data,
              onTap: (){},
            );
          },
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 200,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
