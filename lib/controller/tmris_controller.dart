import 'dart:convert';
import 'package:get/get.dart';

import '../model/tmris_content_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class TmrisController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  RxBool isLoading = false.obs;
  RxList<String> contentList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTmrisContent();
  }

  Future<void> fetchTmrisContent() async {
    try {
      isLoading.value = true;

      final response = await _networkRepository.getTmrisContent();
      if (response != null) {
        final model =
            TmrisContentModel.fromJson(json.decode(json.encode(response)));

        if (model.status == true && model.data != null) {
          contentList.assignAll(model.data!.fields);
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "TMRS",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
