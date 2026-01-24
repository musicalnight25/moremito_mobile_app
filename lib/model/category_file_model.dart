// To parse this JSON data, do
//
//     final categoryFileResponseModel = categoryFileResponseModelFromJson(jsonString);

class CategoryFileResponseModel {
  bool? status;
  String? message;
  FileData? data;

  CategoryFileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryFileResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryFileResponseModel(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] != null ? FileData.fromJson(json["Data"]) : null,
    );
  }
}

class FileData {
  List<CategoryFileModel> files;
  int totalCount;
  bool hasMore;

  FileData({
    required this.files,
    required this.totalCount,
    required this.hasMore,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      files: (json["Files"] as List)
          .map((e) => CategoryFileModel.fromJson(e))
          .toList(),
      totalCount: json["TotalCount"] ?? 0,
      hasMore: json["HasMore"] ?? false,
    );
  }
}

class CategoryFileModel {
  String? id;
  String? filePath;
  String? fileName;
  String? fileType;
  double? sizeInMb;
  String? shareUrl;
  bool? isPopular;

  CategoryFileModel({
    this.id,
    this.filePath,
    this.fileName,
    this.fileType,
    this.sizeInMb,
    this.shareUrl,
    this.isPopular,
  });

  factory CategoryFileModel.fromJson(Map<String, dynamic> json) =>
      CategoryFileModel(
        id: json["Id"]?.toString(),
        filePath: json["FilePath"],
        fileName: json["FileName"],
        fileType: json["FileType"],
        sizeInMb: json["SizeInMB"]?.toDouble(),
        shareUrl: json["ShareUrl"],
        isPopular: json["IsPopular"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "FilePath": filePath,
        "FileName": fileName,
        "FileType": fileType,
        "SizeInMB": sizeInMb,
        "ShareUrl": shareUrl,
        "IsPopular": isPopular,
      };
}
