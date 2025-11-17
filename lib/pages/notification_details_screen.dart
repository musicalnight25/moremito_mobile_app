import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/notification_controller.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../model/call_announcement_details_model.dart';
import '../model/notification_detail_model.dart';
import '../utils/common_method.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final String notificationId;

  const NotificationDetailsScreen({Key? key, required this.notificationId})
      : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final NotificationController controller = Get.put(NotificationController());
  InAppWebViewController? webView;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotificationDetail(context, widget.notificationId);
    });
  }

  Future<void> _onRefresh() async {
    await controller.getNotificationDetail(context, widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          final data = controller.notificationDetails.value;
          if (data == null) return NoDataFound(title: "Notification Details");

          // 3 possible screens → AutoShip, Message, WebView
          if (data.autoShipComing != null) {
            return _scrollContent(_buildAutoShipDetails(data.autoShipComing!));
          }

          if (data.messageDetails != null) {
            return _scrollContent(_buildMessageDetails(data.messageDetails!));
          }

          if (data.callAnnoucementDetails != null) {
            return _buildFullScreenWebView(data.callAnnoucementDetails!);
          }

          return NoDataFound(title: "Notification Details");
        }),
      ),
    );
  }

  /// ---------------------------------------------
  /// FULL SCREEN WEBVIEW (PROFESSIONAL IMPLEMENTATION)
  /// ---------------------------------------------
  Widget _buildFullScreenWebView(CallAnnouncementDetailsModel details) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: primaryColor,
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useWideViewPort: true,
                supportZoom: true,
                builtInZoomControls: false,
                displayZoomControls: false,
              ),
              initialData: InAppWebViewInitialData(
                data: details.htmlPart ?? "",
                mimeType: "text/html",
                encoding: "utf-8",
                baseUrl: WebUri("https://moremito.com/"),
              ),
              onWebViewCreated: (controller) => webView = controller,
              onLoadStop: (c, url) => debugPrint("WebView Loaded Successfully"),
              onConsoleMessage: (c, msg) =>
                  debugPrint("[WebView Console] ${msg.message}"),
            ),
          ),
        );
      },
    );
  }

  /// Wrap non-web content in a proper scroll view
  Widget _scrollContent(Widget child) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 20.sp),
        child: child,
      ),
    );
  }

  /// ---------------------------------------------
  /// AUTO SHIP UI
  /// ---------------------------------------------
  Widget _buildAutoShipDetails(AutoShipComing autoShip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNotificationTitle(
            autoShip.title, autoShip.notificationDate, autoShip.message ?? ""),
        _buildOrderInfo(autoShip.orderId.toString()),
        _buildShippingInfo(autoShip.shippingAddress),
        _buildProductList(autoShip.productList),
        _buildPriceDetails(autoShip.orderSubTotal, autoShip.shippingFee ?? 0,
            autoShip.orderTotal ?? 0),
      ],
    );
  }

  /// ---------------------------------------------
  /// MESSAGE DETAILS UI
  /// ---------------------------------------------
  Widget _buildMessageDetails(MessageDetails messageDetails) {
    return Column(
      children: [
        _buildNotificationTitle(
          messageDetails.title,
          messageDetails.notificationDate,
          messageDetails.message ?? "",
        ),
        Container(
          color: primaryWhite,
          padding: EdgeInsets.all(14.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((messageDetails.message ?? '').isNotEmpty)
                Text(
                  messageDetails.message!,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: textGreyColor),
                ),
              ...[
                messageDetails.message1,
                messageDetails.message2,
                messageDetails.message3,
                messageDetails.message4,
                messageDetails.message5
              ].where((m) => m != null && m!.isNotEmpty).map((msg) => Padding(
                    padding: EdgeInsets.only(bottom: 16.sp),
                    child: Text(
                      msg!,
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: lightBlackColor),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  /// ---------------------------------------------
  /// REUSABLE UI BLOCKS BELOW
  /// ---------------------------------------------

  Widget _buildNotificationTitle(
      String? title, DateTime? date, String? message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Container(
        width: Get.width,
        color: primaryWhite,
        padding: EdgeInsets.all(14.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Notification',
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack),
            ),
            height08,
            Text(
              date != null
                  ? CommonMethod.formatTimeIsoDateString(date.toIso8601String())
                  : "",
              style:
                  AppTextStyle.normalRegular12.copyWith(color: textGreyColor),
            ),
            height08,
            if (message != null && message.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: primaryColor.withOpacity(.15),
                    border: Border.all(color: primaryColor)),
                child: Text(
                  message,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: primaryBlack),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(String orderId) {
    if (orderId == "0") return SizedBox();
    return Container(
      margin: EdgeInsets.only(bottom: 20.sp),
      color: primaryWhite,
      padding: EdgeInsets.all(10.sp),
      child: Row(
        children: [
          SvgPicture.asset(AppAsset.orderDetails,
              color: greenColor, height: 18.sp),
          width16,
          Text('Order Details for Order No. ',
              style: AppTextStyle.normalRegular14),
          Text(orderId,
              style: AppTextStyle.normalRegular14.copyWith(color: greenColor)),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(ShippingAddress? address) {
    if (address == null) return SizedBox();

    return Container(
      color: primaryWhite,
      padding: EdgeInsets.all(12.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppAsset.location,
              color: primaryBlack, height: 18.sp),
          width08,
          Expanded(
            child: Text(
              '${address.address1}, ${address.city}, ${address.stateName}, ${address.countryName} - ${address.zip}',
              style: AppTextStyle.normalRegular14.copyWith(color: primaryBlack),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductList(List<ProductList>? products) {
    if (products == null || products.isEmpty) return SizedBox();

    return Container(
      color: primaryWhite,
      padding: EdgeInsets.all(14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Product(s)",
              style: AppTextStyle.normalRegular14
                  .copyWith(color: lightBlackColor)),
          height08,
          ...products.map((p) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.productName ?? "-",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                    ),
                    Text("\$${p.price.toStringAsFixed(2)}",
                        style: AppTextStyle.normalSemiBold14
                            .copyWith(color: primaryBlack)),
                  ],
                ),
                height05,
                Text("Quantity: ${p.quantity}",
                    style: AppTextStyle.normalRegular12
                        .copyWith(color: textGreyColor)),
                height15,
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildPriceDetails(double subTotal, double shipping, double total) {
    return Container(
      color: primaryWhite,
      padding: EdgeInsets.all(14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow("Sub-Total", subTotal),
          _buildPriceRow("Shipping", shipping),
          _buildPriceRow("Total", total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: AppTextStyle.normalRegular12
                      .copyWith(color: textGreyColor))),
          Text("\$${value.toStringAsFixed(2)}",
              style: isTotal
                  ? AppTextStyle.normalSemiBold20.copyWith(color: orangeColor)
                  : AppTextStyle.normalRegular14
                      .copyWith(color: lightBlackColor)),
        ],
      ),
    );
  }
}
