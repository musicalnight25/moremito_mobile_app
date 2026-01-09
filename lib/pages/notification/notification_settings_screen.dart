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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            children: [
              height20,
              Text(
                "Push Notifications",
                style: AppTextStyle.normalExtraBold
                    .copyWith(fontSize: 24.sp, color: primaryBlack),
              ),
              Text(
                "Manage how you receive alerts and updates",
                style:
                    AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
              ),
              height24,
              _masterToggleSection(
                title: "All Notifications",
                toggle: c.isAllEnabled,
                onToggle: c.toggleAll,
              ),
              height20,
              _buildCategoryCard(
                title: "Shared Link Notifications",
                subtitle:
                    "Messages about promotions and information sent by us",
                toggle: c.isMarketingEnabled,
                list: c.marketingList,
                onCategoryToggle: (v) =>
                    c.toggleCategory(c.isMarketingEnabled, c.marketingList, v),
                onItemToggle: c.toggleSingle,
              ),
              _buildCategoryCard(
                title: "Announcement Notifications",
                subtitle: "Important updates and reminders",
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

  // UI widgets

  Widget _masterToggleSection({
    required String title,
    required RxBool toggle,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: paleYellowColor,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyle.normalSemiBold14
                        .copyWith(color: primaryColor)),
                height04,
                Text(
                  "Enable/Disable app push notifications",
                  style: AppTextStyle.normalRegular12
                      .copyWith(color: hintGreyColor),
                )
              ],
            ),
          ),
          Obx(() => _customSwitch(toggle.value, onToggle)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required RxBool toggle,
    required List list,
    required Function(bool) onCategoryToggle,
    required Function onItemToggle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AppTextStyle.normalBold14
                              .copyWith(color: primaryBlack)),
                      Text(subtitle,
                          style: AppTextStyle.normalRegular12
                              .copyWith(color: hintGreyColor)),
                    ],
                  ),
                ),
                Obx(() => _customSwitch(toggle.value, onCategoryToggle)),
              ],
            ),
          ),
          const Divider(height: 1, color: borderGreyColor),
          ...list.map(
            (e) => Obx(
              () => ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
                title: Text(
                  e.description,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: lightBlackColor),
                ),
                trailing: _customSwitch(
                  e.isEnabled.value,
                  (v) => onItemToggle(e, v),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customSwitch(bool value, Function(bool) onChanged) {
    return Switch(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      activeColor: primaryWhite,
      activeTrackColor: primaryColor,
      inactiveThumbColor: primaryWhite,
      inactiveTrackColor: greyColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
