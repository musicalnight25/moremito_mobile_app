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

      if (response == null) return;

      if (response['Status'] == true) {
        var fetchedCountries = List<CountryModel>.from(
          response['Data'].map((e) => CountryModel.fromJson(e)),
        );
        countries.assignAll(fetchedCountries);
      } else {
        _handleError(response);
      }
    } catch (e) {
      _handleError(e);
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
      if (response == null) return;

      if (response['Status'] == true) {
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
        _handleError(response);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ---------------- Addresses ----------------
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final response = await _repo.getMyAddresses();
      if (response == null) return;

      if (response['Status'] == true) {
        addresses.assignAll(
          List<MyAddressModel>.from(
            response['Data'].map((e) => MyAddressModel.fromJson(e)),
          ),
        );
      } else {
        _handleError(response);
      }
    } catch (e) {
      _handleError(e);
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

      if (response == null) {
        fetchAddresses();
        return;
      }

      if (response['Status'] == true) {
        CommonMethod.getXSnackBar(
            "Success", response['Message'] ?? "Saved successfully", greenColor);
        await fetchAddresses();
      } else {
        _handleError(response);
        fetchAddresses();
      }
    } catch (e) {
      _handleError(e);
      fetchAddresses();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method for consistent error reporting
  void _handleError(dynamic error) {
    if (error == null) return;

    String message = "";
    if (error is String) {
      message = error;
    } else if (error is Map<String, dynamic>) {
      message = _extractErrorMessage(error);
    } else {
      message = error.toString();
    }

    CommonMethod.getXSnackBar("Notice", message, redColor);
  }

  String _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body.containsKey('Message')) return body['Message'];
      if (body.containsKey('message')) return body['message'];
      if (body.containsKey('errors') &&
          body['errors'] is Map<String, dynamic>) {
        return (body['errors'] as Map<String, dynamic>)
            .entries
            .map((e) => '${e.key}: ${e.value.join(", ")}')
            .join("\n");
      }
    }
    // Return the raw body if no specific error message format is found
    try {
      return body.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
