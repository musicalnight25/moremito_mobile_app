import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';
import 'package:more_mitro_app/pages/setting/widget/menu_section_widget.dart';
import 'package:more_mitro_app/pages/setting/widget/settings_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../service/webview_helper.dart';
import '../../utils/common_method.dart';
import '../../utils/common_web_view.dart';
import '../account/my_deep_link_screen.dart';
import '../account/rank_info_screen.dart';
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
import '../order/my_orders_screen.dart';
import '../profile/manage_addresses_screen.dart';
import '../profile/my_profile_screen.dart';
import '../profile/welcome_tag_screen.dart';
import '../support/create_support_ticket_screen.dart';
import '../support/support_tickets_list_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late List<MenuSection> sections;

  @override
  void initState() {
    super.initState();

    sections = [
      /// ---------------- MY INFO ----------------
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
            onTap: () => Get.to(() => SurveyScreen(isFromOnboarding: false)),
          ),
        ],
      ),

      /// ---------------- ORDERS ----------------
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
                  Get.to(
                      () => CommonWebView(url: url, title: "Recurring Orders"));
                },
              );
            },
          ),
        ],
      ),

      /// ---------------- SUPPORT ----------------
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
        ],
      ),

      /// ---------------- SHARE INFO ----------------
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

      /// ---------------- COMPENSATION ----------------
      MenuSection(
        title: "Compensation",
        icon: PhosphorIcons.coins(PhosphorIconsStyle.regular),
        items: [
          MenuItem(
            title: "My Compensations",
            icon: PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
            children: [
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
            ],
          ),
          MenuItem(
            title: "My Currently Available Balance",
            icon: PhosphorIcons.wallet(PhosphorIconsStyle.regular),
            onTap: () async {
              await WebviewHelper.getDynamicWebviewURL(
                page: "MemberPage",
                actionName: "MyMoreMitoCash",
                onSuccess: (url) {
                  Get.to(() =>
                      CommonWebView(url: url, title: "My Available Balance"));
                },
              );
            },
          ),
          MenuItem(
            title: "Request Payouts And Make Transfers",
            icon: PhosphorIcons.swap(PhosphorIconsStyle.regular),
            children: [
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
                title: "Commission Payout History",
                icon: PhosphorIcons.clockCounterClockwise(
                    PhosphorIconsStyle.regular),
                onTap: () =>
                    Get.to(() => const CommissionPayoutHistoryScreen()),
              ),
              MenuItem(
                title: "Transfer MoreMito Cash",
                icon: PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "TransferMC",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                          url: url, title: "Transfer MoreMito Cash"));
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
            ],
          ),
          MenuItem(
            title: "History Of Compensation Spent",
            icon:
                PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
            children: [
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
          MenuItem(
            title: "The Compensation Plan",
            icon: PhosphorIcons.filePdf(PhosphorIconsStyle.regular),
            children: [
              MenuItem(
                title: "Compensation Plan PDF",
                icon: PhosphorIcons.filePdf(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "CompensationPlanPdf",
                    onSuccess: (url) {
                      Get.to(() =>
                          CommonWebView(url: url, title: "Compensation Plan"));
                    },
                  );
                },
              ),
            ],
          ),
          MenuItem(
            title: "My Rank Management",
            icon: PhosphorIcons.medal(PhosphorIconsStyle.regular),
            children: [
              MenuItem(
                title: "Rank Management Report",
                icon: PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "MyRankManagementReport",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                          url: url, title: "My Rank Management Report"));
                    },
                  );
                },
              ),
              MenuItem(
                title: "View Rank History",
                icon: PhosphorIcons.clockCounterClockwise(
                    PhosphorIconsStyle.regular),
                onTap: () => Get.to(() => RankInfoScreen()),
              ),
              MenuItem(
                title: "My Tree View",
                icon: PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "Genealogy",
                    onSuccess: (url) {
                      Get.to(
                          () => CommonWebView(url: url, title: "My Tree View"));
                    },
                  );
                },
              ),
            ],
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
      body: BaseBackgroundWidget(
        child: ListView(
          padding: EdgeInsets.all(10.sp),
          children: [
            ...sections.map((e) => MenuSectionWidget(section: e)),
            SettingsTile(
              title: "Shop MoreMito Products",
              icon: Icons.shopping_cart_outlined,
              onTap: () => Get.to(() => const ShopMoremitoScreen()),
            ),
            SettingsTile(
              title: "Direct Links",
              icon: Icons.link_outlined,
              onTap: () => Get.to(() => const MyDeepLinksScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// MODELS
/// =========================
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
  final VoidCallback? onTap;
  final List<MenuItem>? children;

  MenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.children,
  });
}
