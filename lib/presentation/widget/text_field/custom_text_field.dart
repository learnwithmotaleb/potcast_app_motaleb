import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.inputFormatters,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputTextStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.hintText,
    this.suffixIcon,
    this.suffixIconColor,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLength,
    super.key,
    this.prefixIcon,
    this.prefix,
    this.onTap,
    this.isCollapsed,
    this.isDense,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.suffix,
    this.fillColor,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextStyle? inputTextStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator? validator;
  final String? hintText;

  final Color? suffixIconColor;
  final Color? fillColor;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final OutlineInputBorder? border;

  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;

  final bool isPassword;
  final Widget? suffix;
  final Widget? prefix;
  final bool readOnly;
  final int? maxLength;
  final bool? isCollapsed;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap; // Callback function for onTap

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      onTap: widget.onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.readOnly,
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      cursorColor: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
      style: widget.inputTextStyle,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      obscureText: widget.isPassword ? obscureText : false,
      validator: widget.validator,
      decoration: InputDecoration(
          isCollapsed: widget.isCollapsed,
          isDense: widget.isDense,
          errorMaxLines: 2,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.hintTextColor),
          prefixIcon: widget.prefixIcon,
          prefix: widget.prefix,
          suffix: widget.suffix,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: toggle,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: obscureText
                        ? const Icon(Icons.visibility_off_outlined,
                            color: AppColors.hintTextColor)
                        : const Icon(Icons.visibility_outlined,
                            color: AppColors.hintTextColor),
                  ),
                )
              : widget.suffixIcon,
          suffixIconColor: widget.suffixIconColor,
          border: widget.border,
          focusedBorder: widget.focusedBorder,
          enabledBorder: widget.enabledBorder),
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
