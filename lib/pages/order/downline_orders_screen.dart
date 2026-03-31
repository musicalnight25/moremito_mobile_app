import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/downline_orders_controller.dart';
import '../../model/downline_orders_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';
import 'downline_order_detail_screen.dart';

class DownlineOrdersScreen extends StatefulWidget {
  const DownlineOrdersScreen({super.key});

  @override
  State<DownlineOrdersScreen> createState() => _DownlineOrdersScreenState();
}

class _DownlineOrdersScreenState extends State<DownlineOrdersScreen> {
  final controller = Get.put(DownlineOrdersController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDownlineOrders(isRefresh: true);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          controller.hasMore &&
          !controller.isLoadMore.value) {
        controller.fetchDownlineOrders();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Downline Orders".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            _filterSection(),
            Expanded(child: _orderList()),
          ],
        ),
      ),
    );
  }

  Widget _filterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
      child: ShadowContainerWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Row 1
            Row(
              children: [
                Expanded(
                  child: _slickField(
                    controller: controller.usernameController,
                    hint: "Username",
                    icon: Icons.person_outline,
                  ),
                ),
                width08,
                Expanded(
                  child: _slickField(
                    controller: controller.orderIdController,
                    hint: "Order No",
                    icon: Icons.receipt_long_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            height08,

            /// Row 2
            Row(
              children: [
                Expanded(child: _slickDateField("From", controller.fromDate)),
                width08,
                Expanded(child: _slickDateField("To", controller.toDate)),
              ],
            ),

            height10,

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 34.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 2,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () =>
                          controller.fetchDownlineOrders(isRefresh: true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 15, color: primaryWhite),
                          SizedBox(width: 6),
                          Text(
                            "Search".tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                width08,
                Expanded(
                  child: SizedBox(
                    height: 34.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: mintGreenColor,
                        side: BorderSide(color: borderGreyColor),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: controller.resetFilters,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 15, color: primaryColor),
                          SizedBox(width: 6),
                          Text(
                            "Reset".tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _slickField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyle.normalRegular13.copyWith(color: primaryBlack),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.normalRegular13.copyWith(color: hintGreyColor),

        prefixIcon: Icon(icon, size: 16, color: primaryColor),

        isDense: true,
        filled: true,
        fillColor: paleYellowColor, // soft branded background

        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 9.sp),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 1.3),
        ),

        // Optional clear button when typing (nice UX)
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, size: 14),
                color: hintGreyColor,
                onPressed: () {
                  controller.clear();
                },
              )
            : null,
      ),
    );
  }

  Widget _slickDateField(String label, RxString date) {
    return Obx(
      () => InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor, // header + selected date
                    onPrimary: primaryWhite, // text on header
                    onSurface: primaryBlack, // body text
                  ),
                  dialogBackgroundColor: primaryWhite,
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            date.value = picked.toIso8601String().split("T").first;
          }
        },
        child: _dateBox(label, date.value),
      ),
    );
  }

  Widget _dateBox(String label, String value) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      decoration: BoxDecoration(
        color: paleYellowColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderGreyColor),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_outlined, size: 16, color: primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value.isEmpty ? label : value,
              style: AppTextStyle.normalRegular13.copyWith(
                color: value.isEmpty ? hintGreyColor : primaryBlack,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: hintGreyColor),
        ],
      ),
    );
  }

  Widget _orderList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerLoading();
      }

      if (controller.orderList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 48.sp, color: Colors.grey),
              height10,
              Text(
                "No orders found".tr,
                style:
                    AppTextStyle.normalRegular14.copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
        itemCount: controller.orderList.length + 1,
        itemBuilder: (context, index) {
          if (index < controller.orderList.length) {
            return _orderCard(controller.orderList[index]);
          } else {
            return controller.isLoadMore.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          }
        },
      );
    });
  }

  // ================= CARD =================

  Widget _orderCard(DownlineOrder order) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DownlineOrderDetailScreen(
              orderId: order.orderId,
              userId: order.userId,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ShadowContainerWidget(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.userName,
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(color: primaryBlack),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const Divider(height: 16),
              _tableRow("Order No", "#${order.orderId}"),
              _tableRow("Amount", "\$${order.orderAmount.toStringAsFixed(2)}"),
              _tableRow(
                "Date",
                CommonMethod.formatDateFromDateTime(
                  DateTime.parse(order.orderDate),
                ),
              ),
              _tableRow("Status", order.shippingStatusText),
              _tableRow("Shipping", order.shippingMethod ?? "N/A"),
              _tableRow("Tracking", order.trackingId ?? "N/A"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: AppTextStyle.normalRegular14
                    .copyWith(color: hintGreyColor)),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppTextStyle.normalSemiBold14
                    .copyWith(color: primaryBlack)),
          ),
        ],
      ),
    );
  }

  // ================= SHIMMER =================

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: ListView.separated(
        padding: EdgeInsets.all(16.sp),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, __) {
          return ShadowContainerWidget(
            widget: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16.sp, width: 140.w, color: Colors.white),
                  SizedBox(height: 12.sp),
                  Container(
                      height: 1, width: double.infinity, color: Colors.white),
                  SizedBox(height: 12.sp),
                  _shimmerRow(),
                  _shimmerRow(),
                  _shimmerRow(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shimmerRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          Expanded(
              flex: 3, child: Container(height: 14.sp, color: Colors.white)),
          width15,
          Expanded(
              flex: 5, child: Container(height: 14.sp, color: Colors.white)),
        ],
      ),
    );
  }
}