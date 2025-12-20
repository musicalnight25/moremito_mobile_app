import 'dart:convert';
import 'package:get/get.dart';

import '../model/my_address_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class MyAddressesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxList<MyAddressModel> addressList = <MyAddressModel>[].obs;
  RxBool isLoading = false.obs;

  Rxn<MyAddressModel> defaultAddress = Rxn<MyAddressModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;

      final response = await _repo.getMyAddresses();
      if (response != null) {
        final list = myAddressListFromJson(json.encode(response));
        addressList.assignAll(list);

        /// bind default address
        defaultAddress.value =
            list.firstWhereOrNull((e) => e.isDefaultAddress == true);
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyAddresses",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(MyAddressModel address) async {
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
          "IsDefaultAddress": true,
        },
      );

      if (response != null && response["Status"] == true) {
        await fetchAddresses();
        Get.snackbar("Success", "Default address updated");
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyAddresses",
        actionType: "SetDefault",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }
}
