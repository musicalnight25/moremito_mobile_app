import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/deep_links_model.dart';
import 'package:more_mitro_app/service/network_repository.dart';

class DeepLinkController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool loading = false.obs;
  RxList<DeepLinkItem> deepLinks = <DeepLinkItem>[].obs;

  Future<void> fetchDeepLinks() async {
    loading.value = true;

    try {
      var res = await _repo.getDeepLinks(null);

      if (res != null) {
        final model = deepLinkResponseFromJson(json.encode(res));
        if (model.status == true) {
          deepLinks.value = model.data?.deepLinks ?? [];
        }
      }
    } catch (e) {
      debugPrint("ERROR in fetchDeepLinks: $e");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    fetchDeepLinks();
    super.onInit();
  }
}
