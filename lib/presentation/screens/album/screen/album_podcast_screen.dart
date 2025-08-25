import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../controller/album_controller.dart';

class AlbumPodcastScreen extends StatefulWidget {
  const AlbumPodcastScreen({
    super.key,
    required this.title,
    required this.id,
  });

  final String title;
  final String id;

  @override
  State<AlbumPodcastScreen> createState() => _AlbumPodcastScreenState();
}

class _AlbumPodcastScreenState extends State<AlbumPodcastScreen> {
  final controller = Get.put(AlbumController());

  @override
  void initState() {
    controller.getAlbum(id: widget.id);
    super.initState();
  }
  @override
  void dispose() {
    Get.delete<AlbumController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Obx(() {
        switch (controller.loading.value) {
          case Status.loading:
            return const LoadingWidget();
          case Status.internetError:
            return NoInternetCard(
              onTap: () {
                controller.getAlbum(id: widget.id);
              },
            );
          case Status.noDataFound:
            return const Center(child: CustomText(text: "No data found!"));
          case Status.error:
            return NoInternetCard(
              onTap: () {
                controller.getAlbum(id: widget.id);
              },
            );

          case Status.completed:
            return RefreshIndicator(
              onRefresh: () async{
                controller.getAlbum(id: widget.id);
              },
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8
                ),
                itemBuilder: (BuildContext context, int index){
                  final item = controller.albumModel.value.data?.podcasts?[index];
                  final data = AudioPlayerModel(
                    id: widget.id,
                    title: item?.title ?? "",
                    image: item?.coverImage ?? "",
                    duration: "",
                    url: "",
                  );
                  return CreatorCard(
                    data: data,
                    onTap: () => AppRouter.route.pushNamed(RoutePath.audioPlayScreen,
                        extra: AudioPlayerModel(
                          id: widget.id,
                          title: item?.title ?? "",
                          categories: item?.category?.name ?? "",
                          image: item?.coverImage ?? "",
                          url: item?.podcastUrl ?? "",
                          duration: formatDuration(item?.duration ?? 0),
                          isAlbum: true,
                        ),
                    ),
                  );
                },
                itemCount: controller.albumModel.value.data?.podcasts?.length ?? 0,
              ),
            );
        }
      }),
    );
  }

  String formatDuration(num seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}
