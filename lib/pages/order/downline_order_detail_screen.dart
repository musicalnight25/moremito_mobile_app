import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/downline_order_detail_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class DownlineOrderDetailScreen extends StatefulWidget {
  final int orderId;
  final int userId;

  const DownlineOrderDetailScreen({
    super.key,
    required this.orderId,
    required this.userId,
  });

  @override
  State<DownlineOrderDetailScreen> createState() =>
      _DownlineOrderDetailScreenState();
}

class _DownlineOrderDetailScreenState extends State<DownlineOrderDetailScreen> {
  final controller = Get.put(DownlineOrderDetailController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetail(
        orderId: widget.orderId,
        userId: widget.userId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Downline Order Details",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          final data = controller.orderData.value;

          if (data == null) {
            return const Center(child: Text("No order details found"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            child: Column(
              children: [
                /// ================= ORDER INFO =================
                ShadowContainerWidget(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${data.myOrders.orderId}",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                      const Divider(height: 16),
                      _tableRow("Customer",
                          "${data.myOrders.firstName} ${data.myOrders.lastName}"),
                      _tableRow("Email", data.myOrders.email),
                      _tableRow("Phone", data.myOrders.phoneNumber),
                      _tableRow("Address", data.myOrders.address1),
                      _tableRow("Status", data.orderStatus),
                      _tableRow("Payment", data.paymentMethodStatus),
                    ],
                  ),
                ),

                height20,

                /// ================= PRODUCTS =================
                ShadowContainerWidget(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                      const Divider(height: 16),
                      ...data.items.map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.productName,
                              style: AppTextStyle.normalSemiBold14
                                  .copyWith(color: primaryBlack),
                            ),
                            height10,
                            _tableRow("Qty", e.quantity.toString()),
                            _tableRow("Unit Price",
                                "\$${e.unitPrice.toStringAsFixed(2)}"),
                            _tableRow(
                                "Total", "\$${e.total.toStringAsFixed(2)}"),
                            const Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                height20,

                /// ================= TOTAL =================
                ShadowContainerWidget(
                  widget: Column(
                    children: [
                      _tableRow("Sub Total",
                          "\$${data.myOrders.subTotal.toStringAsFixed(2)}"),
                      _tableRow("Shipping",
                          "\$${data.myOrders.shippingTotal.toStringAsFixed(2)}"),
                      _tableRow("Tax",
                          "\$${data.myOrders.orderTax.toStringAsFixed(2)}"),
                      const Divider(height: 16),
                      _tableRow(
                        "Order Total",
                        "\$${data.orderTotal.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style:
                  AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
            ),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style:
                  AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
            ),
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
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, __) {
          return ShadowContainerWidget(
            widget: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16.sp, width: 160.w, color: Colors.white),
                  SizedBox(height: 12.sp),
                  Container(
                      height: 1, width: double.infinity, color: Colors.white),
                  SizedBox(height: 12.sp),
                  _shimmerRow(),
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
            flex: 3,
            child: Container(
              height: 14.sp,
              color: Colors.white,
            ),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Container(
              height: 14.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
