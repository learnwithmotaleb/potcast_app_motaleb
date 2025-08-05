import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/see/controller/see_all_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'model/see_all_model.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key, required this.title});
  final String title;

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final controller = Get.put(SeeAllController());

  @override
  void initState() {
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.getPodcast(pageKey, widget.title);
    });
    super.initState();
  }


  @override
  void dispose() {
    Get.delete<SeeAllController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title.tr),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          controller.pagingController.refresh();
        },
        child: PagedListView<int, SeeAllPodcast>(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<SeeAllPodcast>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id??"",
                title: item.title??"",
                image: item.cover??"",
                categories: item.category?.title??"",
                duration: item.audioDuration.toString(),
              );
              return MusicCard(
                data: data,
                onTap: (){},
                // onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id??""),
              );
            },
          ),
        ),
      ),
    );
  }
}
