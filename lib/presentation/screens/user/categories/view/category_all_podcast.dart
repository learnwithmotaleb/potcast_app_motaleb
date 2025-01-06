import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/user/categories/controller/category_all_podcast_controller.dart';
import 'package:podcast/presentation/screens/user/categories/model/sub_category_podcast.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';

class CategoryAllPodcast extends StatefulWidget {
  const CategoryAllPodcast({super.key, required this.id});

  final String id;

  @override
  State<CategoryAllPodcast> createState() => _CategoryAllPodcastState();
}

class _CategoryAllPodcastState extends State<CategoryAllPodcast> {
  final controller = Get.put(CategoryAllPodcastController());

  @override
  void initState() {
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.getPodcast(pageKey, widget.id);
    });
    super.initState();
  }


  @override
  void dispose() {
    Get.delete<CategoryAllPodcastController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("podcast".tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: PagedListView<int, CategoryPodcast>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<CategoryPodcast>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id ?? "",
                title: item.title ?? "",
                image: item.cover ?? "",
                categories: item.category?.title ?? "",
                duration: item.audioDuration.toString(),
              );
              return MusicCard(
                data: data,
                onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id ?? ""),
              );
            },
          ),
        ),
      ),
    );
  }
}
