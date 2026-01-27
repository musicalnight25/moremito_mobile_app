import 'dart:convert';

import 'package:get/get.dart';

import '../model/downline_order_detail_model.dart';
import '../service/network_repository.dart';

class DownlineOrderDetailController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<DownlineOrderDetailData> orderData = Rxn();

  Future<void> fetchOrderDetail({
    required int orderId,
    required int userId,
  }) async {
    try {
      isLoading.value = true;

      final response = await _repo.getDownlineOrderDetails(
        orderId: orderId,
        userId: userId,
      );

      final model = downlineOrderDetailResponseFromJson(json.encode(response));

      if (model.status == true) {
        orderData.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
