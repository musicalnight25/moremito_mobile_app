import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:more_mitro_app/service/network_repository.dart';

// ==================== MODEL IMPORTS ====================
import 'package:more_mitro_app/model/order_response_model.dart';
import 'package:more_mitro_app/model/order_detail_response_model.dart';

import '../utils/colors.dart';
import '../utils/common_method.dart';

class OrdersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // ==================== ORDER LIST ====================
  RxBool listLoading = false.obs;
  RxList<Order> orderList = <Order>[].obs;

  // ==================== ORDER DETAIL ====================
  RxBool detailLoading = false.obs;
  Rxn<OrderDetailData> orderDetail = Rxn<OrderDetailData>();

  // ==================== PAGINATION ====================
  int page = 1;
  bool hasMore = true;

  // =============================================================================
  //                               GET ORDER LIST
  // =============================================================================
  Future<void> getOrderList() async {
    if (!hasMore) return;

    listLoading.value = true;

    try {
      // FIXED CALL HERE
      var response = await _repo.getOrders(null, page);

      debugPrint("RAW ORDER RESPONSE: $response");

      if (response != null) {
        final model = orderResponseModelFromJson(json.encode(response));

        debugPrint("Parsed Orders Count: ${model.data?.orders?.length}");

        if (model.status == true && model.data != null) {
          if (page == 1) orderList.clear();

          orderList.addAll(model.data!.orders ?? []);
          hasMore = model.data!.hasMore ?? false;

          orderList.refresh();
          if (hasMore) page++;
        }
      }
    } catch (e, stack) {
      debugPrint("❌ Error in getOrderList: $e=====$stack");
    } finally {
      listLoading.value = false;
    }
  }

  // =============================================================================
  //                              GET ORDER DETAIL
  // =============================================================================
  Future<void> getOrderDetail(int orderId) async {
    detailLoading.value = true;

    try {
      var response = await _repo.getOrderDetail(null, orderId);

      if (response != null) {
        final model = orderDetailResponseModelFromJson(json.encode(response));

        if (model.status == true) {
          orderDetail.value = model.data;
        } else {
          CommonMethod.getXSnackBar(
              "Error",
              model.message?.toString() ?? "Unable to fetch details",
              primaryColor);
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getOrderDetail: $e");
    } finally {
      detailLoading.value = false;
    }
  }
}
