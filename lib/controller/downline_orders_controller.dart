import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/downline_orders_model.dart';
import '../service/network_repository.dart';

class DownlineOrdersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;

  RxList<DownlineOrder> orderList = <DownlineOrder>[].obs;

  int pageNumber = 1;
  final int pageSize = 25;
  bool hasMore = true;

  // Filters
  TextEditingController usernameController = TextEditingController();
  TextEditingController orderIdController = TextEditingController();

  RxString fromDate = "".obs;
  RxString toDate = "".obs;

  Future<void> fetchDownlineOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      pageNumber = 1;
      hasMore = true;
      orderList.clear();
    }

    if (!hasMore) return;

    try {
      pageNumber == 1 ? isLoading.value = true : isLoadMore.value = true;

      final body = {
        "OrderId": orderIdController.text.isEmpty
            ? null
            : int.tryParse(orderIdController.text),
        "OrderUsername":
            usernameController.text.isEmpty ? null : usernameController.text,
        "FromDate": fromDate.value.isEmpty ? null : fromDate.value,
        "ToDate": toDate.value.isEmpty ? null : toDate.value,
        "PageNumber": pageNumber,
        "PageSize": pageSize,
      };

      final response = await _repo.getDownlineOrders(data: body);
      final model = downlineOrdersResponseFromJson(json.encode(response));

      if (model.status == true) {
        hasMore = model.data.hasMore;
        orderList.addAll(model.data.orders);
        pageNumber++;
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void resetFilters() {
    usernameController.clear();
    orderIdController.clear();
    fromDate.value = "";
    toDate.value = "";
    fetchDownlineOrders(isRefresh: true);
  }

  @override
  void onClose() {
    usernameController.dispose();
    orderIdController.dispose();
    super.onClose();
  }
}
