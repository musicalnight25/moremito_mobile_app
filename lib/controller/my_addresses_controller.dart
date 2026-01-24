import 'package:get/get.dart';

import '../model/my_address_model.dart';
import '../service/network_repository.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class MyAddressesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  RxList<MyAddressModel> addresses = <MyAddressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyAddresses();

      if (response != null && response['Status'] == true) {
        // assignAll is better for triggering Obx updates
        addresses.assignAll(
          List<MyAddressModel>.from(
            response['Data'].map((e) => MyAddressModel.fromJson(e)),
          ),
        );
      }
    } catch (e) {
      CommonMethod.getXSnackBar("Error", "Failed to load addresses", redColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(MyAddressModel address) async {
    // 1. Instant Local Update (Optimistic UI)
    if (address.isDefaultAddress == true) {
      for (var element in addresses) {
        element.isDefaultAddress = (element.id == address.id);
      }
      addresses.refresh(); // Crucial: This tells Obx to redraw the list
    }

    try {
      final response = await _repo.saveAddress(
        body: {
          "Id": address.id,
          "FirstName": address.firstName,
          "LastName": address.lastName,
          "Email": address.email,
          "PhoneNumber": address.phoneNumber,
          "Address1": address.address1,
          "Address2": address.address2 ?? "",
          "City": address.city,
          "ZipPostalCode": address.zipPostalCode,
          "CountryId": address.countryId,
          "StateId": address.stateId,
          "IsDefaultAddress": address.isDefaultAddress ?? false,
        },
      );

      if (response != null && response['Status'] == true) {
        CommonMethod.getXSnackBar(
            "Success", response['Message'] ?? "Updated", greenColor);
        // 2. Fetch from server to ensure data integrity
        fetchAddresses();
      } else {
        fetchAddresses(); // Revert on server failure
      }
    } catch (e) {
      fetchAddresses(); // Revert on error
      CommonMethod.getXSnackBar("Error", "Connection failed", redColor);
    }
  }
}
