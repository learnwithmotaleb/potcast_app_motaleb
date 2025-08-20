import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import '../../widget/loading/loading_widget.dart';
import 'model/history_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final controller = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("history".tr),
      ),
      /*bottomNavigationBar: Obx(() {
        return playController.isPlaying.value
            ? BottomNavPlayCard()
            : const SizedBox();
      }),*/
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
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
              sliver: PagedSliverGrid<int, HistoryItem>(
                pagingController: controller.pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
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
                    return CreatorCard(
                      data: data,
                      onTap: () => AppRouter.route.pushNamed(
                        RoutePath.audioPlayScreen,
                        extra: AudioPlayerModel(
                          id: item.podcast?.id ?? "",
                          title: item.podcast?.title ?? "",
                          categories: item.podcast?.category?.name ?? "",
                          image: item.podcast?.coverImage ?? "",
                          url: "",
                          duration: formatDuration(item.podcast?.duration ?? 0),
                        ),
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
                  newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
                ),
              ),
            )
          ],
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
