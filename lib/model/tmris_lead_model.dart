import 'dart:convert';

TmrisLeadResponse tmrisLeadResponseFromJson(String str) =>
    TmrisLeadResponse.fromJson(json.decode(str));

class TmrisLeadResponse {
  bool? status;
  String? message;
  TmrisLeadData? data;

  TmrisLeadResponse({this.status, this.message, this.data});

  factory TmrisLeadResponse.fromJson(Map<String, dynamic> json) {
    return TmrisLeadResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] == null ? null : TmrisLeadData.fromJson(json["Data"]),
    );
  }
}

class TmrisLeadData {
  List<TmrisLeadModel>? leads;
  int? totalRecords;
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  bool? isArchived;

  TmrisLeadData({
    this.leads,
    this.totalRecords,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.isArchived,
  });

  factory TmrisLeadData.fromJson(Map<String, dynamic> json) {
    return TmrisLeadData(
      leads: json["Leads"] == null
          ? []
          : List<TmrisLeadModel>.from(
              json["Leads"].map((x) => TmrisLeadModel.fromJson(x))),
      totalRecords: json["TotalRecords"],
      pageNumber: json["PageNumber"],
      pageSize: json["PageSize"],
      totalPages: json["TotalPages"],
      isArchived: json["IsArchived"],
    );
  }
}

class TmrisLeadModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? notes;
  bool? contactMe;
  int? userId;
  String? userName;
  DateTime? createdDate;
  bool? isContacted;
  DateTime? contactedDate;
  String? adminNotes;
  bool? isArchived;
  String? pageType;

  TmrisLeadModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.notes,
    this.contactMe,
    this.userId,
    this.userName,
    this.createdDate,
    this.isContacted,
    this.contactedDate,
    this.adminNotes,
    this.isArchived,
    this.pageType,
  });

  factory TmrisLeadModel.fromJson(Map<String, dynamic> json) {
    return TmrisLeadModel(
      id: json["Id"],
      name: json["Name"],
      phone: json["Phone"],
      email: json["Email"],
      notes: json["Notes"],
      contactMe: json["ContactMe"],
      userId: json["UserId"],
      userName: json["UserName"],
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
