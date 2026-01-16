import 'dart:convert';

import 'package:get/get.dart';

import '../model/my_compensation_history_model.dart';
import '../service/network_repository.dart';

class MyCompensationController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;

  Rxn<MyCompensationHistoryData> history = Rxn();
  RxList<MonthItem> months = <MonthItem>[].obs;
  RxList<CommissionDetail> commissions = <CommissionDetail>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyCompensationHistory();

      if (response != null) {
        final model =
            myCompensationHistoryResponseFromJson(json.encode(response));
        if (model.status == true) {
          history.value = model.data;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchYear(int year) async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyCompensationHistoryByYear(year: year);

      final model = YearDetailsResponse.fromJson(response);
      if (model.status == true) {
        months.value = model.data?.monthItems ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMonth(int year, int month) async {
    try {
      isLoading.value = true;
      final response =
          await _repo.getMyCompensationHistoryByMonth(year: year, month: month);

      final model = MonthDetailsResponse.fromJson(response);
      if (model.status == true) {
        commissions.value = model.data?.commissionDetails ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }
}
