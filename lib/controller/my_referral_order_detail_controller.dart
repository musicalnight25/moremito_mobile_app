import 'dart:convert';
import 'package:get/get.dart';
import '../service/network_repository.dart';
import '../model/my_referral_order_detail_model.dart';

class MyReferralOrderDetailController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<MyReferralOrderDetailData> orderDetail = Rxn();

  Future<void> fetchOrderDetail({
    required int orderId,
    required int ownerId,
  }) async {
    try {
      isLoading.value = true;

      final response = await _repo.getMyReferralOrderDetail(
        orderId: orderId,
        orderOwnerId: ownerId,
      );

      final model = myReferralOrderDetailResponseFromJson(
        json.encode(response),
      );

      if (model.status == true) {
        orderDetail.value = model.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
