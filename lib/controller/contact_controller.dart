import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

class ContactController extends GetxController {
  final contacts = <Contact>[].obs;
  final filteredContacts = <Contact>[].obs;

  final selectedContact = ''.obs;
  final selectedContactNumber = ''.obs;
  final selectedContactEmail = ''.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  late Box contactsBox;

  // Manual Setup triggered from Screen
  void setupSearchListener() {
    // This ensures search works without putting it in onInit
    debounce(
      searchQuery,
      (query) => _filterContacts(query.toString()),
      time: const Duration(milliseconds: 300),
    );
  }

  // ---------------- LOAD CONTACTS ----------------
  Future<void> loadContacts() async {
    isLoading.value = true;
    contactsBox = Hive.box('contactsBox');

    final storedContacts = contactsBox.get('contacts');

    if (storedContacts != null) {
      final List decoded = jsonDecode(storedContacts);
      contacts.value = decoded.map<Contact>((e) {
        List<Email> emails = [];
        if (e['email'] != null && e['email'].toString().isNotEmpty) {
          emails.add(Email(e['email']));
        }
        return Contact(
          displayName: e['name'],
          phones: [Phone(e['phone'])],
          emails: emails,
        );
      }).toList();

      filteredContacts.assignAll(contacts);
      // Small delay so shimmer is actually visible to user
      await Future.delayed(const Duration(milliseconds: 600));
      isLoading.value = false;
    } else {
      await fetchContacts();
    }
  }

  // ---------------- FETCH CONTACTS ----------------
  Future<void> fetchContacts() async {
    isLoading.value = true;

    final permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) {
      CommonMethod.getXSnackBar("Permission Required".tr, "Please allow contacts permission".tr,
        redColor,
      );
      isLoading.value = false;
      return;
    }

    final fetched = await FlutterContacts.getContacts(withProperties: true);
    final validContacts = _removeInvalidContacts(fetched);

    contacts.assignAll(validContacts);
    filteredContacts.assignAll(validContacts);

    // Save to Hive
    final contactList = validContacts.map((c) {
      return {
        "name": c.displayName,
        "phone": c.phones.first.number,
        "email": c.emails.isNotEmpty ? c.emails.first.address : "",
      };
    }).toList();

    await contactsBox.put('contacts', jsonEncode(contactList));
    isLoading.value = false;
  }

  void _filterContacts(String query) {
    if (query.isEmpty) {
      filteredContacts.assignAll(contacts);
      return;
    }
    filteredContacts.assignAll(
      contacts.where(
        (c) => c.displayName.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  List<Contact> _removeInvalidContacts(List<Contact> list) {
    final seen = <String>{};
    return list.where((c) {
      if (c.phones.isEmpty) return false;
      final phone = c.phones.first.number.replaceAll(RegExp(r'\s+'), '');
      if (phone.isEmpty || seen.contains(phone)) return false;
      seen.add(phone);
      return true;
    }).toList();
  }

  void selectContact(Contact contact) {
    selectedContact.value = "${contact.displayName}";
    selectedContactNumber.value = "${contact.phones.first.number}";
    selectedContactEmail.value =
        contact.emails.isNotEmpty ? contact.emails.first.address : "";
    Get.back(result: contact);
  }
}
