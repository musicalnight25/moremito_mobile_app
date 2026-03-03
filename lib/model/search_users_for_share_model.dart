import 'dart:convert';

SearchUsersForShareResponse searchUsersForShareFromJson(String str) =>
    SearchUsersForShareResponse.fromJson(json.decode(str));

class SearchUsersForShareResponse {
  bool? status;
  String? message;
  List<ShareUserItem>? data;

  SearchUsersForShareResponse({this.status, this.message, this.data});

  factory SearchUsersForShareResponse.fromJson(Map<String, dynamic> json) =>
      SearchUsersForShareResponse(
        status: json['Status'],
        message: json['Message'],
        data: json['Data'] == null
            ? []
            : List<ShareUserItem>.from(
                json['Data'].map((x) => ShareUserItem.fromJson(x))),
      );
}

class ShareUserItem {
  int? userId;
  String? username;
  String? name;
  String? email;

  ShareUserItem({this.userId, this.username, this.name, this.email});

  factory ShareUserItem.fromJson(Map<String, dynamic> json) => ShareUserItem(
        userId: json['UserId'],
        username: json['Username'],
        name: json['Name'],
        email: json['Email'],
      );
}
