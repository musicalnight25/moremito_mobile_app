import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:more_mitro_app/pages/setting/widget/settings_tile.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';

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
        icon: Icons.person_outline,
        items: [
          MenuItem(
            title: "My Profile",
            icon: Icons.account_circle_outlined,
            onTap: () => Get.to(() => MyProfileScreen()),
          ),
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
          MenuItem(
            title: "User Survey",
            icon: Icons.poll_outlined,
            onTap: () => Get.to(() => SurveyScreen(isFromOnboarding: false)),
          ),
        ],
      ),

      /// ---------------- ORDERS ----------------
      MenuSection(
        title: "Orders",
        icon: Icons.shopping_bag_outlined,
        items: [
          MenuItem(
            title: "My Orders",
            icon: Icons.receipt_long_outlined,
            onTap: () => Get.to(() => MyOrdersScreen()),
          ),
        ],
      ),

      /// ---------------- SUPPORT ----------------
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

      /// ---------------- SHARE INFO ----------------
      MenuSection(
        title: "Share MoreMito Info",
        icon: Icons.campaign_outlined,
        items: [
          MenuItem(
            title: "Customize & Share My Flyers",
            icon: Icons.brush_outlined,
            onTap: () async {
              await WebviewHelper.getDynamicWebviewURL(
                actionName: "Template",
                page: "FlyerPage",
                id: "1",
                onSuccess: (url) {
                  Get.to(() => CommonWebView(url: url, title: "My Flyers"));
                },
                onError: (msg) {
                  CommonMethod.getXSnackBar("Error", msg, redColor);
                },
              );
            },
          ),
          MenuItem(
            title: "Share Audios, Videos & Docs",
            icon: Icons.perm_media_outlined,
            onTap: () => Get.to(() => CategoriesScreen(isFromMenu: true)),
          ),
          MenuItem(
            title: "Allow Others to Request MoreMito Info",
            icon: Icons.group_add_outlined,
            onTap: () => Get.to(() => TmrisInfoScreen()),
          ),
          MenuItem(
            title: "See My Generated Leads",
            icon: Icons.trending_up_outlined,
            onTap: () => Get.to(() => MyLeadsScreen()),
          ),
          MenuItem(
            title: "See & Track Activity From My Shared Links",
            icon: Icons.track_changes_outlined,
            onTap: () => Get.to(() => MySharedFlyersScreen()),
          ),
        ],
      ),

      /// ---------------- COMPENSATION (WEB STYLE) ----------------
      MenuSection(
        title: "Compensation",
        icon: Icons.payments_outlined,
        items: [
          MenuItem(
            title: "My Compensations",
            icon: Icons.payments_outlined,
            children: [
              MenuItem(
                title: "My Daily Compensation Log",
                icon: Icons.event_note_outlined,
                onTap: () => Get.to(() => const MyDailyCompensationLogScreen()),
              ),
              MenuItem(
                title: "My Compensation History",
                icon: Icons.history_outlined,
                onTap: () => Get.to(() => const MyCompensationHistoryScreen()),
              ),
            ],
          ),
          MenuItem(
            title: "My Currently Available Balance",
            icon: Icons.account_balance_wallet_outlined,
            onTap: () async {
              await WebviewHelper.getDynamicWebviewURL(
                page: "MemberPage",
                actionName: "MyMoreMitoCash",
                onSuccess: (url) {
                  Get.to(() => CommonWebView(
                        url: url,
                        title: "My Currently Available Balance",
                      ));
                },
                onError: (msg) {
                  CommonMethod.getXSnackBar("Error", msg, redColor);
                },
              );
            },
          ),
          MenuItem(
            title: "Request Payouts And Make Transfers",
            icon: Icons.swap_horiz_outlined,
            children: [
              MenuItem(
                title: "Request A Payout",
                icon: Icons.request_page_outlined,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "payout",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "Request A Payout",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
                    },
                  );
                },
              ),
              MenuItem(
                title: "Commission Payout History",
                icon: Icons.history,
                onTap: () {
                  Get.to(() => const CommissionPayoutHistoryScreen());
                },
              ),
              MenuItem(
                title: "Transfer MoreMito Cash",
                icon: Icons.swap_calls_outlined,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "TransferMC",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "Transfer MoreMito Cash",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
                    },
                  );
                },
              ),
              MenuItem(
                title: "Transfer History",
                icon: Icons.swap_calls_outlined,
                onTap: () {
                  Get.to(() => const CashTransferHistoryScreen());
                },
              ),
            ],
          ),
          MenuItem(
            title: "History Of Compensation Spent",
            icon: Icons.history_outlined,
            children: [
              MenuItem(
                title: "Compensation Spent On Orders",
                icon: Icons.shopping_cart_outlined,
                onTap: () {
                  Get.to(() => const CommissionSpentScreen());
                },
              ),
              MenuItem(
                title: "MoreMito Cash Sent To Others",
                icon: Icons.send_outlined,
                onTap: () {
                  Get.to(() => const CashSentHistoryScreen());
                },
              ),
              MenuItem(
                title: "Commission Payout History",
                icon: Icons.payments_outlined,
                onTap: () {
                  Get.to(() => const CommissionPayoutHistoryScreen());
                },
              ),
            ],
          ),
          MenuItem(
            title: "The Compensation Plan",
            icon: Icons.picture_as_pdf_outlined,
            children: [
              MenuItem(
                title: "Compensation Plan PDF",
                icon: Icons.picture_as_pdf,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "CompensationPlanPdf",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "Compensation Plan",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
                    },
                  );
                },
              ),
            ],
          ),
          MenuItem(
            title: "My Rank Management",
            icon: Icons.leaderboard_outlined,
            children: [
              MenuItem(
                title: "Rank Management Report",
                icon: Icons.bar_chart_outlined,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "MyRankManagementReport",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "My Rank Management Report",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
                    },
                  );
                },
              ),
              MenuItem(
                title: "My Tree View",
                icon: Icons.account_tree_outlined,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "Genealogy",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "My Tree View",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
                    },
                  );
                },
              ),
              MenuItem(
                title: "My Star Tree View",
                icon: Icons.schema_outlined,
                onTap: () async {
                  await WebviewHelper.getDynamicWebviewURL(
                    page: "MemberPage",
                    actionName: "treeview",
                    onSuccess: (url) {
                      Get.to(() => CommonWebView(
                            url: url,
                            title: "My Star Tree View",
                          ));
                    },
                    onError: (msg) {
                      CommonMethod.getXSnackBar("Error", msg, redColor);
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
/// SECTION WIDGET
/// =========================
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
                    child: Text(widget.section.title,
                        style: AppTextStyle.normalSemiBold15),
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
                  .map((item) => MenuItemWidget(item: item, level: 0))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

/// =========================
/// MENU ITEM (RECURSIVE)
/// =========================
class MenuItemWidget extends StatefulWidget {
  final MenuItem item;
  final int level;

  const MenuItemWidget({required this.item, required this.level});

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
                Icon(widget.item.icon, size: 18.sp, color: Colors.black54),
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
                .map((e) => MenuItemWidget(item: e, level: widget.level + 1))
                .toList(),
          ),
      ],
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
