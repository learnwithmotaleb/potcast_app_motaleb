import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/search/controller/user_search_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.name});
  final String name;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<UserSearchController>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("search".tr),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 44),
        itemCount: controller.newItem.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(12),
                  CustomTextField(
                    hintText: "what_would_you_like_to_listen".tr,
                    prefixIcon: const Icon(Iconsax.search_normal_1_copy),
                  ),
                  Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "search_item".tr),
                      Assets.icons.sort.svg(colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                    ],
                  ),
                  Gap(12),
                ],
              ),
            );
          }else {
            return MusicCard(data: controller.newItem[index-1],onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.newItem[index-1]));
          }
        },
      ),
    );
  }
}
