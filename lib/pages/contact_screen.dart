import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';

import '../controller/contact_controller.dart';
import '../utils/base_background_widget.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactController contactController = Get.put(ContactController());
  @override
  void initState() {
    contactController.selectedContact.value = '';
    contactController.searchQuery.value = '';
    contactController.loadContacts();
    contactController.searchContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Select a Contact',
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormFieldWidget(
                controller: null,
                hintText: 'Search Contacts',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                onChanged: (value) {
                  contactController.searchQuery.value = value ?? "";
                  contactController.searchContact();
                },
              ),
            ),

            // Contact List with Loader & Smooth UI
            Expanded(
              child: Obx(() {
                if (contactController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (contactController.filteredContacts.isEmpty) {
                  return Center(child: Text("No Contacts Found"));
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: contactController.filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = contactController.filteredContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          contact.displayName[0],
                          style: AppTextStyle.normalBold14
                              .copyWith(color: primaryWhite),
                        ),
                      ),
                      title: Text(contact.displayName,
                          style: AppTextStyle.normalBold14),
                      subtitle: Text(contact.phones.first.number,
                          style: AppTextStyle.normalRegular12),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: lightBlackColor,
                      ),
                      onTap: () => contactController.selectContact(contact),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => contactController.refreshContacts(),
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
