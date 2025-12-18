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
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  late Box contactsBox;

  @override
  void onInit() {
    super.onInit();
    contactsBox = Hive.box('contactsBox');

    // 🔥 Register debounce ONCE
    debounce(
      searchQuery,
      (query) => _filterContacts(query.toString()),
      time: const Duration(milliseconds: 300),
    );

    loadContacts();
  }

  // ---------------- LOAD CONTACTS ----------------
  Future<void> loadContacts() async {
    final storedContacts = contactsBox.get('contacts');

    if (storedContacts != null) {
      final List decoded = jsonDecode(storedContacts);
      contacts.value = decoded.map<Contact>((e) {
        return Contact(
          displayName: e['name'],
          phones: [Phone(e['phone'])],
        );
      }).toList();

      filteredContacts.assignAll(contacts);
    } else {
      await fetchContacts();
    }
  }

  // ---------------- FETCH CONTACTS ----------------
  Future<void> fetchContacts() async {
    isLoading.value = true;

    final permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) {
      CommonMethod.getXSnackBar(
        "Permission Required",
        "Please allow contacts permission",
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
      };
    }).toList();

    await contactsBox.put('contacts', jsonEncode(contactList));

    isLoading.value = false;
  }

  // ---------------- FILTER CONTACTS ----------------
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

  // ---------------- REMOVE DUPLICATES ----------------
  List<Contact> _removeInvalidContacts(List<Contact> list) {
    final seen = <String>{};

    return list.where((c) {
      if (c.phones.isEmpty) return false;

      final phone = c.phones.first.number;
      if (phone.isEmpty || seen.contains(phone)) return false;

      seen.add(phone);
      return true;
    }).toList();
  }

  // ---------------- SELECT CONTACT ----------------
  void selectContact(Contact contact) {
    selectedContact.value =
        "${contact.displayName}, ${contact.phones.first.number}";
    Get.back();
  }

  // ---------------- REFRESH ----------------
  Future<void> refreshContacts() async {
    await fetchContacts();
  }
}
