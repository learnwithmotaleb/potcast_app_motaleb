import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'controller/categories_controller.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.id});

  final String id;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.find<CategoriesController>();

  @override
  void initState() {
    controller.getAllSubCategories(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Podcast"),
      ),
      body: Obx(
        () {
          switch (controller.loading.value) {
            case Status.loading:
              return const LoadingWidget();
            case Status.internetError:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );
            case Status.noDataFound:
              return const Center(
                child: CustomText(
                    text: "No Categories Found", color: AppColors.blackColor),
              );
            case Status.error:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );

            case Status.completed:
              final data = controller.categoryModel.value.data;
              return RefreshIndicator(
                onRefresh: () async {
                  controller.getAllSubCategories(id: widget.id);
                },
                child: CustomScrollView(
                  slivers: [
                    if (data != null && data.isNotEmpty)
                      ...List<Widget>.generate(data.length, (index) {
                        return SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: data[index].name ?? "",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AppRouter.route.pushNamed(
                                          RoutePath.podcastListScreen,
                                          extra: {
                                            'title': data[index].name,
                                            'category': widget.id,
                                            'subCategory': data[index].id,
                                          },
                                        );
                                      },
                                      child: Text(
                                        "see_all".tr,
                                        style: const TextStyle(
                                            color: AppColors.whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  itemCount: data[index].podcasts?.length ?? 0,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int nestIndex) {
                                    final item = data[index].podcasts?[nestIndex];
                                    return HomeMusicCard(
                                      data: AudioPlayerModel(
                                        id: item?.id ?? "",
                                        title: item?.title ?? "",
                                        // categories: controller.categoryModel.value.data?.category?.title,
                                        image: item?.coverImage ?? "",
                                        duration: "1.0",
                                        url: "",
                                      ),
                                      onTap: () => AppRouter.route.pushNamed(RoutePath.audioPlayScreen,
                                          extra: AudioPlayerModel(
                                            id: item?.id ?? "",
                                            title: item?.title ?? "",
                                            categories: item?.category?.name ?? "",
                                            image: item?.coverImage ?? "",
                                            url: item?.podcastUrl ?? "",
                                            duration: formatDuration(item?.duration ?? 0),
                                            reels: true,
                                          )),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
          }
        },
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
