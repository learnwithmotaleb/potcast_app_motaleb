import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
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
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Obx(
            () {
          switch (controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No Categories Found",color: AppColors.whiteColor));
            case Status.error:
              return NoInternetCard(
                onTap: () => controller.getAllSubCategories(id: widget.id),
                color: AppColors.blackColor,
              );

            case Status.completed:
              return RefreshIndicator(
                onRefresh: ()async{
                  controller.getAllSubCategories(id: widget.id);
                },
                child: CustomScrollView(
                  slivers: [
                    CategoriesTopSection(id: widget.id),
                    Obx(
                          () {
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
                            return const SliverToBoxAdapter(child: Center(child: CustomText(text: "",color: AppColors.whiteColor)));
                          case Status.error:
                            return SliverToBoxAdapter(
                              child: NoInternetCard(
                                onTap: () => controller.getAllSubCategories(id: widget.id),
                                color: AppColors.blackColor,
                              ),
                            );

                          case Status.completed:
                            return SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => AppRouter.route.pushNamed(RoutePath.categoryAllPodcast,extra: controller.subCategory[index].id),
                                    child: Container(
                                      height: 80.h,
                                      padding: const EdgeInsets.only(right: 0, left: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4849),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: CustomText(text: controller.subCategory[index].title??"", color: AppColors.whiteColor,fontSize: 12.sp, maxLines: 2, textAlign: TextAlign.start)),
                                          SizedBox(
                                            height: 80.h,
                                            width: ((width / 2) - 25) / 2,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight: Radius.circular(8)
                                              ),
                                              child: CustomNetworkImage(imageUrl: controller.subCategory[index].subCategoryImage??""),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                  childCount: controller.subCategory.length,
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  mainAxisExtent: 80.h,
                                ),
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
