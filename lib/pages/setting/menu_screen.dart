import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';
import 'package:more_mitro_app/pages/setting/widget/menu_section_widget.dart';
import 'package:more_mitro_app/pages/setting/widget/settings_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../model/menu_section_model.dart';
import '../../service/webview_helper.dart';
import '../../utils/common_web_view.dart';
import '../account/my_deep_link_screen.dart';
import '../auth/survey_screen.dart';
import '../compensation/cash_sent_history_screen.dart';
import '../compensation/cash_transfer_history_screen.dart';
import '../compensation/commission_payout_history_screen.dart';
import '../compensation/commission_spent_screen.dart';
import '../compensation/my_compensation_history_screen.dart';
import '../compensation/my_daily_compensation_log_screen.dart';
import '../marketing/my_leads_screen.dart';
import '../marketing/my_shared_flyers_screen.dart';
import '../marketing/shop_moremito_screen.dart';
import '../marketing/tmris_info_screen.dart';
import '../notification/notification_settings_screen.dart';
import '../order/my_referral_orders_screen.dart';
import '../support/create_support_ticket_screen.dart';
import '../support/support_tickets_list_screen.dart';
import '../profile/my_profile_screen.dart';

import '../../controller/home_controller.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();

  bool isMember(String role) => role == "member";

  bool isMemberOrReferring(String role) =>
      role == "member" || role == "referringcustomer";

  bool isAll(String role) =>
      role == "member" ||
      role == "referringcustomer" ||
      role == "friendoffoxx" ||
      role == "";

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = homeController.loginUserRole.value.toLowerCase();

      List<MenuSection> sections = [];

      // ================= MY INFO =================
      if (isAll(role)) {
        sections.add(
          MenuSection(
            title: "My Info",
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            items: [
              MenuItem(
                title: "My Profile",
                icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const MyProfileScreen()),
              ),
              MenuItem(
                title: "Notification Settings",
                icon: PhosphorIcons.bell(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const NotificationSettingsScreen()),
              ),
              MenuItem(
                title: "User Survey",
                icon: PhosphorIcons.chartBar(PhosphorIconsStyle.regular),
                onTap: () =>
                    Get.to(() => SurveyScreen(isFromOnboarding: false)),
              ),
            ],
          ),
        );
      }

      // ================= ORDERS =================
      if (isAll(role)) {
        sections.add(
          MenuSection(
            title: "Orders",
            icon: PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular),
            items: [
              MenuItem(
                title: "My Orders",
                icon: PhosphorIcons.receipt(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "MyOrders",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(url: url, title: "My Orders"));
                    },
                  );
                },
              ),

              // ✅ NEW MENU ITEM
              MenuItem(
                title: "My Personal Referral's Orders",
                icon: PhosphorIcons.usersThree(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const MyReferralOrdersScreen()),
              ),

              MenuItem(
                title: "Create A New Autoship Order",
                icon: PhosphorIcons.calendarPlus(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "autoshiporder",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                          url: url, title: "Create A New Autoship Order"));
                    },
                  );
                },
              ),
              MenuItem(
                title: "Recurring Orders",
                icon: PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "AutoShip",
                    onSuccess: (url) {
                      Get.to(() =>
                          CommonWebView(url: url, title: "Recurring Orders"));
                    },
                  );
                },
              ),
            ],
          ),
        );
      }

      // ================= SUPPORT =================
      if (isAll(role)) {
        sections.add(
          MenuSection(
            title: "Support",
            icon: PhosphorIcons.headset(PhosphorIconsStyle.regular),
            items: [
              MenuItem(
                title: "Support Ticket List",
                icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => SupportTicketsListScreen()),
              ),
              MenuItem(
                title: "Create Support Ticket",
                icon: PhosphorIcons.plusCircle(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => CreateSupportTicketScreen()),
              ),
              MenuItem(
                title: "Order Comments",
                icon: PhosphorIcons.chatCircleDots(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "MyOrders",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(url: url, title: "My Orders"));
                    },
                  );
                },
              ),
            ],
          ),
        );
      }

      // ================= SHARE INFO =================
      if (isAll(role)) {
        sections.add(
          MenuSection(
            title: "Share MoreMito Info",
            icon: PhosphorIcons.megaphone(PhosphorIconsStyle.regular),
            items: [
              MenuItem(
                title: "Customize & Share My Flyers",
                icon: PhosphorIcons.paintBrushBroad(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    actionName: "Template",
                    page: "FlyerPage",
                    id: "1",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(url: url, title: "My Flyers"));
                    },
                  );
                },
              ),
              MenuItem(
                title: "Share Audios, Videos & Docs",
                icon: PhosphorIcons.files(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => CategoriesScreen(isFromMenu: true)),
              ),
              MenuItem(
                title: "Allow Others to Request MoreMito Info",
                icon: PhosphorIcons.userPlus(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => TmrisInfoScreen()),
              ),
              MenuItem(
                title: "See My Generated Leads",
                icon: PhosphorIcons.trendUp(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => MyLeadsScreen()),
              ),
              MenuItem(
                title: "See & Track Activity From My Shared Links",
                icon: PhosphorIcons.target(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => MySharedFlyersScreen()),
              ),
            ],
          ),
        );
      }

      // ================= COMPENSATION =================
      if (isMemberOrReferring(role)) {
        sections.add(
          MenuSection(
            title: "Compensation",
            icon: PhosphorIcons.coins(PhosphorIconsStyle.regular),
            items: [
              MenuItem(
                title: "My Daily Compensation Log",
                icon: PhosphorIcons.notebook(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const MyDailyCompensationLogScreen()),
              ),
              MenuItem(
                title: "My Compensation History",
                icon: PhosphorIcons.clockCounterClockwise(
                    PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const MyCompensationHistoryScreen()),
              ),
              MenuItem(
                title: "Commission Payout History",
                icon: PhosphorIcons.clockCounterClockwise(
                    PhosphorIconsStyle.regular),
                onTap: () =>
                    Get.to(() => const CommissionPayoutHistoryScreen()),
              ),
              if (isMember(role))
                MenuItem(
                  title: "Request A Payout",
                  icon: PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "payout",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "Request A Payout"));
                      },
                    );
                  },
                ),
              MenuItem(
                title: "Transfer History",
                icon: PhosphorIcons.clockCounterClockwise(
                    PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const CashTransferHistoryScreen()),
              ),
              MenuItem(
                title: "Compensation Spent On Orders",
                icon: PhosphorIcons.bag(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const CommissionSpentScreen()),
              ),
              MenuItem(
                title: "MoreMito Cash Sent To Others",
                icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => const CashSentHistoryScreen()),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(title: "Menu", visibleBackButton: true),
        body: BaseBackgroundWidget(
          child: ListView(
            padding: EdgeInsets.all(10.sp),
            children: [
              ...sections.map((e) => MenuSectionWidget(section: e)),
              if (isAll(role))
                SettingsTile(
                  title: "Shop MoreMito Products",
                  icon: Icons.shopping_cart_outlined,
                  onTap: () => Get.to(() => const ShopMoremitoScreen()),
                ),
              if (isAll(role))
                SettingsTile(
                  title: "Direct Links",
                  icon: Icons.link_outlined,
                  onTap: () => Get.to(() => const MyDeepLinksScreen()),
                ),
            ],
          ),
        ),
      );
    });
  }
}
