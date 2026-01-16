import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/daily_compensation_model.dart';
import '../service/network_repository.dart';

enum CompensationSortBy {
  dateAsc(1),
  dateDesc(3);

  final int value;

  const CompensationSortBy(this.value);
}

class MyDailyCompensationController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // STATE VARIABLES
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int page = 1;

  // FLAGS
  bool isSearchingByOrder = false;

  // CONTROLLERS
  final TextEditingController orderNoCtrl = TextEditingController();
  final Rx<CompensationSortBy> sortBy = CompensationSortBy.dateDesc.obs;

  // DATA LISTS
  RxList<DailyCompensationItem> dailyItems = <DailyCompensationItem>[].obs;
  RxList<OrderCompensationItem> orderItems = <OrderCompensationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ FIX: Load data immediately on initialization, not in build()
    fetchDailyLogs();
  }

  // ------------------------------------------------
  // 1. FETCH DAILY LOGS (PAGINATED)
  // ------------------------------------------------
  Future<void> fetchDailyLogs({bool loadMore = false}) async {
    // If loading more but no more data exists, stop.
    if (loadMore && !hasMore.value) return;
    // If already loading, stop to prevent duplicate calls.
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (loadMore) {
        page++;
      } else {
        // Reset for fresh load
        page = 1;
        hasMore.value = true;
        isSearchingByOrder = false;
        // Don't clear list immediately if loading more to prevent flicker
        if (!loadMore) dailyItems.clear();
      }

      final response = await _repo.getMyDailyCompensations(
        data: {
          "SearchType": 0,
          "PageNumber": page,
          "SortBy": sortBy.value.value,
        },
      );

      final model = DailyCompensationResponse.fromJson(response);

      if (model.status == true) {
        if (loadMore) {
          dailyItems.addAll(model.data?.items ?? []);
        } else {
          dailyItems.assignAll(model.data?.items ?? []);
        }

        // Update pagination flag
        hasMore.value = model.data?.hasMore ?? false;
      } else {
        // If API fails or returns false status
        hasMore.value = false;
      }
    } catch (e) {
      debugPrint("Error fetching logs: $e");
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------
  // 2. SEARCH BY ORDER NUMBER
  // ------------------------------------------------
  Future<void> searchByOrderNo() async {
    final orderNo = int.tryParse(orderNoCtrl.text.trim());

    // If empty, just clear search and reload normal list
    if (orderNoCtrl.text.isEmpty) {
      clearSearch();
      return;
    }

    if (orderNo == null) {
      Get.snackbar("Invalid Input", "Please enter a valid order number");
      return;
    }

    try {
      isLoading.value = true;
      isSearchingByOrder = true;
      hasMore.value =
          false; // Search usually returns specific results, no pagination
      dailyItems.clear(); // Clear current list for search results

      final response = await _repo.getMyDailyCompensations(
        data: {
          "SearchType": 1,
          "OrderNo": orderNo,
          "PageNumber": 1,
          "SortBy": sortBy.value.value,
        },
      );

      final model = DailyCompensationResponse.fromJson(response);
      if (model.status == true) {
        dailyItems.assignAll(model.data?.items ?? []);
      }
    } catch (e) {
      debugPrint("Error searching: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------
  // 3. FETCH ORDER DETAILS (FOR NEXT SCREEN)
  // ------------------------------------------------
  Future<void> fetchOrdersByDate(DateTime date) async {
    try {
      isLoading.value = true;
      orderItems.clear();

      final response = await _repo.getMyCompensationsByDateRange(
        data: {
          "SearchType": 2,
          "FromDate": date.toIso8601String(),
          "ToDate": date
              .add(const Duration(hours: 23, minutes: 59))
              .toIso8601String(),
          "PageNumber": 1,
          "SortBy": sortBy.value.value,
        },
      );

      final model = OrderCompensationResponse.fromJson(response);
      if (model.status == true) {
        orderItems.assignAll(model.data?.items ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------
  // 4. UTILS
  // ------------------------------------------------
  void clearSearch() {
    orderNoCtrl.clear();
    isSearchingByOrder = false;
    fetchDailyLogs(loadMore: false); // Reload original list
  }

  @override
  void onClose() {
    orderNoCtrl.dispose();
    super.onClose();
  }
}
