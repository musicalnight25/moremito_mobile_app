import 'package:get/get.dart';
import 'package:more_mitro_app/model/call_announcement_details_model.dart';
import 'package:more_mitro_app/service/network_repository.dart';

class CallDetailsController extends GetxController {
  final _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<CallAnnouncementDetailsModel> details = Rxn<CallAnnouncementDetailsModel>();

  Future<void> fetchCallDetails(int id, String template) async {
    try {
      isLoading.value = true;

      var response = await _repo.getCallDetails(id: id.toString(),templateName: template);

      if (response != null && response["Data"] != null) {
        details.value = CallAnnouncementDetailsModel.fromJson(response["Data"]);
      }
    } catch (e) {
      print("Error fetching call details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
