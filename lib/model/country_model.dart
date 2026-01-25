class CountryModel {
  int? id;
  String? name;

  CountryModel({this.id, this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['Id'],
      name: json['Name'],
    );
  }
}
