class TmrisContentModel {
  final bool? status;
  final TmrisData? data;

  TmrisContentModel({this.status, this.data});

  factory TmrisContentModel.fromJson(Map<String, dynamic> json) {
    return TmrisContentModel(
      status: json['Status'],
      data: json['Data'] != null ? TmrisData.fromJson(json['Data']) : null,
    );
  }
}

class TmrisData {
  final List<String> fields;

  TmrisData({required this.fields});

  factory TmrisData.fromJson(Map<String, dynamic> json) {
    return TmrisData(
      fields: List.generate(10, (index) {
        final key = "Field${index + 1}";
        return (json[key] ?? "").toString();
      }).where((e) => e.trim().isNotEmpty).toList(),
    );
  }
}
