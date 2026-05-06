import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/modern_streaming_card.dart';

import '../home/model/streaming_record_model.dart';
import 'controller/see_all_controller.dart';

class SeeAllRecord extends StatefulWidget {
  const SeeAllRecord({super.key});

  @override
  State<SeeAllRecord> createState() => _SeeAllRecordState();
}

class _SeeAllRecordState extends State<SeeAllRecord> {
  final controller = Get.find<SeeAllController>();
  final pagingController = PagingController<int, StreamingRecordItem>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getAllRecord(
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
        title: const Text("Streaming Record"),
      ),
      body: PagedGridView<int, StreamingRecordItem>(
        pagingController: pagingController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        builderDelegate: PagedChildBuilderDelegate<StreamingRecordItem>(
          itemBuilder: (context, item, index) {
            return ModernStreamingCard(
              isLive: true,
              data: AudioPlayerModel(
                id: item.id ?? "",
                title: item.name ?? "",
                image: item.coverImage ?? "",
                duration: formatDuration(0),
                url: item.recordingPresignedUrl ?? "",
              ),
              onTap: () {
                if(item.recordingPresignedUrl != null){
                  AppRouter.route.pushNamed(RoutePath.recordPlayScreen,
                    extra: {"url": item.recordingPresignedUrl ?? ""},
                  );
                }
              },
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

  String formatDuration(num seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}
