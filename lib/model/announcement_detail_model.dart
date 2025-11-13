class AnnouncementDetailModel {
  String? htmlPart;
  String? title;

  AnnouncementDetailModel({this.htmlPart, this.title});

  factory AnnouncementDetailModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetailModel(
      htmlPart:  json["HtmlPart"] ?? json["Body"] ,
      title: json["AnnouncementName"] ?? json["Title"] ?? "",
    );
  }
}
