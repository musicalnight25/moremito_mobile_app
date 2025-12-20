import 'dart:convert';

MyLeadResponse myLeadResponseFromJson(String str) =>
    MyLeadResponse.fromJson(json.decode(str));

class MyLeadResponse {
  bool? status;
  String? message;
  LeadData? data;

  MyLeadResponse({this.status, this.message, this.data});

  factory MyLeadResponse.fromJson(Map<String, dynamic> json) {
    return MyLeadResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] == null ? null : LeadData.fromJson(json["Data"]),
    );
  }
}

class LeadData {
  List<LeadModel>? leads;
  int? totalRecords;
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  bool? isArchived;

  LeadData({
    this.leads,
    this.totalRecords,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.isArchived,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      leads: json["Leads"] == null
          ? []
          : List<LeadModel>.from(
              json["Leads"].map((x) => LeadModel.fromJson(x))),
      totalRecords: json["TotalRecords"],
      pageNumber: json["PageNumber"],
      pageSize: json["PageSize"],
      totalPages: json["TotalPages"],
      isArchived: json["IsArchived"],
    );
  }
}

class LeadModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? notes;
  bool? contactMe;
  DateTime? createdDate;
  bool? isContacted;
  DateTime? contactedDate;
  String? adminNotes;
  bool? isArchived;
  String? pageType;

  LeadModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.notes,
    this.contactMe,
    this.createdDate,
    this.isContacted,
    this.contactedDate,
    this.adminNotes,
    this.isArchived,
    this.pageType,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json["Id"],
      name: json["Name"],
      phone: json["Phone"],
      email: json["Email"],
      notes: json["Notes"],
      contactMe: json["ContactMe"],
      createdDate: json["CreatedDate"] == null
          ? null
          : DateTime.parse(json["CreatedDate"]),
      isContacted: json["IsContacted"],
      contactedDate: json["ContactedDate"] == null
          ? null
          : DateTime.parse(json["ContactedDate"]),
      adminNotes: json["AdminNotes"],
      isArchived: json["IsArchived"],
      pageType: json["PageType"],
    );
  }
}
