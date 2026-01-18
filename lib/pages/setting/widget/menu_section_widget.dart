import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';
import '../../../utils/static_decoration.dart';
import '../menu_screen.dart';

/// =========================
/// SECTION WIDGET
/// =========================
class MenuSectionWidget extends StatefulWidget {
  final MenuSection section;

  const MenuSectionWidget({super.key, required this.section});

  @override
  State<MenuSectionWidget> createState() => _MenuSectionWidgetState();
}

class _MenuSectionWidgetState extends State<MenuSectionWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderGreyColor.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                children: [
                  Icon(widget.section.icon, color: primaryColor),
                  width12,
                  Expanded(
                    child: Text(
                      widget.section.title,
                      style: AppTextStyle.normalSemiBold15,
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Column(
              children: widget.section.items
                  .map(
                    (item) => MenuItemWidget(item: item, level: 0),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

/// =========================
/// MENU ITEM WIDGET (RECURSIVE)
/// =========================
class MenuItemWidget extends StatefulWidget {
  final MenuItem item;
  final int level;

  const MenuItemWidget({
    super.key,
    required this.item,
    required this.level,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren =
        widget.item.children != null && widget.item.children!.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: hasChildren
              ? () => setState(() => expanded = !expanded)
              : widget.item.onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              15.sp + (widget.level * 15.sp),
              10.sp,
              15.sp,
              10.sp,
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  size: 18.sp,
                  color: Colors.black54,
                ),
                width12,
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: AppTextStyle.normalSemiBold15
                        .copyWith(color: Colors.black87),
                  ),
                ),
                if (hasChildren)
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18.sp,
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren && expanded)
          Column(
            children: widget.item.children!
                .map(
                  (child) =>
                      MenuItemWidget(item: child, level: widget.level + 1),
                )
                .toList(),
          ),
      ],
    );
  }
}
