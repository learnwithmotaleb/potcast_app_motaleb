import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import '../../widget/card/creator_card.dart';
import 'controller/see_all_controller.dart';
import 'model/top_creator_model.dart';

class SeeAllTopCreator extends StatefulWidget {
  const SeeAllTopCreator({super.key});

  @override
  State<SeeAllTopCreator> createState() => _SeeAllTopCreatorState();
}

class _SeeAllTopCreatorState extends State<SeeAllTopCreator> {
  final controller = Get.find<SeeAllController>();
  final pagingController = PagingController<int, TopCreatorItem>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getTopCreator(
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
        title: const Text("Top Favorites"),
      ),
      body: PagedGridView<int, TopCreatorItem>(
        pagingController: pagingController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        builderDelegate: PagedChildBuilderDelegate<TopCreatorItem>(
          itemBuilder: (context, item, index) {
            final data = AudioPlayerModel(
              id: item.creatorId ?? "",
              title: item.name ?? "",
              image: item.profileImage ?? "",
              duration: "",
              url: "",
            );
            return CreatorCard(
              data: data,
              onTap: () => AppRouter.route.pushNamed(
                RoutePath.audioPlayScreen,
                extra: AudioPlayerModel(
                  id: item.creatorId ?? "",
                  title: item.name ?? "",
                  image: item.profileImage ?? "",
                  url: "",
                  duration: "",
                ),
              ),
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
