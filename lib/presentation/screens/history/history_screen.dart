import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/bottom_nav_play_card.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'model/history_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final controller = Get.find<HistoryController>();
  final playController = Get.find<AudioPlayController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("history".tr),
      ),
      bottomNavigationBar: Obx(() {
        return playController.isPlaying.value ? BottomNavPlayCard() : const SizedBox();
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Row(
                  children: [
                    Assets.icons.sort.svg(
                      height: 15,
                      width: 15,
                      colorFilter: isDarkMode
                          ? null
                          : const ColorFilter.mode(
                              AppColors.blackColor,
                              BlendMode.srcIn,
                            ),
                    ),
                    const Gap(5),
                    CustomText(
                      text: "recently_played".tr,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: PagedSliverList<int, HistoryItem>(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<HistoryItem>(
                  itemBuilder: (context, item, index) {
                    final data = AudioPlayerModel(
                      id: item.podcast?.id ?? "",
                      title: item.podcast?.title ?? "",
                      image: item.podcast?.coverImage ?? "",
                      categories: item.podcast?.category?.name ?? "",
                      duration: item.podcast?.duration.toString() ?? "0.0",
                      artist: item.podcast?.creator?.name ?? "",
                      url: item.podcast?.audioUrl ?? "",
                    );
                    return MusicCard(
                      data: data,
                      onTap: () {},
                      // onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id??""),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
