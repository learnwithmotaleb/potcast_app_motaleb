import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/admin/controller/admin_podcast_controller.dart';
import 'package:podcast/presentation/screens/admin/model/admin_podcast_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';

class AdminPodcastScreen extends StatefulWidget {
  const AdminPodcastScreen({super.key, required this.name});
  final String name;
  @override
  State<AdminPodcastScreen> createState() => _AdminPodcastScreenState();
}

class _AdminPodcastScreenState extends State<AdminPodcastScreen> {
  final controller = Get.find<AdminPodcastController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          controller.pagingController.refresh();
        },
        child: PagedListView<int, AdminPodcast>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<AdminPodcast>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id??"",
                title: item.title??"",
                image: item.cover??"",
                categories: item.category?.title??"",
                duration: item.audioDuration.toString(),
                artist: item.creator?.user?.name??"",
              );
              return MusicCard(
                data: data,
                onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id??""),
              );
            },
          ),
        ),
      ),
    );
  }
}
