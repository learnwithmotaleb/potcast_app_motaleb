import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'controller/categories_controller.dart';
import 'widget/categories_top_section.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.id});
  final String id;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CategoriesTopSection(name: widget.name),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => AppRouter.route.pushNamed(RoutePath.seeAllScreen,extra: widget.name),
                    child: Container(
                      height: 80.h,
                      padding: const EdgeInsets.only(right: 0, left: 8),
                      decoration: BoxDecoration(
                        color: widget.name =="genres_podcast_only"?const Color(0xFFEF4849): widget.name == "classical_audio"?const Color(0xFF03346E):const Color(0xFF016450),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(child: CustomText(text: "Classical Instruments", color: AppColors.whiteColor,fontSize: 12.sp, maxLines: 3, textAlign: TextAlign.start)),
                          SizedBox(
                            height: 80.h,
                            width: ((width / 2) - 25) / 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)
                              ),
                              child: CachedNetworkImage(
                                imageUrl: "https://img.freepik.com/free-photo/female-singer-portrait-isolated-blue-studio-wall-neon-light_155003-29661.jpg",
                                placeholder: (context, data) => const SizedBox(),
                                errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 20,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                mainAxisExtent: 80.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
