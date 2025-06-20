import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'controller/categories_controller.dart';
import 'widget/categories_top_section.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.id});

  final String id;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.put(CategoriesController());

  @override
  void initState() {
    controller.getAllSubCategories(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(controller.categoryModel.value.data?.category?.title ?? "Podcast");
        }),
      ),
      body: Obx(() {
          switch (controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No Categories Found", color: AppColors.blackColor),);
            case Status.error:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );

            case Status.completed:
              return RefreshIndicator(
                onRefresh: () async {
                  controller.getAllSubCategories(id: widget.id);
                },
                child: CustomScrollView(
                  slivers: [
                    CategoriesTopSection(id: widget.id),
                    Obx(() {
                        switch (controller.searchLoading.value) {
                          case Status.loading:
                            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                          case Status.internetError:
                            return SliverToBoxAdapter(
                              child: NoInternetCard(
                                onTap: () => controller.getAllSubCategories(id: widget.id),
                                color: AppColors.blackColor,
                              ),
                            );
                          case Status.noDataFound:
                            return const SliverToBoxAdapter(child: Center(child: CustomText(text: "", color: AppColors.whiteColor)));
                          case Status.error:
                            return SliverToBoxAdapter(
                              child: NoInternetCard(
                                onTap: () => controller.getAllSubCategories(id: widget.id),
                                color: AppColors.blackColor,
                              ),
                            );

                          case Status.completed:
                            return SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(text: controller.subCategory[index].title ?? "",fontSize: 22, fontWeight: FontWeight.w800),
                                          TextButton(
                                            style: const ButtonStyle(
                                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                                            ),
                                            onPressed: () {
                                              AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "popular");
                                            },
                                            child: Text("see_all".tr, style: const TextStyle(color: AppColors.whiteColor)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(left: 12, right: 12),
                                        itemCount: 3,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index){
                                          return HomeMusicCard(
                                            data: AudioPlayerModel(
                                                id: "",
                                                title: "Test Title",
                                                categories: controller.categoryModel.value.data?.category?.title,
                                                image: "https://plus.unsplash.com/premium_photo-1681335986095-5a9585e77246",
                                                duration: "1.0"
                                            ),
                                            onTap: (){
                                              //AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: popularItem?[index].id??"");
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                                childCount: controller.subCategory.length,
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
