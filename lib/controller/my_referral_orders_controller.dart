import 'dart:convert';
import 'package:get/get.dart';
import '../model/my_referral_order_model.dart';
import '../service/network_repository.dart';

class MyReferralOrdersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<MyReferralOrdersData> ordersData = Rxn();

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyReferralOrders();
      final model = myReferralOrdersResponseFromJson(json.encode(response));
      if (model.status == true) {
        ordersData.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
