// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'app_text_style.dart';
//
// class CustomDropdown extends StatelessWidget {
//   final List<dynamic>? items;
//   final List<DropdownMenuItem<dynamic>>? customItems;
//   final dynamic value;
//   final String hintText;
//   final String? labelText;
//   final ValueChanged<dynamic> onChanged;
//
//   const CustomDropdown({
//     this.items,
//     required this.value,
//     this.customItems,
//     this.labelText,
//     required this.hintText,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (labelText != null)
//           Padding(
//             padding: EdgeInsets.only(
//               top: Get.height * 0.022,
//               bottom: Get.height * 0.011,
//             ),
//             child: Text(
//               labelText ?? "",
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w500,
//                 fontSize: Get.height * 0.017,
//                 color: const Color(0xFF060E30),
//               ),
//             ),
//           ),
//         DropdownButtonHideUnderline(
//           child: DropdownButton2<dynamic>(
//             value: value != "" ? value : null,
//             items: customItems ??
//                 items!.map((dynamic item) {
//                   return DropdownMenuItem<dynamic>(
//                     value: item,
//                     child: Text(
//                       item.toString(),
//                       style: AppTextStyle.dropDownMenuStyle,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 }).toList(),
//             isExpanded: true,
//             hint: Text(
//               hintText,
//               style: AppTextStyle.dropDownMenuStyle,
//               overflow: TextOverflow.ellipsis,
//             ),
//             onChanged: (newValue) {
//               onChanged(newValue);
//             },
//             buttonStyleData: ButtonStyleData(
//               height: 50,
//               width: Get.width,
//               padding: const EdgeInsets.only(left: 14, right: 14),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: const Color(0xFFD1D5DB),
//                 ),
//                 color: Colors.white,
//               ),
//             ),
//             iconStyleData: const IconStyleData(
//               icon: Icon(
//                 Icons.keyboard_arrow_down_outlined,
//                 color: Color(0xFF060E30),
//               ),
//             ),
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               elevation: 1,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               scrollbarTheme: ScrollbarThemeData(
//                 radius: const Radius.circular(40),
//                 thickness: MaterialStateProperty.all<double>(6),
//                 thumbVisibility: MaterialStateProperty.all<bool>(true),
//               ),
//             ),
//             menuItemStyleData: const MenuItemStyleData(
//               height: 40,
//               padding: EdgeInsets.only(left: 14, right: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
