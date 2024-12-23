/*
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/user/categories/controller/categories_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class SubCategoriesSection extends StatelessWidget {
  SubCategoriesSection({super.key, required this.name});

  final String name;
  final controller = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subcategories list
        Obx(() {
          // Determine the subcategories to display
          final displayedCategories = controller.isExpanded.value
              ? controller.subcategories
              : controller.subcategories.take(3).toList();

          return Wrap(
            spacing: 8.0, // Horizontal space between items
            runSpacing: 8.0, // Vertical space between rows
            children: displayedCategories.map((subcategory) {
              final isSelected =
                  controller.selectedCategory.value == subcategory;

              return GestureDetector(
                onTap: () {
                  controller.selectedCategory.value = subcategory;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    subcategory,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
        const Gap(8),
        Obx(() {
          return GestureDetector(
            onTap: () {
              controller.isExpanded.toggle();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: controller.isExpanded.value ?"see_less":"see_more"),
                  Gap(5),
                  Icon(
                      controller.isExpanded.value
                          ? Icons.arrow_drop_up_sharp
                          : Icons.arrow_drop_down,
                      color: controller.isExpanded.value
                          ? Colors.red
                          : Colors.blue),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
*/
