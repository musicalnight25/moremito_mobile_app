import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/notification_settings_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NotificationSettingsController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            children: [
              height20,
              Text(
                "Push Notification Settings",
                style: AppTextStyle.normalExtraBold.copyWith(fontSize: 24.sp),
              ),
              height16,
              _section(
                title: "All Notifications",
                color: Colors.green.shade100,
                toggle: c.isAllEnabled,
                onToggle: c.toggleAll,
              ),
              _category(
                title: "SYSTEM RELATED",
                color: const Color(0xff6E6BD6),
                toggle: c.isSystemEnabled,
                list: c.systemList,
                onCategoryToggle: (v) =>
                    c.toggleCategory(c.isSystemEnabled, c.systemList, v),
                onItemToggle: c.toggleSingle,
              ),
              _category(
                title: "MARKETING",
                color: const Color(0xffFF7DBB),
                toggle: c.isMarketingEnabled,
                list: c.marketingList,
                onCategoryToggle: (v) =>
                    c.toggleCategory(c.isMarketingEnabled, c.marketingList, v),
                onItemToggle: c.toggleSingle,
              ),
              _category(
                title: "ANNOUNCEMENT",
                color: const Color(0xff1EC8FF),
                toggle: c.isAnnouncementEnabled,
                list: c.announcementList,
                onCategoryToggle: (v) => c.toggleCategory(
                    c.isAnnouncementEnabled, c.announcementList, v),
                onItemToggle: c.toggleSingle,
              ),
              height30,
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── UI HELPERS ─────────────────

  Widget _section({
    required String title,
    required Color color,
    required RxBool toggle,
    required Function(bool) onToggle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.sp),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppTextStyle.normalSemiBold16),
          ),
          Obx(
            () => Switch(
              activeColor: Colors.white,
              activeTrackColor: primaryColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: greyColor,
              value: toggle.value,
              onChanged: onToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _category({
    required String title,
    required Color color,
    required RxBool toggle,
    required List list,
    required Function(bool) onCategoryToggle,
    required Function onItemToggle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.sp),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.sp)),
            ),
            child: Text(title,
                style: AppTextStyle.normalSemiBold16
                    .copyWith(color: Colors.white)),
          ),
          _switchRow("Enable/Disable all $title notifications", toggle,
              onCategoryToggle),
          ...list.map(
            (e) => _switchRow(
              e.description,
              RxBool(e.isEnabled),
              (v) => onItemToggle(e, v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(
    String text,
    RxBool toggle,
    Function(bool) onChanged,
  ) {
    return Obx(
      () => ListTile(
        title: Text(text, style: AppTextStyle.normalRegular14),
        trailing: Switch(
          activeColor: Colors.white,
          activeTrackColor: primaryColor,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: greyColor,
          value: toggle.value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
