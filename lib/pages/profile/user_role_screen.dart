import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

import '../../controller/user_role_controller.dart';
import '../../model/user_role_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class UserRoleScreen extends StatelessWidget {
  const UserRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRoleController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "User Role",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(18.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Current Role"),
                      _currentRoleCard(
                        controller.roleData.value?.currentRole,
                      ),
                      height20,
                      _sectionTitle("Available Roles"),
                      ...controller.roleData.value!.availableRoles!.map(
                        (role) => _roleTile(
                          role: role,
                          controller: controller,
                        ),
                      ),
                      height30,
                      PrimaryTextButton(
                        onPressed: controller.changeRole,
                        title: "Change Role",
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ───────────────── UI HELPERS ─────────────────

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Text(
        text,
        style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _currentRoleCard(CurrentRole? role) {
    if (role == null) return const SizedBox();

    return Container(
      width: Get.width,
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(.08),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role.roleName ?? "",
            style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
          ),
          height04,
          Text(
            role.description ?? "",
            style: AppTextStyle.normalRegular14,
          ),
        ],
      ),
    );
  }

  Widget _roleTile({
    required AvailableRole role,
    required UserRoleController controller,
  }) {
    return Obx(
      () => RadioListTile<AvailableRole>(
        value: role,
        groupValue: controller.selectedRole.value,
        onChanged: (val) => controller.selectedRole.value = val,
        title: Text(
          role.roleName ?? "",
          style: AppTextStyle.normalBold14,
        ),
        subtitle: Text(
          role.description ?? "",
          style: AppTextStyle.normalRegular14,
        ),
        activeColor: primaryColor,
      ),
    );
  }
}
