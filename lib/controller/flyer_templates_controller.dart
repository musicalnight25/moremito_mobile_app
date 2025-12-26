import 'dart:convert';
import 'package:get/get.dart';
import '../model/flyer_template_detail_model.dart';
import '../model/flyer_template_model.dart';
import '../service/network_repository.dart';

class FlyerTemplatesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = true.obs;

  RxList<FlyerTemplateModel> templates = <FlyerTemplateModel>[].obs;
  Rx<FlyerTemplateDetail?> template = Rx<FlyerTemplateDetail?>(null);
  Rx<UserFlyerInfo?> userInfo = Rx<UserFlyerInfo?>(null);

  Future<void> fetchTemplates() async {
    try {
      isLoading.value = true;
      final response = await _repo.getFlyerTemplates();
      final parsed = flyerTemplateResponseFromJson(json.encode(response));
      templates.assignAll(parsed.data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTemplateDetail(int templateId) async {
    try {
      isLoading.value = true;

      final response = await _repo
          .getFlyerTemplateDetail(queryParameters: {'templateId': templateId});

      final parsed = FlyerTemplateDetailResponse.fromJson(response);

      template.value = parsed.template;
      userInfo.value = parsed.user;
    } finally {
      isLoading.value = false;
    }
  }
}
