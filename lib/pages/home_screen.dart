import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../controller/home_controller.dart';
import '../model/dashboard_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.getDashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CommonAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Obx(() {
            final user = homeController.dashboardModel.value;
            if (user == null && homeController.isLoading.value == false) {
              return NoDataFound();
            }
            if (user == null) {
              return SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShadowContainerWidget(
                blurRadius: 0,
                borderColor: disableButtonColor,
                borderWidth: .9,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ProfileCardContent(
                        name:
                            '${homeController.dashboardModel.value?.name ?? "-"} (${homeController.dashboardModel.value?.userName ?? "-"})',
                        rank:
                            '${homeController.dashboardModel.value?.currentRank ?? '-'}',
                      ),
                    ),
                    customHeight(24),
                    Obx(() => homeController.dashboardModel.value != null
                        ? MembershipInfo(
                            data: homeController.dashboardModel.value!)
                        : SizedBox())
                  ],
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
    required this.name,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        customHeight(4),
        NameWithValue(name: name, value: rank), // Reusable widget
      ],
    );
  }
}

class NameWithValue extends StatelessWidget {
  final String name;
  final String value;

  const NameWithValue({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: AppTextStyle.normalBold20.copyWith(color: primaryColor),
          textAlign: TextAlign.center,
        ),
        customHeight(4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(22),
            color: primaryColor.withOpacity(.1), // Example color
          ),
          child: Text(
            value,
            style: AppTextStyle.normalSemiBold16
                .copyWith(color: primaryColor), // Example color
          ),
        ),
      ],
    );
  }
}

class MembershipInfo extends StatelessWidget {
  final DashboardModel data;

  const MembershipInfo({required this.data});

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
        Divider(
          color: lightGreyColor,
          height: 40,
        ),
        Text(
          'Highest Rank Achieved:',
          style: AppTextStyle.normalBold12.copyWith(color: lightBlackColor),
        ),
        customHeight(2),
        Text(
          data.highestRank ?? "-",
          style: AppTextStyle.normalBold18,
        ), // Assuming rank is accessible here. If not, pass it as a parameter.
      ],
    );
  }
}
