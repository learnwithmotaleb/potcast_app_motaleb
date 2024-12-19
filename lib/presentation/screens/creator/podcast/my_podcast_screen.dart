import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
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
    final double width = MediaQuery.of(context).size.width;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: widget.isBack?IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)):null,
        title: Text("my_podcast".tr,),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const Gap(12),
                  GestureDetector(
                    onTap: ()=>AppRouter.route.pushNamed(RoutePath.podcastAddScreen),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      width: width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: isDarkMode?AppColors.whiteColor:AppColors.blackColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                                color: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.add_circle_outline,color: isDarkMode?AppColors.blackColor:AppColors.whiteColor),
                          ),
                          const Gap(5),
                          CustomText(text: "add_new_podcast".tr,fontSize: 12,fontWeight: FontWeight.w700),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: RefreshIndicator(
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
          ),
        ],
      ),
    );
  }
}
