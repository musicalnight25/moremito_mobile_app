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
        var fetchedCountries = List<CountryModel>.from(
          response['Data'].map((e) => CountryModel.fromJson(e)),
        );
        countries.assignAll(fetchedCountries);
      } else {
        _handleError(response?['Message'] ?? "Failed to load countries");
      }
    } catch (e) {
      _handleError("An unexpected error occurred while fetching countries: $e");
    } finally {
      isLoadingCountries.value = false;
    }
  }

  // ---------------- States (With Auto-Select Logic) ----------------
  Future<void> fetchStates(int countryId, {int? prefillStateId}) async {
    try {
      isLoadingStates.value = true;
      states.clear();

      // If we aren't pre-filling (Edit Mode), clear current selection
      if (prefillStateId == null) {
        selectedStateId.value = null;
      }

      final response = await _repo.getStates(countryId);

      if (response != null && response['Status'] == true) {
        var fetchedStates = List<StateModel>.from(
          response['Data'].map((e) => StateModel.fromJson(e)),
        );
        states.assignAll(fetchedStates);

        // --- AUTO SELECT LOGIC ---
        if (prefillStateId != null) {
          // 1. If editing, use the existing state ID
          selectedStateId.value = prefillStateId;
        } else if (states.isNotEmpty) {
          // 2. If new address, auto-select the first state in the list
          selectedStateId.value = states.first.id;
        }
      } else {
        _handleError(
            response?['Message'] ?? "No states found for this country");
      }
    } catch (e) {
      _handleError("Connection error while loading states");
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
      _handleError("Could not refresh addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- Save Address ----------------
  Future<void> saveAddress(MyAddressModel address) async {
    if (address.isDefaultAddress == true) {
      for (var element in addresses) {
        element.isDefaultAddress = (element.id == address.id);
      }
      addresses.refresh();
    }

    try {
      isLoading.value = true;
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
            "Success", response['Message'] ?? "Saved successfully", greenColor);
        await fetchAddresses();
      } else {
        _handleError(response?['Message'] ?? "Failed to save address");
        fetchAddresses();
      }
    } catch (e) {
      _handleError("Network error: Please check your connection");
      fetchAddresses();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method for consistent error reporting
  void _handleError(String message) {
    CommonMethod.getXSnackBar("Notice", message, redColor);
  }
}
