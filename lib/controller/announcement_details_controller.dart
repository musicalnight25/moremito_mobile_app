import 'package:get/get.dart';
import 'package:more_mitro_app/model/announcement_detail_model.dart';
import 'package:more_mitro_app/service/network_repository.dart';

class AnnouncementDetailsController extends GetxController {
  final _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<AnnouncementDetailModel> details =
  Rxn<AnnouncementDetailModel>();

  Future<void> fetchAnnouncementDetails(int id) async {
    try {
      isLoading.value = true;

      final response = await _repo.getAnnouncementDetails(
        annId: id.toString(),
      );

      if (response != null && response["Data"] != null) {
        details.value =
            AnnouncementDetailModel.fromJson(response["Data"]);
      }
    } catch (e) {
      print("Error fetching announcement details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
