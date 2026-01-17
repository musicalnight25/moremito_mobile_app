import 'dart:convert';

import 'package:get/get.dart';

import '../model/commission_payout_history_model.dart';
import '../service/network_repository.dart';

class CommissionPayoutHistoryController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<CommissionPayoutHistoryData> history = Rxn();

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyCommissionRequestHistory();
      final model = commissionPayoutHistoryResponseFromJson(
        json.encode(response),
      );
      if (model.status == true) {
        history.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
