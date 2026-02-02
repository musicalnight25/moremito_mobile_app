import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';
import 'package:more_mitro_app/pages/setting/widget/menu_section_widget.dart';
import 'package:more_mitro_app/pages/setting/widget/settings_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../controller/home_controller.dart';
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
import '../order/downline_orders_screen.dart';
import '../order/my_referral_orders_screen.dart';
import '../profile/my_profile_screen.dart';
import '../support/create_support_ticket_screen.dart';
import '../support/support_tickets_list_screen.dart';

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

      List<Widget> menuList = [];

      // ================= 1. MY INFO =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "My Info",
              icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "My Account Settings",
                  icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const MyProfileScreen()),
                ),
                MenuItem(
                  title: "My Personals",
                  icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyPersonals",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Personals"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Support Network",
                  icon: PhosphorIcons.usersFour(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyRep",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Support Network"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Email Notification Settings",
                  icon:
                      PhosphorIcons.envelopeSimple(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "NotificationSettings",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Email Notification Settings"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Text Notification Settings",
                  icon: PhosphorIcons.chatText(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "SMSNotificationSettings",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Text Notification Settings"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "User Survey",
                  icon: PhosphorIcons.chartBar(PhosphorIconsStyle.regular),
                  onTap: () =>
                      Get.to(() => SurveyScreen(isFromOnboarding: false)),
                ),
              ],
            ),
          ),
        );
      }

      // ================= 2. MY NETWORK =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "My Network",
              icon: PhosphorIcons.shareNetwork(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "My Personals",
                  icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyPersonals",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Personals"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Tree View",
                  icon: PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "Genealogy",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Tree View"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Star Tree View",
                  icon: PhosphorIcons.star(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "treeview",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Star Tree View"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Search My Network",
                  icon:
                      PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "GenealogySearch",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Search My Network"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Support Network",
                  icon: PhosphorIcons.usersFour(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyRep",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Support Network"));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }

      // ================= 3. SHOP MOREMITO =================
      if (isAll(role)) {
        menuList.add(
          SettingsTile(
            title: "Shop MoreMito Products",
            icon: Icons.shopping_cart_outlined,
            onTap: () => Get.to(() => const ShopMoremitoScreen()),
          ),
        );
      }

      // ================= 4. ORDERS =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
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
                        Get.to(
                            () => CommonWebView(url: url, title: "My Orders"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Personal Referral's Orders",
                  icon: PhosphorIcons.usersThree(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const MyReferralOrdersScreen()),
                ),
                MenuItem(
                  title: "Downline Orders",
                  icon: PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const DownlineOrdersScreen()),
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
                  icon:
                      PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.regular),
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
          ),
        );
      }

      // ================= 5. COMPENSATION =================
      if (isMemberOrReferring(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "Compensation",
              icon: PhosphorIcons.coins(PhosphorIconsStyle.regular),
              items: [
                // 1. My Compensations
                MenuItem(
                  title: "My Compensations",
                  icon: PhosphorIcons.money(PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "My Daily Compensation Log",
                      icon: PhosphorIcons.notebook(PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const MyDailyCompensationLogScreen()),
                    ),
                    MenuItem(
                      title: "My Compensation History",
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const MyCompensationHistoryScreen()),
                    ),
                  ],
                ),

                // 2. Request Payouts And Make Transfers
                MenuItem(
                  title: "Request Payouts And Make Transfers",
                  icon:
                      PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.regular),
                  children: [
                    if (isMember(role))
                      MenuItem(
                        title: "Request A Payout",
                        icon:
                            PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
                        onTap: () async {
                          await WebviewHelper.getDynamicWebviewURL(
                            page: "MemberPage",
                            actionName: "payout",
                            onSuccess: (url) {
                              Get.to(() => CommonWebView(
                                  url: url, title: "Request A Payout"));
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
                      title: "Transfer History",
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const CashTransferHistoryScreen()),
                    ),
                  ],
                ),

                // 3. History Of Compensation Spent
                MenuItem(
                  title: "History Of Compensation Spent",
                  icon: PhosphorIcons.clockCounterClockwise(
                      PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "Compensation Spent On Orders",
                      icon: PhosphorIcons.bag(PhosphorIconsStyle.regular),
                      onTap: () => Get.to(() => const CommissionSpentScreen()),
                    ),
                    MenuItem(
                      title: "MoreMito Cash Sent To Others",
                      icon: PhosphorIcons.paperPlaneTilt(
                          PhosphorIconsStyle.regular),
                      onTap: () => Get.to(() => const CashSentHistoryScreen()),
                    ),
                    MenuItem(
                      title: "Commission Payout History",
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const CommissionPayoutHistoryScreen()),
                    ),
                  ],
                ),

                // 4. My Rank Management
                MenuItem(
                  title: "My Rank Management",
                  icon: PhosphorIcons.medal(PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "My Tree View",
                      icon: PhosphorIcons.treeStructure(
                          PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "Genealogy",
                          onSuccess: (url) {
                            Get.to(() =>
                                CommonWebView(url: url, title: "My Tree View"));
                          },
                        );
                      },
                    ),
                    MenuItem(
                      title: "My Star Tree View",
                      icon: PhosphorIcons.star(PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "treeview",
                          onSuccess: (url) {
                            Get.to(() => CommonWebView(
                                url: url, title: "My Star Tree View"));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      // ================= 6. DIRECT LINKS =================
      if (isAll(role)) {
        menuList.add(
          SettingsTile(
            title: "Direct Links",
            icon: Icons.link_outlined,
            onTap: () => Get.to(() => const MyDeepLinksScreen()),
          ),
        );
      }

      // ================= 7. SHARE MOREMITO INFO =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "Share MoreMito Info",
              icon: PhosphorIcons.megaphone(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "Customize And Share My Flyers",
                  icon:
                      PhosphorIcons.paintBrushBroad(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      actionName: "Template",
                      page: "FlyerPage",
                      id: "1",
                      onSuccess: (url) {
                        Get.to(
                            () => CommonWebView(url: url, title: "My Flyers"));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Share Audios, Videos & Docs Files",
                  icon: PhosphorIcons.files(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => CategoriesScreen(isFromMenu: true)),
                ),
                MenuItem(
                  title: "Allow Others To Request MoreMito Info From Me",
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
          ),
        );
      }

      // ================= 8. SUPPORT =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
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
                  icon:
                      PhosphorIcons.chatCircleDots(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyOrders",
                      onSuccess: (url) {
                        Get.to(
                            () => CommonWebView(url: url, title: "My Orders"));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(title: "Menu", visibleBackButton: true),
        body: BaseBackgroundWidget(
          child: ListView(
            padding: EdgeInsets.all(10.sp),
            children: menuList,
          ),
        ),
      );
    });
  }
}
