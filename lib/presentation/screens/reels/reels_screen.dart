import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/reels/controller/reels_controller.dart';
import 'package:podcast/presentation/screens/reels/widget/reel_video_item.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';

class ReelsScreen extends StatefulWidget {
  final AudioPlayerModel data;

  const ReelsScreen({super.key, required this.data});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ReelsController controller = Get.put(ReelsController());
  late PageController _pageController;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller.initData(widget.data);
  }

  @override
  void dispose() {
    _pageController.dispose();
    Get.delete<ReelsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        if (controller.error.isNotEmpty && controller.reels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.error.value,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchReels(isRefresh: true),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (controller.reels.isEmpty) {
          return const Center(
            child: Text(
              "No reels found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.reels.length + (controller.hasMore ? 1 : 0),
          onPageChanged: (index) {
            setState(() {
              _activePage = index;
            });
            if (index == controller.reels.length - 2 && controller.hasMore) {
              controller.loadMore();
            }
          },
          itemBuilder: (context, index) {
            if (index >= controller.reels.length) {
              return const Center(child: LoadingWidget());
            }

            final item = controller.reels[index];
            return ReelVideoItem(
              key: ValueKey(item.id),
              item: item,
              isActive: index == _activePage,
              onError: () {
                // Auto skip after a short delay if it's the active page
                if (index == _activePage) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted && _activePage == index) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                }
              },
            );
          },
        );
      }),
    );
  }
}
