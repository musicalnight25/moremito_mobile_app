import 'dart:convert';

DeepLinkResponse deepLinkResponseFromJson(String str) =>
    DeepLinkResponse.fromJson(json.decode(str));

class DeepLinkResponse {
  bool? status;
  String? message;
  DeepLinkData? data;

  DeepLinkResponse({this.status, this.message, this.data});

  DeepLinkResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    data = json["Data"] == null ? null : DeepLinkData.fromJson(json["Data"]);
  }
}

class DeepLinkData {
  List<DeepLinkItem>? deepLinks;

  DeepLinkData({this.deepLinks});

  DeepLinkData.fromJson(Map<String, dynamic> json) {
    deepLinks = json["DeepLinks"] == null
        ? []
        : List<DeepLinkItem>.from(
            json["DeepLinks"].map((x) => DeepLinkItem.fromJson(x)));
  }
}

class DeepLinkItem {
  String? title;
  String? url;

  DeepLinkItem({this.title, this.url});

  DeepLinkItem.fromJson(Map<String, dynamic> json) {
    title = json["Title"];
    url = json["Url"];
  }
}
