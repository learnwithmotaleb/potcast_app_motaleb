import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'controller/categories_controller.dart';
import 'widget/categories_top_section.dart';
import 'widget/sub_categories_section.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.name});
  final String name;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 44),
        itemCount: controller.newItem.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoriesTopSection(name: widget.name),
                SubCategoriesSection(name: widget.name),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomText(text: widget.name =="genres_podcast_only"?"genres_podcast_only".tr: widget.name == "classical_audio"?"classical_podcast_only".tr:"millennial_podcast_only".tr),
                ),
              ],
            );
          }else {
            return MusicCard(data: controller.newItem[index-1],onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.newItem[index-1]));
          }
        },
      ),
    );
  }
}
