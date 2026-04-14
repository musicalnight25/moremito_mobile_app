import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';
import 'package:more_mitro_app/pages/setting/widget/menu_section_widget.dart';
import 'package:more_mitro_app/pages/setting/widget/settings_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/home_controller.dart';
import '../../model/menu_section_model.dart';
import '../../service/webview_helper.dart';
import '../../utils/share_link_helper.dart';
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
import '../order/downline_orders_screen.dart';
import '../order/my_referral_orders_screen.dart';
import '../profile/manage_addresses_screen.dart';
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
      log("-----role----->> $role");
      List<Widget> menuList = [];

      // ================= 1. MY INFO =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "My Info".tr,
              icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "My Account Settings".tr,
                  icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const MyProfileScreen()),
                ),
                MenuItem(
                  title: "Manage Addresses".tr,
                  icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const ManageAddressesScreen()),
                ),
                MenuItem(
                  title: "My Personals".tr,
                  icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyPersonals",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Personals".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Support Network".tr,
                  icon: PhosphorIcons.usersFour(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyRep",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Support Network".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Email Notification Settings".tr,
                  icon:
                      PhosphorIcons.envelopeSimple(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "NotificationSettings",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Email Notification Settings".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Text Notification Settings".tr,
                  icon: PhosphorIcons.chatText(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "SMSNotificationSettings",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Text Notification Settings".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "User Survey".tr,
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
              title: "My Network".tr,
              icon: PhosphorIcons.shareNetwork(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "My Personals".tr,
                  icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyPersonals",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Personals".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Tree View".tr,
                  icon: PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "Genealogy",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Tree View".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Star Tree View".tr,
                  icon: PhosphorIcons.star(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "treeview",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Star Tree View".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Search My Network".tr,
                  icon:
                      PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "GenealogySearch",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Search My Network".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Support Network".tr,
                  icon: PhosphorIcons.usersFour(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyRep",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "My Support Network".tr));
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
            title: "Shop MoreMito Products".tr,
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
              title: "Orders".tr,
              icon: PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "My Orders".tr,
                  icon: PhosphorIcons.receipt(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyOrders",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Orders".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "My Personal Referral's Orders".tr,
                  icon: PhosphorIcons.usersThree(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const MyReferralOrdersScreen()),
                ),
                MenuItem(
                  title: "Downline Orders".tr,
                  icon: PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => const DownlineOrdersScreen()),
                ),
                MenuItem(
                  title: "Create A New Autoship Order".tr,
                  icon: PhosphorIcons.calendarPlus(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "autoshiporder",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Create A New Autoship Order".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Recurring Orders".tr,
                  icon:
                      PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "AutoShip",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Recurring Orders".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Payment Settings".tr,
                  icon: PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyCards",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Payment Settings".tr));
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
              title: "Compensation".tr,
              icon: PhosphorIcons.coins(PhosphorIconsStyle.regular),
              items: [
                // 0. My Compensations
                MenuItem(
                  title: "My Compensations".tr,
                  icon: PhosphorIcons.money(PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "My Daily Compensation Log".tr,
                      icon: PhosphorIcons.notebook(PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const MyDailyCompensationLogScreen()),
                    ),
                    MenuItem(
                      title: "My Compensation History".tr,
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const MyCompensationHistoryScreen()),
                    ),
                  ],
                ),
                // 1. My Currently Available Balance
                MenuItem(
                  title: "My Currently Available Balance".tr,
                  icon: PhosphorIcons.wallet(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyMoreMitoCash",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url,
                            title: "My Currently Available Balance".tr));
                      },
                    );
                  },
                ),

                // 2. Manage My Payout Methods
                MenuItem(
                  title: "Manage My Payout Methods".tr,
                  icon: PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "PaymentMethods",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Manage My Payout Methods".tr));
                      },
                    );
                  },
                ),

                // 3. Request Payouts And Make Transfers
                MenuItem(
                  title: "Request Payouts And Make Transfers".tr,
                  icon:
                      PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.regular),
                  children: [
                    if (isMember(role))
                      MenuItem(
                        title: "Request A Payout".tr,
                        icon:
                            PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
                        onTap: () async {
                          await WebviewHelper.getDynamicWebviewURL(
                            page: "MemberPage",
                            actionName: "payout",
                            onSuccess: (url) {
                              Get.to(() => CommonWebView(
                                  url: url, title: "Request A Payout".tr));
                            },
                          );
                        },
                      ),
                    MenuItem(
                      title: "Commission Payout History".tr,
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const CommissionPayoutHistoryScreen()),
                    ),
                    MenuItem(
                      title: "Transfer MoreMito Cash".tr,
                      icon: PhosphorIcons.paperPlaneTilt(
                          PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "TransferMC",
                          onSuccess: (url) {
                            Get.to(() => CommonWebView(
                                url: url, title: "Transfer MoreMito Cash".tr));
                          },
                        );
                      },
                    ),
                    MenuItem(
                      title: "Transfer History".tr,
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const CashTransferHistoryScreen()),
                    ),
                  ],
                ),

                // 3. History Of Compensation Spent
                MenuItem(
                  title: "History Of Compensation Spent".tr,
                  icon: PhosphorIcons.clockCounterClockwise(
                      PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "Compensation Spent On Orders".tr,
                      icon: PhosphorIcons.bag(PhosphorIconsStyle.regular),
                      onTap: () => Get.to(() => const CommissionSpentScreen()),
                    ),
                    MenuItem(
                      title: "MoreMito Cash Sent To Others".tr,
                      icon: PhosphorIcons.paperPlaneTilt(
                          PhosphorIconsStyle.regular),
                      onTap: () => Get.to(() => const CashSentHistoryScreen()),
                    ),
                    MenuItem(
                      title: "Commission Payout History".tr,
                      icon: PhosphorIcons.clockCounterClockwise(
                          PhosphorIconsStyle.regular),
                      onTap: () =>
                          Get.to(() => const CommissionPayoutHistoryScreen()),
                    ),
                  ],
                ),

                // 4. The Compensation Plan
                MenuItem(
                  title: "The Compensation Plan".tr,
                  icon: PhosphorIcons.file(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "CompensationPlanPdf",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "The Compensation Plan".tr));
                      },
                    );
                  },
                ),

                // 5. My Rank Management
                MenuItem(
                  title: "My Rank Management".tr,
                  icon: PhosphorIcons.medal(PhosphorIconsStyle.regular),
                  children: [
                    MenuItem(
                      title: "My Tree View".tr,
                      icon: PhosphorIcons.treeStructure(
                          PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "Genealogy",
                          onSuccess: (url) {
                            Get.to(() => CommonWebView(
                                url: url, title: "My Tree View".tr));
                          },
                        );
                      },
                    ),
                    MenuItem(
                      title: "My Star Tree View".tr,
                      icon: PhosphorIcons.star(PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "treeview",
                          onSuccess: (url) {
                            Get.to(() => CommonWebView(
                                url: url, title: "My Star Tree View".tr));
                          },
                        );
                      },
                    ),
                    MenuItem(
                      title: "Rank Management Report".tr,
                      icon: PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
                      onTap: () async {
                        await WebviewHelper.getDynamicWebviewURL(
                          page: "MemberPage",
                          actionName: "MyRankManagementReport",
                          onSuccess: (url) {
                            Get.to(() => CommonWebView(
                                url: url, title: "Rank Management Report".tr));
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
          MenuSectionWidget(
            section: MenuSection(
              title: "Resources".tr,
              icon: PhosphorIcons.bookOpen(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "Mitochondria Story".tr,
                  icon: PhosphorIcons.article(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "Training",
                      onSuccess: (url) async {
                        final uri = Uri.tryParse(url);
                        if (uri != null) {
                          final openedInApp = await launchUrl(
                            uri,
                            mode: LaunchMode.inAppBrowserView,
                          );
                          if (openedInApp) return;

                          final openedExternal = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (openedExternal) return;
                        }

                        Get.to(() => CommonWebView(
                            url: url, title: "Mitochondria Story".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Testimonials".tr,
                  icon:
                      PhosphorIcons.chatCircleDots(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "Testimonials",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "Testimonials".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Grief Relief Zoom Call 7-14-24".tr,
                  icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "EmailTemplates",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url,
                            title: "Grief Relief Zoom Call 7-14-24".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Health & Wellness Call Replays".tr,
                  icon: PhosphorIcons.heartbeat(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "HealthWellness",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url,
                            title: "Health & Wellness Call Replays".tr));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }

      // ================= 7. DIRECT LINKS =================
      if (isAll(role)) {
        menuList.add(
          SettingsTile(
            title: "Direct Links".tr,
            icon: Icons.link_outlined,
            onTap: () => Get.to(() => const MyDeepLinksScreen()),
          ),
        );
      }

      // ================= 8. SHARE MOREMITO INFO =================
      if (isAll(role)) {
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "Share MoreMito Info".tr,
              icon: PhosphorIcons.megaphone(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "Customize And Share My Flyers".tr,
                  icon:
                      PhosphorIcons.paintBrushBroad(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      actionName: "Template",
                      page: "FlyerPage",
                      id: "1",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Flyers".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Share Audios, Videos & Docs Files".tr,
                  icon: PhosphorIcons.files(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => CategoriesScreen(isFromMenu: true)),
                ),
                MenuItem(
                  title: "Share MoreMito Content".tr,
                  icon: PhosphorIcons.share(PhosphorIconsStyle.regular),
                  onTap: () {
                    ShareLinkHelper.showShareLinkDialog(
                      context: context,
                      contentId: 'moremito_info',
                      contentTitle: "Share MoreMito Info".tr,
                      messageTemplate:
                          "Hey {recipient}, I'd like to share some valuable MoreMito information with you. "
                          "Check it out at: {link}",
                    );
                  },
                ),
                MenuItem(
                  title: "Allow Others To Request MoreMito Info From Me".tr,
                  icon: PhosphorIcons.userPlus(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => TmrisInfoScreen()),
                ),
                MenuItem(
                  title: "See My Generated Leads".tr,
                  icon: PhosphorIcons.trendUp(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => MyLeadsScreen()),
                ),
                MenuItem(
                  title: "See & Track Activity From My Shared Links".tr,
                  icon: PhosphorIcons.target(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => MySharedFlyersScreen()),
                ),
              ],
            ),
          ),
        );
      }

      // ================= 9. SUPPORT =================
      if (isAll(role)) {
        menuList.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: Text(
              "Help & Support".tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
        menuList.add(
          MenuSectionWidget(
            section: MenuSection(
              title: "Support".tr,
              icon: PhosphorIcons.headset(PhosphorIconsStyle.regular),
              items: [
                MenuItem(
                  title: "Customer Service Journal".tr,
                  icon: PhosphorIcons.notepad(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "journalreport",
                      onSuccess: (url) {
                        Get.to(() => CommonWebView(
                            url: url, title: "Customer Service Journal".tr));
                      },
                    );
                  },
                ),
                MenuItem(
                  title: "Support Ticket List".tr,
                  icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => SupportTicketsListScreen()),
                ),
                MenuItem(
                  title: "Create Support Ticket".tr,
                  icon: PhosphorIcons.plusCircle(PhosphorIconsStyle.regular),
                  onTap: () => Get.to(() => CreateSupportTicketScreen()),
                ),
                MenuItem(
                  title: "Order Comments".tr,
                  icon:
                      PhosphorIcons.chatCircleDots(PhosphorIconsStyle.regular),
                  onTap: () async {
                    await WebviewHelper.getDynamicWebviewURL(
                      page: "MemberPage",
                      actionName: "MyOrders",
                      onSuccess: (url) {
                        Get.to(() =>
                            CommonWebView(url: url, title: "My Orders".tr));
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
        appBar: CommonAppBar(title: "Menu".tr, visibleBackButton: true),
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
