/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import '../controller/categories_controller.dart';

class CategoriesTopSection extends StatefulWidget {
  const CategoriesTopSection({super.key, required this.id});
  final String id;

  @override
  State<CategoriesTopSection> createState() => _CategoriesTopSectionState();
}

class _CategoriesTopSectionState extends State<CategoriesTopSection> {
  final controller = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CupertinoSearchTextField(
              itemColor: CupertinoColors.systemGrey,
              placeholder:  "what_would_you_like_to_listen".tr,
              padding: const EdgeInsets.all(18),
              placeholderStyle: const TextStyle(color: Colors.grey),
              style: const TextStyle(color: AppColors.whiteColor),
              decoration: BoxDecoration(
                  color: const Color(0xFF2A2B31),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.whiteColor)
              ),
              onSubmitted: (value) {
                controller.getSearch(id: widget.id, search: value);
              },
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
*/
