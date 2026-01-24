import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';

class CustomDropdown extends StatelessWidget {
  final List<dynamic>? items;
  final List<DropdownMenuItem<dynamic>>? customItems;
  final dynamic value;
  final String hintText;
  final String? labelText;
  final ValueChanged<dynamic> onChanged;

  const CustomDropdown({
    super.key,
    this.items,
    required this.value,
    this.customItems,
    this.labelText,
    required this.hintText,
    required this.onChanged,
  });

  /// 🔥 GLOBAL SAFE VALUE HANDLER
  dynamic _getSafeValue(dynamic v, List<dynamic>? itemList) {
    if (v == null) return null;

    // Treat "Select", "" etc. as null
    if (v == "" || v == "Select") return null;

    // If dropdown has customItems
    if (customItems != null) {
      final exists = customItems!.any((item) => item.value == v);
      return exists ? v : null;
    }

    // If dropdown has normal items
    if (itemList != null) {
      final exists = itemList.contains(v);
      return exists ? v : null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final itemList = customItems ?? items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.sp, top: 12.sp),
            child: Text(
              labelText!,
              style: AppTextStyle.normalSemiBold16.copyWith(
                color: primaryBlack,
                fontSize: 15.sp,
              ),
            ),
          ),

        DropdownButtonHideUnderline(
          child: DropdownButton2<dynamic>(
            /// 🔥 FIXED: Always using error-free value
            value: _getSafeValue(value, items),

            isExpanded: true,

            /// HINT
            hint: Text(
              hintText,
              style: AppTextStyle.normalRegular14.copyWith(
                color: hintGreyColor,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            /// ITEMS
            items: customItems ??
                items!
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.toString(),
                          style: AppTextStyle.normalRegular14.copyWith(
                            color: primaryBlack,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                    .toList(),

            /// ON CHANGE
            onChanged: (v) {
              if (v != null) {
                onChanged(v);
              }
            },

            /// BUTTON STYLE
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                color: Colors.white,
                border: Border.all(
                  color: borderGreyColor,
                  width: 1.5,
                ),
              ),
            ),

            /// ICON
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22.sp,
                color: primaryBlack,
              ),
            ),

            /// MENU STYLE
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              elevation: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                color: Colors.white,
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            menuItemStyleData: MenuItemStyleData(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
            ),
          ),
        ),
      ],
    );
  }
}
