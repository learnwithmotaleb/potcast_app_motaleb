import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/podcast_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>AppRouter.route.pushNamed(RoutePath.podcastAddScreen),
        backgroundColor: AppColors.whiteColor,
        child: Icon(Iconsax.add, color: AppColors.blackColor),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          _controller.pagingController.refresh();
        },
        child: PagedListView<int, MyPodcastData>(
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
              return PodcastCard(data: data);
            },
          ),
        ),
      ),
    );
  }
}
