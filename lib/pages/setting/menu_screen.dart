import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/support/support_tickets_list_screen.dart';

import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

// Import All Screens
import '../account/my_account_info_screen.dart';
import '../account/my_deep_link_screen.dart';
import '../account/my_address_screen.dart';
import '../account/my_network_screen.dart';
import '../account/my_orders_screen.dart';
import '../account/my_recurring_order_screen.dart';
import '../account/my_referral_orders_screen.dart';
import 'mitochondria_story_screen.dart';
import 'testimonials_screen.dart';
import 'grief_relief_zoom_screen.dart';
import '../support/create_support_ticket_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  final List<MenuSection> sections = [
    // MenuSection(
    //   title: "My info",
    //   items: [
    //     MenuItem(
    //       title: "My account information",
    //       onTap: () => Get.to(() => MyAccountInfoScreen()),
    //     ),
    // MenuItem(
    //   title: "My deep links",
    //   onTap: () => Get.to(() =>
    //       MyDeepLinkScreen(link: "https://moremito.com/joining/shubham/2")),
    // ),
    // MenuItem(
    //   title: "My address",
    //   onTap: () => Get.to(() => MyAddressScreen()),
    // ),
    // MenuItem(
    //   title: "My network",
    //   onTap: () => Get.to(() => MyNetworkScreen()),
    // ),
    //   ],
    // ),
    MenuSection(
      title: "Orders",
      items: [
        MenuItem(
          title: "My orders",
          onTap: () => Get.to(() => MyOrdersScreen()),
        ),
        MenuItem(
          title: "My recurring order",
          onTap: () => Get.to(() => MyRecurringOrderScreen()),
        ),
        MenuItem(
          title: "My personal referral orders",
          onTap: () => Get.to(() => MyReferralOrdersScreen()),
        ),
      ],
    ),
    MenuSection(
      title: "Support",
      items: [
        MenuItem(
          title: "Support Tickets List",
          onTap: () => Get.to(() => SupportTicketsListScreen()),
        ),
        MenuItem(
          title: "Create Support Ticket",
          onTap: () => Get.to(() => CreateSupportTicketScreen()),
        ),
      ],
    ),
    // MenuSection(
    //   title: "Resources",
    //   items: [
    //     MenuItem(
    //       title: "Mitochondria Story",
    //       onTap: () => Get.to(() => MitochondriaStoryScreen()),
    //     ),
    //     MenuItem(
    //       title: "Testimonials",
    //       onTap: () => Get.to(() => TestimonialsScreen()),
    //     ),
    //     MenuItem(
    //       title: "Grief Relief Zoom Call 7-14-24",
    //       onTap: () => Get.to(() => GriefReliefZoomScreen()),
    //     ),
    //   ],
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "Menu",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.map((s) => _buildSection(s)).toList(),
          ),
        ),
      ),
    );
  }

  // ===================== SECTION =====================
  Widget _buildSection(MenuSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: AppTextStyle.normalSemiBold16.copyWith(
            fontSize: 18.sp,
            color: Colors.black87,
          ),
        ),
        customHeight(12),
        ...section.items.map((item) => _itemCard(item)).toList(),
        customHeight(20),
      ],
    );
  }

  // ===================== CARD ITEM =====================
  Widget _itemCard(MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.sp),
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyle.normalBold16.copyWith(
                  fontSize: 15.sp,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

// ===================== MODELS =====================
class MenuSection {
  final String title;
  final List<MenuItem> items;

  MenuSection({required this.title, required this.items});
}

class MenuItem {
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.onTap});
}
