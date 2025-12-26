class FlyerTemplateDetailResponse {
  final FlyerTemplateDetail template;
  final UserFlyerInfo user;

  FlyerTemplateDetailResponse({
    required this.template,
    required this.user,
  });

  factory FlyerTemplateDetailResponse.fromJson(Map<String, dynamic> json) {
    return FlyerTemplateDetailResponse(
      template: FlyerTemplateDetail.fromJson(json['Data']['Template']),
      user: UserFlyerInfo.fromJson(json['Data']['UserFlyer']),
    );
  }
}

class FlyerTemplateDetail {
  int? id;
  int? templateId;
  String? templateName;
  dynamic templateCode;
  String? title;
  String? subtitle;
  dynamic videoUrl;
  dynamic scientistTitle;
  dynamic scientistIntro;
  bool? isActive;
  DateTime? createdOn;
  dynamic modifiedOn;
  List<dynamic>? sections;
  List<dynamic>? products;
  List<dynamic>? testimonials;
  dynamic userFlyerInfo;

  FlyerTemplateDetail({
    this.id,
    this.templateId,
    this.templateName,
    this.templateCode,
    this.title,
    this.subtitle,
    this.videoUrl,
    this.scientistTitle,
    this.scientistIntro,
    this.isActive,
    this.createdOn,
    this.modifiedOn,
    this.sections,
    this.products,
    this.testimonials,
    this.userFlyerInfo,
  });

  factory FlyerTemplateDetail.fromJson(Map<String, dynamic> json) {
    return FlyerTemplateDetail(
      id: json["Id"],
      templateId: json["TemplateId"],
      templateName: json["TemplateName"],
      templateCode: json["TemplateCode"],
      title: json["Title"],
      subtitle: json["Subtitle"],
      videoUrl: json["VideoUrl"],
      scientistTitle: json["ScientistTitle"],
      scientistIntro: json["ScientistIntro"],
      isActive: json["IsActive"],
      createdOn:
          json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
      modifiedOn: json["ModifiedOn"],
      sections: json["Sections"] == null
          ? []
          : List<dynamic>.from(json["Sections"]!.map((x) => x)),
      products: json["Products"] == null
          ? []
          : List<dynamic>.from(json["Products"]!.map((x) => x)),
      testimonials: json["Testimonials"] == null
          ? []
          : List<dynamic>.from(json["Testimonials"]!.map((x) => x)),
      userFlyerInfo: json["userFlyerInfo"],
    );
  }
}

class UserFlyerInfo {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? websiteLink;
  String? qrCodeUrl;
  String? qrCodeImagePath;
  dynamic productDescription;
  DateTime? createdOn;
  dynamic modifiedOn;
  bool? isDeleted;
  int? templateId;
  String? flyerGuid;
  dynamic userName;

  UserFlyerInfo({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.websiteLink,
    this.qrCodeUrl,
    this.qrCodeImagePath,
    this.productDescription,
    this.createdOn,
    this.modifiedOn,
    this.isDeleted,
    this.templateId,
    this.flyerGuid,
    this.userName,
  });

  factory UserFlyerInfo.fromJson(Map<String, dynamic> json) {
    return UserFlyerInfo(
      id: json["Id"],
      userId: json["UserId"],
      name: json["Name"],
      email: json["Email"],
      phone: json["Phone"],
      websiteLink: json["WebsiteLink"],
      qrCodeUrl: json["QRCodeUrl"],
      qrCodeImagePath: json["QRCodeImagePath"],
      productDescription: json["ProductDescription"],
      createdOn:
          json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
      modifiedOn: json["ModifiedOn"],
      isDeleted: json["IsDeleted"],
      templateId: json["TemplateId"],
      flyerGuid: json["FlyerGuid"],
      userName: json["UserName"],
    );
  }
}
