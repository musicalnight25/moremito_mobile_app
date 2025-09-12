import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/pages/categories_screen.dart';
import 'package:more_mitro_app/pages/home_screen.dart';
import 'package:more_mitro_app/pages/notification_screen.dart';
import 'package:more_mitro_app/pages/setting_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_asset.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

var homeController = Get.put(HomeController());

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final RxInt selectedIndex = 0.obs;

  LoginController loginController = Get.put(LoginController());
  final List<Widget> widgetList = [
    HomeScreen(key: ValueKey('HomeScreen')),
    CategoriesScreen(key: ValueKey('CategoriesScreen')),
    NotificationScreen(key: ValueKey('NotificationScreen')),
    SettingScreen(key: ValueKey('SettingScreen')),
  ];
  @override
  void initState() {
    loginController.registerDeviceToken();
    notificationPermistion();
    super.initState();
  }

  void navigateToPage(int pageIndex) {
    selectedIndex.value = pageIndex;
  }

  notificationPermistion() async {
    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex.value != 0) {
          selectedIndex.value = 0;
          return false;
        }
        CommonMethod.showCustomBottomSheet(
            title: "Confirm Exit",
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
        child: Obx(() => Scaffold(
              backgroundColor: Colors.transparent,
              body: IndexedStack(
                index: selectedIndex.value,
                children: widgetList,
              ),
              bottomNavigationBar: _buildBottomNavigationBar(),
            )),
      ),
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
                selectedIndex.value = index;
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
        label: "Home",
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
        label: "Categories",
      ),
      BottomNavigationBarItem(
        icon: Obx(() => Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  AppAsset.notification,
                  fit: BoxFit.scaleDown,
                  height: 24.sp,
                  width: 24.sp,
                  color: primaryBlack,
                ),
                if ((homeController
                            .dashboardModel.value?.unreadNotificationCount ??
                        0) >
                    0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.sp,
                        minHeight: 18.sp,
                      ),
                      child: Text(
                        (homeController.dashboardModel.value
                                    ?.unreadNotificationCount ??
                                0)
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            )),
        activeIcon: Obx(() => Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  AppAsset.notification,
                  fit: BoxFit.scaleDown,
                  height: 24.sp,
                  width: 24.sp,
                  color: redColor,
                ),
                if ((homeController
                            .dashboardModel.value?.unreadNotificationCount ??
                        0) >
                    0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.sp,
                        minHeight: 18.sp,
                      ),
                      child: Text(
                        (homeController.dashboardModel.value
                                    ?.unreadNotificationCount ??
                                0)
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            )),
        label: "Notification",
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
        label: "Setting",
      ),
    ];
  }
}
