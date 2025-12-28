import 'dart:convert';
import 'package:get/get.dart';
import '../model/flyer_template_detail_model.dart';
import '../model/flyer_template_model.dart';
import '../model/preview_response_model.dart';
import '../service/network_repository.dart';

class FlyerTemplatesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = true.obs;

  RxList<FlyerTemplateModel> templates = <FlyerTemplateModel>[].obs;
  Rx<FlyerTemplateDetailModel?> flyerTemplateDetailModel =
      Rx<FlyerTemplateDetailModel?>(null);
  Rx<PreviewModel?> previewModel = Rx<PreviewModel?>(null);

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

      final parsed = FlyerTemplateDetailResponseModel.fromJson(response);

      flyerTemplateDetailModel.value = parsed.data;
      flyerTemplateDetailModel.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFlyerPreview(int templateId) async {
    try {
      isLoading.value = true;

      final response = await _repo
          .getFlyerPreview(queryParameters: {'templateId': templateId});

      final parsed = PreviewResponseModel.fromJson(response);

      previewModel.value = parsed.data;
      previewModel.refresh();
    } finally {
      isLoading.value = false;
    }
  }
}
