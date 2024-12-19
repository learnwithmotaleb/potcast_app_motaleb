/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/creator/home/widget/creator_top_section.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/my_podcast_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'controller/creator_home_controller.dart';

class CreatorHomeScreen extends StatefulWidget {
  const CreatorHomeScreen({super.key});

  @override
  State<CreatorHomeScreen> createState() => _CreatorHomeScreenState();
}

class _CreatorHomeScreenState extends State<CreatorHomeScreen> {
  final _controller = Get.find<CreatorHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          _controller.pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CreatorTopSection(),
            ),
            PagedSliverList<int, MyPodcastData>(
              pagingController: _controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<MyPodcastData>(
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
                    onTap: (){},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
