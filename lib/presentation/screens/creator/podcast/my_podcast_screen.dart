/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/podcast_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'controller/podcast_controller.dart';
import 'model/my_podcast_model.dart';

class MyPodcastScreen extends StatefulWidget {
  const MyPodcastScreen({super.key, this.isBack = true});
  final bool isBack;
  @override
  State<MyPodcastScreen> createState() => _MyPodcastScreenState();
}

class _MyPodcastScreenState extends State<MyPodcastScreen> {
  final _controller = Get.find<PodcastController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.isBack?IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)):null,
        title: Text("my_podcast".tr,),
        centerTitle: true,
      ),
*/
/*      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
        child: FloatingActionButton(
          onPressed: ()=>AppRouter.route.pushNamed(RoutePath.podcastAddScreen),
          backgroundColor: AppColors.blackColor,
          child: const Center(child: Icon(Iconsax.add, size: 80)),
        ),
      ),*//*

      body: RefreshIndicator(
        onRefresh: ()async{
          _controller.pagingController.refresh();
        },
        child: PagedListView<int, MyPodcastData>(
          pagingController: _controller.pagingController,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
              return PodcastCard(data: data);
            },
          ),
        ),
      ),
    );
  }
}
*/
