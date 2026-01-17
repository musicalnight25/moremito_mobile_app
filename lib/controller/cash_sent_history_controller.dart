import 'dart:convert';

import 'package:get/get.dart';

import '../model/cash_sent_to_others_model.dart';
import '../service/network_repository.dart';

class CashSentHistoryController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<CashSentHistoryData> history = Rxn();

  Future<void> fetch() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyCashSentHistory();
      final model = cashSentHistoryResponseFromJson(json.encode(response));
      if (model.status == true) {
        history.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
