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
            onTap: () => Get.to(() => SurveyScreen(
                  isFromOnboarding: false,
                )),
          ),
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
              }),
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
      MenuSection(
        title: "Compensation",
        icon: Icons.payments_outlined,
        items: [
          MenuItem(
            title: "My Compensation History",
            icon: Icons.payments_outlined,
            onTap: () => Get.to(() => const MyCompensationHistoryScreen()),
          ),
          MenuItem(
            title: "My Daily Compensation Log",
            icon: Icons.event_note_outlined,
            onTap: () => Get.to(() => const MyDailyCompensationLogScreen()),
          ),
          MenuItem(
            title: "My Rank Management",
            icon: Icons.leaderboard_outlined,
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
            title: "My Rank History",
            icon: Icons.military_tech_outlined,
            onTap: () => Get.to(() => RankInfoScreen()),
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
          MenuItem(
            title: "My Tree View",
            icon: Icons.account_tree_outlined,
            onTap: () async {
              await WebviewHelper.getDynamicWebviewURL(
                page: "MemberPage",
                actionName: "Genealogy", // 👈 confirm backend action name
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
            title: "Compensation Plan (PDF)",
            icon: Icons.picture_as_pdf_outlined,
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
            title: "Transfer MoreMito Cash",
            icon: Icons.swap_horiz_outlined,
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
            // SizedBox(height: 10.h),
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
          InkWell(
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
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: primaryBlack,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: 250.milliseconds,
            child: expanded
                ? Column(
                    children: List.generate(
                      widget.section.items.length,
                      (index) => Column(
                        children: [
                          InkWell(
                            onTap: widget.section.items[index].onTap,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.sp, vertical: 10.sp),
                              child: Row(
                                children: [
                                  Icon(widget.section.items[index].icon,
                                      size: 18.sp, color: Colors.black54),
                                  width12,
                                  Expanded(
                                    child: Text(
                                      widget.section.items[index].title,
                                      style: AppTextStyle.normalSemiBold15
                                          .copyWith(color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }
}

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
