import 'package:get/get.dart';

import '../model/country_model.dart';
import '../model/my_address_model.dart';
import '../model/state_model.dart';
import '../service/network_repository.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class MyAddressesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;

  RxList<MyAddressModel> addresses = <MyAddressModel>[].obs;
  RxList<CountryModel> countries = <CountryModel>[].obs;
  RxList<StateModel> states = <StateModel>[].obs;

  /// Selected values (nullable)
  RxnInt selectedCountryId = RxnInt();
  RxnInt selectedStateId = RxnInt();

  RxBool isLoadingCountries = false.obs;
  RxBool isLoadingStates = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
    fetchCountries();
  }

  // ---------------- Countries ----------------
  Future<void> fetchCountries() async {
    try {
      isLoadingCountries.value = true;

      final response = await _repo.getCountries();

      if (response != null && response['Status'] == true) {
        countries.assignAll(
          List<CountryModel>.from(
            response['Data'].map((e) => CountryModel.fromJson(e)),
          ),
        );
      }
    } catch (e) {
      CommonMethod.getXSnackBar("Error", "Failed to load countries", redColor);
    } finally {
      isLoadingCountries.value = false;
    }
  }

  // ---------------- States ----------------
  Future<void> fetchStates(int countryId) async {
    try {
      isLoadingStates.value = true;

      states.clear();
      selectedStateId.value = null;

      final response = await _repo.getStates(countryId);

      if (response != null && response['Status'] == true) {
        states.assignAll(
          List<StateModel>.from(
            response['Data'].map((e) => StateModel.fromJson(e)),
          ),
        );
      }
    } catch (e) {
      CommonMethod.getXSnackBar("Error", "Failed to load states", redColor);
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ---------------- Addresses ----------------
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;

      final response = await _repo.getMyAddresses();

      if (response != null && response['Status'] == true) {
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

  // ---------------- Save Address ----------------
  Future<void> saveAddress(MyAddressModel address) async {
    // Optimistic UI update for default address
    if (address.isDefaultAddress == true) {
      for (var element in addresses) {
        element.isDefaultAddress = (element.id == address.id);
      }
      addresses.refresh();
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

        fetchAddresses(); // sync with server
      } else {
        fetchAddresses(); // revert
      }
    } catch (e) {
      fetchAddresses();
      CommonMethod.getXSnackBar("Error", "Connection failed", redColor);
    }
  }
}
