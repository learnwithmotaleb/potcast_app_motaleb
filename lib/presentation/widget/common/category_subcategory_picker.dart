import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/controller/global_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/categories_subcategories_model.dart';
import 'package:podcast/presentation/widget/dropdown/custom_dropdown_field.dart';

class CategorySubcategoryPicker extends StatelessWidget {
  final String? selectedCategoryId;
  final String? selectedSubcategoryId;
  final void Function(String?)? onCategoryChanged;
  final void Function(String?)? onSubcategoryChanged;
  final bool isRequired;
  final GlobalController globalController;

  const CategorySubcategoryPicker({
    super.key,
    this.selectedCategoryId,
    required this.globalController,
    this.selectedSubcategoryId,
    this.onCategoryChanged,
    this.onSubcategoryChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final categories = globalController.categories.value.data?.result ?? [];

    final subcategories = categories
            .firstWhere(
              (cat) => cat.id == selectedCategoryId,
              orElse: () => CategoryItem(id: '', name: '', subcategories: []),
            )
            .subcategories ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownField(
          hintText: "Select Category",
          items: categories.map((e) => e.name ?? "").toList(),
          value: categories
              .firstWhereOrNull((e) => e.id == selectedCategoryId)
              ?.name,
          onChanged: (name) {
            final matched = categories.firstWhereOrNull((e) => e.name == name);
            onCategoryChanged?.call(matched?.id);
          },
          isRequired: isRequired,
        ),
        const SizedBox(height: 12),
        CustomDropdownField(
          hintText: "Select Subcategory",
          items: subcategories.map((e) => e.name ?? "").toList(),
          value: subcategories
              .firstWhereOrNull((e) => e.id == selectedSubcategoryId)
              ?.name,
          onChanged: (name) {
            final matched =
                subcategories.firstWhereOrNull((e) => e.name == name);
            onSubcategoryChanged?.call(matched?.id);
          },
          isRequired: isRequired,
        ),
      ],
    );
  }
}
