import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

import '../../../utils/app_colors/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final List<String>? items;
  final String? value;
  final String extraText;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.extraText = "",
    this.onChanged,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final safeItems = items ?? [];
    final bool isValueValid = safeItems.contains(value);
    const message = "This field is Required";
    String? Function(String?)? validation = (isRequired
        ? (val) => (val == null || val.isEmpty) ? message : null
        : null);
    final validationFunction = validator ?? validation;

    final isExtraTextNotEmpty = extraText.isNotEmpty;

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      value: isValueValid ? value : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: false,
        hintStyle: const TextStyle(color: AppColors.whiteColor),
        errorStyle: const TextStyle(color: AppColors.whiteColor),
      ),
      hint:
          CustomText(text: hintText, color: AppColors.whiteColor, fontSize: 16),
      items: safeItems
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: CustomText(
                text: item + (isExtraTextNotEmpty ? " $extraText" : ""),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validationFunction,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      buttonStyleData:
          const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.whiteColor),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.blackColor,
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16)),
    );
  }
}
