import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

// Screens
import '../account/my_orders_screen.dart';
import '../account/my_recurring_order_screen.dart';
import '../account/my_referral_orders_screen.dart';
import '../support/support_tickets_list_screen.dart';
import '../support/create_support_ticket_screen.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

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
        title: "Orders",
        icon: Icons.shopping_bag,
        items: [
          MenuItem(
              title: "My Orders",
              icon: Icons.receipt_long,
              onTap: () => Get.to(() => MyOrdersScreen())),
          MenuItem(
              title: "My Recurring Order",
              icon: Icons.repeat,
              onTap: () => Get.to(() => MyRecurringOrderScreen())),
          MenuItem(
              title: "My Referral Orders",
              icon: Icons.group,
              onTap: () => Get.to(() => MyReferralOrdersScreen())),
        ],
      ),
      MenuSection(
        title: "Support",
        icon: Icons.support_agent,
        items: [
          MenuItem(
              title: "Support Ticket List",
              icon: Icons.list_alt,
              onTap: () => Get.to(() => SupportTicketsListScreen())),
          MenuItem(
              title: "Create Support Ticket",
              icon: Icons.add_circle_outline,
              onTap: () => Get.to(() => CreateSupportTicketScreen())),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(title: "Menu", visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children:
                sections.map((s) => MenuSectionWidget(section: s)).toList(),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////
///                   SECTION ACCORDION WIDGET                     ///
//////////////////////////////////////////////////////////////////////

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
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(0.5),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),

          /// EXPANDED MENU
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              children: widget.section.items.map((i) => _menuItem(i)).toList(),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // SECTION HEADER
  Widget _buildHeader() {
    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 18.sp),
        child: Row(
          children: [
            Icon(widget.section.icon, color: primaryColor, size: 24.sp),
            width14,
            Expanded(
              child: Text(
                widget.section.title,
                style: AppTextStyle.normalSemiBold18.copyWith(
                  color: primaryBlack,
                ),
              ),
            ),
            Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: primaryBlack,
              size: 26.sp,
            ),
          ],
        ),
      ),
    );
  }

  // SINGLE MENU ITEM
  Widget _menuItem(MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderGreyColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 20.sp, color: lightBlackColor),
            width12,
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyle.normalSemiBold16.copyWith(
                  color: lightBlackColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: textGreyColor),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////
///                          MODELS                                 ///
//////////////////////////////////////////////////////////////////////

class MenuSection {
  final String title;
  final IconData icon;
  final List<MenuItem> items;

  MenuSection({required this.title, required this.icon, required this.items});
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
