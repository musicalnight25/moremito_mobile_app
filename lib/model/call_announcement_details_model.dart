class CallAnnouncementDetailsModel {
  String? htmlPart;
  String? subjectPart;
  String? templateName;

  CallAnnouncementDetailsModel({
    this.htmlPart,
    this.subjectPart,
    this.templateName,
  });

  factory CallAnnouncementDetailsModel.fromJson(Map<String, dynamic> json) {
    return CallAnnouncementDetailsModel(
      htmlPart: json["HtmlPart"],
      subjectPart: json["SubjectPart"],
      templateName: json["TemplateName"],
    );
  }
}
