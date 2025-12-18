import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';

import '../../controller/contact_controller.dart';
import '../../utils/base_background_widget.dart';

class ContactScreen extends StatelessWidget {
  final ContactController controller = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Select Contact',
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormFieldWidget(
                hintText: 'Search Contacts',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                onChanged: (value) =>
                    controller.searchQuery.value = value ?? '',
                controller: null,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredContacts.isEmpty) {
                  return const Center(child: Text("No Contacts Found"));
                }

                return ListView.builder(
                  itemCount: controller.filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = controller.filteredContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          contact.displayName[0],
                          style: AppTextStyle.normalBold14
                              .copyWith(color: primaryWhite),
                        ),
                      ),
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.first.number),
                      onTap: () => controller.selectContact(contact),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.refreshContacts,
        backgroundColor: primaryColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
