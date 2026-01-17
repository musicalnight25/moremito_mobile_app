import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/compensation_spent_on_orders_model.dart';
import '../service/network_repository.dart';

class CommissionSpentController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  /// UI State
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  Rxn<CommissionSpentData> data = Rxn();

  /// Pagination
  int page = 1;

  bool get hasMore => data.value?.hasMore ?? false;

  /// Search
  final TextEditingController orderController = TextEditingController();
  int? _currentOrderNo;

  @override
  void onClose() {
    orderController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // FETCH (INITIAL / REFRESH)
  // ---------------------------------------------------------------------------
  Future<void> fetch({int? orderNo}) async {
    try {
      isLoading.value = true;
      page = 1; // Reset page
      _currentOrderNo = orderNo;

      final response = await _repo.getMyCommissionSpent(
        data: {
          "OrderNo": orderNo,
          "PageNumber": page,
        },
      );

      final model = commissionSpentResponseFromJson(json.encode(response));

      if (model.status == true) {
        data.value = model.data;
      } else {
        data.value = null;
      }
    } catch (e) {
      data.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD MORE (PAGINATION)
  // ---------------------------------------------------------------------------
  Future<void> loadMore() async {
    // 1. Guard clauses: Don't load if already loading or no more data
    if (isLoading.value || isPaginationLoading.value || !hasMore) return;

    try {
      isPaginationLoading.value = true;
      int nextPage = page + 1;

      final response = await _repo.getMyCommissionSpent(
        data: {
          "OrderNo": _currentOrderNo,
          "PageNumber": nextPage,
        },
      );

      final model = commissionSpentResponseFromJson(json.encode(response));

      if (model.status == true && model.data?.items != null) {
        // 2. Increment page only on success
        page = nextPage;

        // 3. Append new items to existing list
        final currentItems = data.value?.items ?? [];
        final newItems = model.data?.items ?? [];

        data.value = data.value?.copyWith(
          items: [...currentItems, ...newItems],
          hasMore: model.data?.hasMore,
          // Keep total amount from original or update if API sends it every time
          totalAmount: model.data?.totalAmount ?? data.value?.totalAmount,
        );
      }
    } catch (_) {
      // Handle error (optional: show snackbar)
    } finally {
      isPaginationLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH LOGIC
  // ---------------------------------------------------------------------------
  Future<void> searchByOrder() async {
    final text = orderController.text.trim();
    if (text.isEmpty) {
      refreshAll();
      return;
    }
    final orderNo = int.tryParse(text);
    if (orderNo == null) return;

    await fetch(orderNo: orderNo);
  }

  Future<void> refreshAll() async {
    orderController.clear();
    _currentOrderNo = null;
    await fetch();
  }
}
