import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/pages/category/categories_screen.dart';
import 'package:more_mitro_app/pages/home/home_screen.dart';
import 'package:more_mitro_app/pages/setting/setting_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/pop_up_service.dart';
import '../utils/app_asset.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import 'notification/notification_screen.dart';

// HomeController is registered lazily by HomeScreen on first visit.
// This global tracks real-time unread notification count.
RxInt unreadNotificationCount = 0.obs;

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final RxInt selectedIndex = 0.obs;

  // Use lazyPut so the controller is only instantiated when first accessed.
  LoginController get loginController => Get.find<LoginController>();
  // Track which tabs have been visited so we can lazily build them.
  final Set<int> _visitedTabs = {0}; // Start with tab 0 already "visited".

  late final List<Widget> widgetList = [
    HomeScreen(key: const ValueKey('HomeScreen')),
    CategoriesScreen(
      key: const ValueKey('CategoriesScreen'),
      isFromMenu: false,
    ),
    NotificationScreen(key: const ValueKey('NotificationScreen')),
    SettingScreen(key: const ValueKey('SettingScreen')),
  ];

  @override
  void initState() {
    super.initState();
    // Defer all heavy/blocking work to after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Register device token in background — does not touch UI.
      loginController.registerDeviceToken();
      // Request notification permission after first frame (avoids dialog-on-startup jank).
      await notificationPermistion();
      // Firebase Remote Config fetch can take seconds — delay it further
      // so it never competes with initial UI rendering.
      Future.delayed(const Duration(seconds: 2), () {
        PopupService.runAppChecks();
      });
    });
  }

  void navigateToPage(int pageIndex) {
    selectedIndex.value = pageIndex;
    _visitedTabs.add(pageIndex);
  }

  notificationPermistion() async {
    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex.value != 0) {
          navigateToPage(0);
          return false;
        }
        CommonMethod.showCustomBottomSheet(
            title: "Confirm Exit".tr,
            message: 'Are you sure you want to close the app?',
            confirmButtonTitle: "Exit",
            showCancelButton: true,
            onConfirm: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            });
        return false;
      },
      child: BaseBackgroundWidget(
        child: Obx(() {
          final idx = selectedIndex.value;
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: _buildLazyBody(idx),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }),
      ),
    );
  }

  /// Lazily build tab widgets: only construct a tab on first visit,
  /// then use Offstage+TickerMode to hide/show without rebuilding.
  Widget _buildLazyBody(int currentIndex) {
    final tabs = widgetList;
    return Stack(
      children: List.generate(tabs.length, (i) {
        if (!_visitedTabs.contains(i)) {
          // Not yet visited — render nothing (zero cost).
          return const SizedBox.shrink();
        }
        return Offstage(
          offstage: currentIndex != i,
          child: TickerMode(
            enabled: currentIndex == i,
            child: tabs[i],
          ),
        );
      }),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      padding: EdgeInsets.only(top: 6.sp, bottom: 19.sp),
      child: ClipRRect(
        child: Obx(() => BottomNavigationBar(
              items: _navBarsItems(),
              elevation: 0,
              currentIndex: selectedIndex.value,
              backgroundColor: Colors.transparent,
              onTap: (index) {
                navigateToPage(index);
              },
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12.sp,
              unselectedFontSize: 12.sp,
              unselectedLabelStyle: AppTextStyle.normalRegular12.copyWith(
                  height: 1.8,
                  color: primaryBlack,
                  fontWeight: FontWeight.w400),
              selectedLabelStyle: AppTextStyle.normalRegular12
                  .copyWith(color: redColor, height: 1.9),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: redColor,
              unselectedItemColor: primaryBlack,
            )),
      ),
    );
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AppAsset.home,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: primaryBlack,
        ),
        activeIcon: SvgPicture.asset(
          AppAsset.home,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: redColor,
        ),
        label: "Home".tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AppAsset.dashboard,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: primaryBlack,
        ),
        activeIcon: SvgPicture.asset(
          AppAsset.dashboard,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: redColor,
        ),
        label: "Share Info".tr,
      ),
      BottomNavigationBarItem(
        icon: _buildNotificationIcon(),
        activeIcon: _buildNotificationIcon(),
        label: "Notification".tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AppAsset.settings,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: primaryBlack,
        ),
        activeIcon: SvgPicture.asset(
          AppAsset.settings,
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
          color: redColor,
        ),
        label: "Setting".tr,
      ),
    ];
  }

  Widget _buildNotificationIcon() {
    return Obx(() {
      int unreadCount = unreadNotificationCount.value;
      String displayCount = unreadCount > 99 ? '99+' : unreadCount.toString();

      return Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            AppAsset.notification,
            fit: BoxFit.scaleDown,
            height: 24.sp,
            width: 24.sp,
            color: selectedIndex.value == 2 ? redColor : primaryBlack,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -6.sp,
              top: -6.sp,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                constraints: BoxConstraints(
                  minWidth: 18.sp,
                  minHeight: 18.sp,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayCount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
