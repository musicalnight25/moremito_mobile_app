import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/notification_settings_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart'; // Ensure your colors are imported here
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing Controller
    final c = Get.put(NotificationSettingsController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                "Push Notifications",
                style: AppTextStyle.normalExtraBold.copyWith(
                  fontSize: 24.sp,
                  color: primaryBlack,
                ),
              ),
              Text(
                "Manage how you receive alerts and updates",
                style:
                    AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
              ),

              height24,

              // MASTER SWITCH SECTION
              _masterToggleSection(
                title: "Enable All Notifications",
                toggle: c.isAllEnabled,
                onToggle: c.toggleAll,
              ),

              height10,
              const Divider(color: borderGreyColor),
              height10,

              // CATEGORIES
              _buildCategoryCard(
                title: "System Updates",
                subtitle: "Security, account, and technical alerts",
                toggle: c.isSystemEnabled,
                list: c.systemList,
                onCategoryToggle: (v) =>
                    c.toggleCategory(c.isSystemEnabled, c.systemList, v),
                onItemToggle: c.toggleSingle,
              ),

              _buildCategoryCard(
                title: "Marketing & Offers",
                subtitle: "Promotions, discounts, and new features",
                toggle: c.isMarketingEnabled,
                list: c.marketingList,
                onCategoryToggle: (v) =>
                    c.toggleCategory(c.isMarketingEnabled, c.marketingList, v),
                onItemToggle: c.toggleSingle,
              ),

              _buildCategoryCard(
                title: "Announcements",
                subtitle: "Community news and general updates",
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

  // ───────────────── UI COMPONENTS ─────────────────

  /// The Top "Enable All" Highlighted Box
  Widget _masterToggleSection({
    required String title,
    required RxBool toggle,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: paleYellowColor, // Using your custom light blue/pale color
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 20.sp,
            child: Icon(Icons.notifications_active_outlined,
                color: primaryWhite, size: 20.sp),
          ),
          width12,
          Expanded(
            child: Text(
              title,
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryColor),
            ),
          ),
          Obx(() => _customSwitch(toggle.value, onToggle)),
        ],
      ),
    );
  }

  /// Modern Category Card
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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AppTextStyle.normalBold16
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
          // Sub-items list
          ...list.map((e) {
            return _subItemRow(
                e.description, RxBool(e.isEnabled), (v) => onItemToggle(e, v));
          }),
        ],
      ),
    );
  }

  /// Individual Toggle Rows inside cards
  Widget _subItemRow(String text, RxBool toggle, Function(bool) onChanged) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: ListTile(
          title: Text(text,
              style: AppTextStyle.normalRegular14
                  .copyWith(color: lightBlackColor)),
          trailing: _customSwitch(toggle.value, onChanged),
        ),
      ),
    );
  }

  /// Centralized Switch Style to match your theme
  Widget _customSwitch(bool value, Function(bool) onChanged) {
    return Switch(
      activeColor: primaryWhite,
      activeTrackColor: primaryColor,
      inactiveThumbColor: primaryWhite,
      inactiveTrackColor: greyColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
