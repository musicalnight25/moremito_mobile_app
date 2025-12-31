import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // Add this to pubspec.yaml
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import '../../controller/contact_controller.dart';
import '../../utils/base_background_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Use Get.put or Get.find if already initialized
  final ContactController controller = Get.put(ContactController());

  @override
  void initState() {
    super.initState();
    controller.setupSearchListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Select Contact',
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextFormFieldWidget(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                onChanged: (value) =>
                    controller.searchQuery.value = value ?? '',
                controller: null,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerEffect();
                }

                if (controller.filteredContacts.isEmpty) {
                  return Center(
                    child: Text(
                      "No Contacts Found",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: hintGreyColor),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 10.h, bottom: 100.h),
                  itemCount: controller.filteredContacts.length,
                  separatorBuilder: (context, index) => Divider(
                    color: borderGreyColor,
                    indent: 75.w,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final contact = controller.filteredContacts[index];
                    return ListTile(
                      onTap: () => controller.selectContact(contact),
                      leading: CircleAvatar(
                        radius: 24.r,
                        backgroundColor: paleYellowColor,
                        child: Text(
                          contact.displayName.isNotEmpty
                              ? contact.displayName[0].toUpperCase()
                              : "?",
                          style: AppTextStyle.normalBold16
                              .copyWith(color: primaryColor),
                        ),
                      ),
                      title: Text(
                        contact.displayName,
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                      subtitle: Text(
                        contact.phones.first.number,
                        style: AppTextStyle.normalRegular14
                            .copyWith(color: subTitleColor),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchContacts(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.sync, color: Colors.white),
      ),
    );
  }

  // ───────────────── SHIMMER COMPONENT ─────────────────

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: lightGreyColor,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 12,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              children: [
                CircleAvatar(radius: 24.r, backgroundColor: Colors.white),
                width15,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 140.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4))),
                    height08,
                    Container(
                        width: 90.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
