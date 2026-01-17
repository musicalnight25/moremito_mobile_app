import 'dart:convert';

import 'package:get/get.dart';

import '../model/cash_transfer_history_model.dart';
import '../service/network_repository.dart';

class CashTransferHistoryController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<CashTransferHistoryData> history = Rxn();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyCashTransferHistory();
      final model = cashTransferHistoryResponseFromJson(json.encode(response));
      if (model.status == true) {
        history.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
