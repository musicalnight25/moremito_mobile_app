import 'dart:convert';

List<MyAddressModel> myAddressListFromJson(String str) =>
    List<MyAddressModel>.from(
      json.decode(str)["Data"].map((x) => MyAddressModel.fromJson(x)),
    );

class MyAddressModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address1;
  String? address2;
  String? city;
  String? zipPostalCode;
  String? stateName;
  String? countryName;
  int? countryId;
  int? stateId;
  bool? isDefaultAddress;

  MyAddressModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address1,
    this.address2,
    this.city,
    this.zipPostalCode,
    this.stateName,
    this.countryName,
    this.countryId,
    this.stateId,
    this.isDefaultAddress,
  });

  factory MyAddressModel.fromJson(Map<String, dynamic> json) {
    return MyAddressModel(
      id: json["Id"],
      firstName: json["FirstName"],
      lastName: json["LastName"],
      email: json["Email"],
      phoneNumber: json["PhoneNumber"],
      address1: json["Address1"],
      address2: json["Address2"],
      city: json["City"],
      zipPostalCode: json["ZipPostalCode"],
      stateName: json["StateName"],
      countryName: json["CountryName"],
      countryId: json["CountryId"],
      stateId: json["StateId"],
      isDefaultAddress: json["IsDefaultAddress"],
    );
  }
}
