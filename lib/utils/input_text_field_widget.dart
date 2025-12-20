import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';

class PasswordWidget extends StatelessWidget {
  final Key? fieldKey;
  final int? maxLength;
  final String? hintText;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final EdgeInsets? scropadding;
  final bool? readonly;
  final String? labelText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? filledColor;
  final ValueChanged<String?>? onFieldSubmitted;
  final ValueChanged<String?>? onChanged;
  final Widget? prefixIcon;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final bool? enabled;
  final double? borderRadius;
  final Color? lableColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final Iterable<String>? autofillHints;

  PasswordWidget({
    Key? key,
    required this.controller,
    this.fieldKey,
    this.maxLength,
    this.hintText,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.textStyle,
    this.hintStyle,
    this.labelText,
    this.prefixIcon,
    this.maxLines,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.autofillHints,
    this.borderColor,
    this.filledColor,
    this.enabled,
    this.readonly,
    this.lableColor,
    this.borderRadius,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.scropadding,
    this.textAlign = TextAlign.left,
    this.contentPadding,
  }) : super(key: key);

  /// 🔑 LOCAL state (per widget instance)
  final RxBool _obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.sp, top: 12.sp),
            child: Text(
              labelText!,
              style: AppTextStyle.normalSemiBold16.copyWith(
                color: enabled != null && !enabled!
                    ? lableColor ?? hintGreyColor
                    : primaryBlack,
              ),
            ),
          ),
        Obx(
          () => textFormField(
            fieldKey: fieldKey,
            hintText: hintText,
            obscureText: _obscureText.value,
            focusNode: focusNode,
            controller: controller,
            textInputAction: textInputAction,
            maxLength: maxLength,
            maxLines: 1,
            keyboardType: keyboardType,
            suffixIcon: GestureDetector(
              onTap: () {
                _obscureText.value = !_obscureText.value;
              },
              child: Icon(
                _obscureText.value
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                size: 20.sp,
                color: hintGreyColor,
              ),
            ),
            labelText: labelText,
            prefixIcon: prefixIcon,
            borderRadius: borderRadius,
            enabled: enabled,
            textAlign: textAlign,
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
            autofillHints: autofillHints,
            textStyle: textStyle,
            hintStyle: hintStyle,
            borderColor: borderColor,
            contentPadding: contentPadding,
            filledColor: filledColor,
            enabledBorderColor: enabledBorderColor,
            focusedBorderColor: focusedBorderColor,
            errorBorderColor: errorBorderColor,
          ),
        ),
      ],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    Key? key,
    this.fieldKey,
    this.hintText,
    this.textStyle,
    this.autofocus,
    this.hintStyle,
    this.labelText,
    this.scrollController,
    this.validator,
    this.prefixIcon,
    required this.controller,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.suffixIcon,
    this.onTap,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.borderColor,
    this.lableColor,
    this.filledColor,
    this.enabled,
    this.readonly,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.scropadding,
    this.textAlign = TextAlign.left,
    this.contentPadding,
  }) : super(key: key);
  final EdgeInsets? scropadding;
  final Key? fieldKey;
  final bool? readonly;
  final String? hintText;
  final String? labelText;
  final ScrollController? scrollController;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? filledColor;
  final Color? lableColor;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<String?>? onFieldSubmitted;
  final ValueChanged<String?>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final bool? enabled;
  final bool? autofocus;
  final Iterable<String>? autofillHints;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? enabledBorderColor;
  final Color? errorBorderColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.sp, top: 12.sp),
            child: Text(
              labelText ?? "",
              style: AppTextStyle.normalSemiBold16.copyWith(
                  color: enabled != null && !enabled!
                      ? lableColor ?? hintGreyColor
                      : primaryBlack),
            ),
          ),
        textFormField(
            fieldKey: fieldKey,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            autofocus: autofocus ?? false,
            hintText: hintText,
            scrollController: scrollController,
            labelText: labelText,
            // scropadding: scropadding,
            controller: controller,
            // borderRaduis: 10,
            keyboardType: keyboardType ?? TextInputType.text,
            validator: validator,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            maxLength: maxLength,
            maxLines: maxLines,
            autofillHints: autofillHints,
            enabled: enabled ?? true,
            textInputAction: textInputAction,
            textAlign: textAlign,
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
            contentPadding: contentPadding,
            textStyle: textStyle,
            hintStyle: hintStyle,
            borderColor: borderColor,
            filledColor: filledColor,
            enabledBorderColor: enabledBorderColor,
            focusedBorderColor: focusedBorderColor,
            errorBorderColor: errorBorderColor),
      ],
    );
  }
}

TextFormField textFormField({
  final Key? fieldKey,
  final String? hintText,
  final String? labelText,
  final String? helperText,
  final String? initialValue,
  final int? errorMaxLines,
  final ScrollController? scrollController,
  final int? maxLines,
  final int? maxLength,
  final double? borderRadius = 12,
  final bool? enabled,
  final bool autofocus = false,
  final bool obscureText = false,
  final Color? filledColor,
  final Color? cursorColor,
  final Color? borderColor,
  final Color? focusedBorderColor,
  final Color? enabledBorderColor,
  final Color? errorBorderColor,
  final double? borderWidth = 2.0,
  final Widget? prefixIcon,
  final Widget? suffixIcon,
  final FocusNode? focusNode,
  final TextStyle? style,
  final TextStyle? textStyle,
  final TextStyle? hintStyle,
  final Iterable<String>? autofillHints,
  final TextAlign textAlign = TextAlign.left,
  final TextEditingController? controller,
  final List<TextInputFormatter>? inputFormatters,
  final TextInputAction? textInputAction,
  final TextInputType? keyboardType,
  final TextCapitalization textCapitalization = TextCapitalization.none,
  final GestureTapCallback? onTap,
  final FormFieldSetter<String?>? onSaved,
  final FormFieldValidator<String?>? validator,
  final ValueChanged<String?>? onChanged,
  final ValueChanged<String?>? onFieldSubmitted,
  final EdgeInsetsGeometry? contentPadding,
  final bool? readonly,
  final EdgeInsets? scrollPadding,
}) {
  return TextFormField(
    scrollPadding: scrollPadding ?? EdgeInsets.zero,
    key: fieldKey,
    readOnly: readonly ?? false,
    controller: controller,
    scrollController: scrollController,
    autofillHints: autofillHints,
    focusNode: focusNode,
    maxLines: maxLines,
    initialValue: initialValue,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    obscureText: obscureText,
    enabled: enabled,
    validator: validator,
    maxLength: maxLength,
    enableSuggestions: true,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    onTap: onTap,
    onSaved: onSaved,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    autocorrect: true,
    autofocus: autofocus,
    textAlign: textAlign,
    cursorColor: cursorColor ?? Colors.black,
    cursorHeight: 20,
    style: textStyle ?? AppTextStyle.normalBold14,
    decoration: InputDecoration(
      hintMaxLines: 1,
      prefixIcon: prefixIcon,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular((borderRadius ?? 12).sp),
        borderSide: BorderSide(
          color: errorBorderColor ?? borderColor ?? redColor,
          width: borderWidth!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular((borderRadius ?? 12).sp),
        borderSide: BorderSide(
          color: focusedBorderColor ?? borderColor ?? borderGreyColor,
          width: borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular((borderRadius ?? 12).sp),
        borderSide: BorderSide(
          color: enabledBorderColor ?? borderColor ?? borderGreyColor,
          width: borderWidth,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular((borderRadius ?? 12).sp),
        borderSide: BorderSide(
          color: borderColor ?? borderGreyColor,
          width: borderWidth,
        ),
      ),
      errorMaxLines: errorMaxLines ?? 5,
      fillColor: filledColor ??
          (enabled != null && !enabled
              ? lightGreyColor.withOpacity(.4)
              : primaryWhite),
      filled: true,
      hintStyle: hintStyle ??
          AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
      hintText: hintText ?? "Enter text hear...",
      enabled: enabled ?? true,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular((borderRadius ?? 12).sp),
        borderSide: BorderSide(
          color: borderGreyColor,
          width: borderWidth,
        ),
      ),
      suffixIcon: suffixIcon,
      // labelText: labelText,
      helperText: helperText,
    ),
  );
}
