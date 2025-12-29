import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';

import '../marketing/flyer_templates_screen.dart';
import '../marketing/my_leads_screen.dart';
import '../marketing/my_shared_flyers_screen.dart';
import '../marketing/tmris_info_screen.dart';
import '../notification/notification_settings_screen.dart';
import '../order/my_orders_screen.dart';
import '../profile/my_profile_screen.dart';
import '../profile/welcome_tag_screen.dart';
import '../support/create_support_ticket_screen.dart';
import '../support/support_tickets_list_screen.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuSection> sections = [];

  @override
  void initState() {
    super.initState();

    sections = [
      MenuSection(
        title: "My Info",
        icon: Icons.person_outline,
        items: [
          MenuItem(
            title: "My Profile",
            icon: Icons.account_circle_outlined,
            onTap: () => Get.to(() => MyProfileScreen()),
          ),

          // MenuItem(
          //   title: "My Addresses",
          //   icon: Icons.location_on_outlined,
          //   onTap: () => Get.to(() => MyAddressesScreen()),
          // ),
          MenuItem(
            title: "Notification Settings",
            icon: Icons.notifications_outlined,
            onTap: () => Get.to(() => const NotificationSettingsScreen()),
          ),
          MenuItem(
            title: "Welcome Tag",
            icon: Icons.badge_outlined,
            onTap: () => Get.to(() => WelcomeTagScreen()),
          ),
          // MenuItem(
          //   title: "Change Password",
          //   icon: Icons.lock_outline,
          //   onTap: () => Get.to(() => ChangePasswordScreen()),
          // ),
          // MenuItem(
          //   title: "User Role",
          //   icon: Icons.switch_account_outlined,
          //   onTap: () => Get.to(() => UserRoleScreen()),
          // ),
        ],
      ),
      MenuSection(
        title: "Orders",
        icon: Icons.shopping_bag_outlined,
        items: [
          MenuItem(
            title: "My Orders",
            icon: Icons.receipt_long_outlined,
            onTap: () => Get.to(() => MyOrdersScreen()),
          ),
          // MenuItem(
          //   title: "My Recurring Order",
          //   icon: Icons.repeat_outlined,
          //   onTap: () => Get.to(() => MyRecurringOrderScreen()),
          // ),
          // MenuItem(
          //   title: "My Referral Orders",
          //   icon: Icons.group_outlined,
          //   onTap: () => Get.to(() => MyReferralOrdersScreen()),
          // ),
        ],
      ),
      MenuSection(
        title: "Support",
        icon: Icons.support_agent_outlined,
        items: [
          MenuItem(
            title: "Support Ticket List",
            icon: Icons.list_alt_outlined,
            onTap: () => Get.to(() => SupportTicketsListScreen()),
          ),
          MenuItem(
            title: "Create Support Ticket",
            icon: Icons.add_circle_outline,
            onTap: () => Get.to(() => CreateSupportTicketScreen()),
          ),
        ],
      ),
      MenuSection(
        title: "Share MoreMito Info",
        icon: Icons.campaign_outlined,
        items: [
          MenuItem(
            title: "Customize & Share My Flyers",
            icon: Icons.brush_outlined, // design / customize
            onTap: () => Get.to(() => FlyerTemplatesScreen()),
          ),
          MenuItem(
            title: "Share Audios, Videos & Docs",
            icon: Icons.perm_media_outlined, // media sharing
            onTap: () => Get.to(() => CategoriesScreen(isFromMenu: true)),
          ),
          MenuItem(
            title: "Allow Others to Request MoreMito Info",
            icon: Icons.group_add_outlined, // people requesting access
            onTap: () => Get.to(() => TmrisInfoScreen()),
          ),
          MenuItem(
            title: "See My Generated Leads",
            icon: Icons.trending_up_outlined, // leads / analytics
            onTap: () => Get.to(() => MyLeadsScreen()),
          ),
          MenuItem(
            title: "See & Track Activity From My Shared Links",
            icon: Icons.track_changes_outlined, // tracking activity
            onTap: () => Get.to(() => MySharedFlyersScreen()),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(title: "Menu", visibleBackButton: true),
      backgroundColor: Colors.transparent,
      body: BaseBackgroundWidget(
        child: ListView.builder(
          padding: EdgeInsets.all(10.sp),
          itemCount: sections.length,
          itemBuilder: (_, i) => MenuSectionWidget(section: sections[i]),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////
//                         SECTION WIDGET
//////////////////////////////////////////////////////////////////////

class MenuSectionWidget extends StatefulWidget {
  final MenuSection section;

  const MenuSectionWidget({required this.section});

  @override
  State<MenuSectionWidget> createState() => _MenuSectionWidgetState();
}

class _MenuSectionWidgetState extends State<MenuSectionWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderGreyColor.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          _header(),
          _expandedWidget(),
        ],
      ),
    );
  }

  Widget _header() => InkWell(
        onTap: () => setState(() => expanded = !expanded),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            children: [
              Icon(widget.section.icon, size: 20.sp, color: primaryColor),
              width12,
              Expanded(
                  child: Text(widget.section.title,
                      style: AppTextStyle.normalSemiBold15)),
              Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20.sp,
                color: primaryBlack,
              ),
            ],
          ),
        ),
      );

  Widget _expandedWidget() => AnimatedSize(
        duration: 250.milliseconds,
        child: expanded
            ? Column(
                children: List.generate(
                  widget.section.items.length,
                  (index) => Column(
                    children: [
                      _item(widget.section.items[index]),
                      if (index != widget.section.items.length - 1)
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.only(left: 15.sp),
                          color: borderGreyColor.withOpacity(0.3),
                        ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      );

  Widget _item(MenuItem item) => InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
          child: Row(
            children: [
              Icon(item.icon, size: 18.sp, color: Colors.black54),
              width12,
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyle.normalSemiBold15.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

//////////////////////////////////////////////////////////////////////
//                           MODELS
//////////////////////////////////////////////////////////////////////

class MenuSection {
  final String title;
  final IconData icon;
  final List<MenuItem> items;

  MenuSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
