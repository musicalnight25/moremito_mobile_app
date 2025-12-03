import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class MyAccountInfoScreen extends StatelessWidget {
  const MyAccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "My Account Information",
        visibleBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _myInfoCard(),
            customHeight(16),
            _addressCard(),
            customHeight(16),
            _websiteHeaderCard(),
            customHeight(20),
          ],
        ),
      ),
    );
  }

  // ================= MY INFORMATION =================
  Widget _myInfoCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("My Information"),
          customHeight(10),
          _rowItem("Username", "shubham"),
          _rowItem("Text Message Code", "SK13"),
          _rowItem("First Name", "Shubham"),
          _rowItem("Last Name", "Kumar1"),
          _rowItem("Email", "shubham_shandil@outlook.com"),
          _rowItem("Phone", "919812503572"),
          _rowItem("Membership Type", "Paid Representative"),
          _rowItem("Join date", "2022/05/22"),
          _rowItem("Whatsapp Phone (optional)", "123456788"),
          customHeight(8),
          _greenButton("Edit", () {}),
        ],
      ),
    );
  }

  // ================= MANAGE ADDRESSES =================
  Widget _addressCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Manage your addresses"),
          customHeight(6),

          Text(
            "Note: Changing your address here does not change your address on already created recurring orders. Go to Orders → Recurring orders to do that.",
            style: AppTextStyle.normalRegular12.copyWith(
              color: Colors.red,
              fontSize: 12.sp,
            ),
          ),

          customHeight(12),
          _rowItem("Address", "14105 E 19th Ave"),
          _rowItem("City", "Spokane Valley"),
          _rowItem("Country", "United States of America"),
          _rowItem("State", "Washington"),
          _rowItem("Zip", "99037"),

          customHeight(8),
          _greenButton("Edit address", () {}),
        ],
      ),
    );
  }

  // ================= WEBSITE HEADER DISPLAY =================
  Widget _websiteHeaderCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Your Website Header Display"),
          customHeight(10),
          _rowItem("Name", "Shubham Kumar alias1"),
          _rowItem("Email", "shubham_shandil_1@outlook.com"),
          _rowItem("Phone", "9812503573"),
          _rowItem("State", "Washington"),
          _rowItem("Zip", "99037"),
          customHeight(8),
          _greenButton("Edit", () {}),
        ],
      ),
    );
  }

  // ================= REUSABLE WHITE CARD =================
  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }

  // ================= ROW ITEM =================
  Widget _rowItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.normalRegular14.copyWith(
              color: Colors.black54,
              fontSize: 14.sp,
            ),
          ),
          customHeight(2),
          Text(
            value,
            style: AppTextStyle.normalBold16.copyWith(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _title(String text) {
    return Text(
      text,
      style: AppTextStyle.normalSemiBold16.copyWith(
        fontSize: 17.sp,
        color: Colors.black,
      ),
    );
  }

  // ================= GREEN BUTTON =================
  Widget _greenButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Text(
          text,
          style: AppTextStyle.normalSemiBold14.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
