import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs; // All contacts
  var filteredContacts = <Contact>[].obs; // Filtered contacts for search
  var selectedContact = ''.obs;
  var isLoading = true.obs; // Loading state
  var searchQuery = ''.obs;
  final contactsBox = Hive.box('contactsBox');

  searchContact() {
    debounce(searchQuery, (query) => filterContacts(query),
        time: Duration(milliseconds: 300)); // Smooth search with debounce
  }

  // Load contacts from local storage or fetch if empty
  void loadContacts() {
    var storedContacts = contactsBox.get('contacts');
    if (storedContacts != null) {
      List decodedContacts = jsonDecode(storedContacts);
      contacts.value = decodedContacts
          .map((contact) => Contact(
                displayName: contact['name'],
                phones: [Phone(contact['phone'])],
              ))
          .toList();
      filteredContacts.value = contacts;
      isLoading.value = false;
    } else {
      fetchContacts();
    }
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;

    if (!await FlutterContacts.requestPermission()) {
      CommonMethod.getXSnackBar(
          "Permission Denied", "Enable contact access in settings.", redColor);
      isLoading.value = false;
      return;
    }

    List<Contact> fetchedContacts =
        await FlutterContacts.getContacts(withProperties: true);

    List<Contact> validContacts = _filterValidContacts(fetchedContacts);

    // Convert the list properly before encoding
    List<Map<String, String>> contactList = validContacts.map((contact) {
      return {
        'name': contact.displayName,
        'phone': contact.phones.isNotEmpty ? contact.phones.first.number : "",
      };
    }).toList();

    contactsBox.put(
        'contacts', jsonEncode(contactList)); // Now properly formatted

    contacts.value = validContacts;
    filteredContacts.value = contacts;
    isLoading.value = false;
  }

  // Filter contacts to remove duplicates and empty numbers
  List<Contact> _filterValidContacts(List<Contact> allContacts) {
    Set<String> seenNumbers = {};
    return allContacts.where((contact) {
      if (contact.phones.isEmpty) return false;
      String phone = contact.phones.first.number;
      if (seenNumbers.contains(phone)) return false;
      seenNumbers.add(phone);
      return true;
    }).toList();
  }

  // Refresh contacts manually
  Future<void> refreshContacts() async {
    await fetchContacts();
  }

  // Select a contact
  void selectContact(Contact contact) {
    List<String> details = [];

    if (contact.displayName?.isNotEmpty ?? false) {
      details.add(contact.displayName!);
    }

    if (contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty) {
      details.add(contact.phones.first.number);
    }

    if (contact.emails.isNotEmpty && contact.emails.first.address.isNotEmpty) {
      details.add(contact.emails.first.address);
    }

    selectedContact.value = details.join(", ");
    Get.back();
  }

  // Search contacts
  void filterContacts(String query) {
    if (query.isEmpty) {
      filteredContacts.value = contacts;
    } else {
      filteredContacts.value = contacts
          .where((contact) =>
              contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
