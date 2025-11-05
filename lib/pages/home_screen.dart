import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await homeController.getDashboard();
          },
          child: Obx(() {
            final user = homeController.dashboardModel.value;

            if (user == null && !homeController.isLoading.value) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 400, // ensures pull-to-refresh still works
                  child: Center(child: NoDataFound(title: "Dashboard")),
                ),
              );
            }

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Center(
                child: ShadowContainerWidget(
                  blurRadius: 0,
                  borderColor: disableButtonColor,
                  borderWidth: .9,
                  radius: 10.sp,
                  widget: Padding(
                    padding: EdgeInsets.all(14.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ProfileCardContent(
                            name:
                                '${user.name ?? "-"} (${user.userName ?? "-"})',
                            rank: user.currentRank ?? "-",
                          ),
                        ),
                        customHeight(24),
                        MembershipInfo(data: user),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProfileCardContent extends StatelessWidget {
  final String name;
  final String rank;

  const ProfileCardContent({
    Key? key,
    required this.name,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome',
          style: AppTextStyle.normalBold20.copyWith(
            fontSize: 22.sp,
            color: primaryBlack,
          ),
        ),
        customHeight(6),
        NameWithValue(name: name, value: rank),
      ],
    );
  }
}

class NameWithValue extends StatelessWidget {
  final String name;
  final String value;

  const NameWithValue({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: AppTextStyle.normalBold20.copyWith(color: primaryColor),
          textAlign: TextAlign.center,
        ),
        customHeight(6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(22.sp),
            color: primaryColor.withOpacity(.1),
          ),
          child: Text(
            value,
            style: AppTextStyle.normalSemiBold16.copyWith(color: primaryColor),
          ),
        ),
      ],
    );
  }
}

class MembershipInfo extends StatelessWidget {
  final DashboardModel data;

  const MembershipInfo({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Membership Type:',
          style: AppTextStyle.normalBold12.copyWith(color: lightBlackColor),
        ),
        customHeight(2),
        Text(
          data.userRole ?? "-",
          style: AppTextStyle.normalBold18,
        ),
        Divider(color: lightGreyColor, height: 32.sp),
        Text(
          'Highest Rank Achieved:',
          style: AppTextStyle.normalBold12.copyWith(color: lightBlackColor),
        ),
        customHeight(2),
        Text(
          data.highestRank ?? "-",
          style: AppTextStyle.normalBold18,
        ),
      ],
    );
  }
}
