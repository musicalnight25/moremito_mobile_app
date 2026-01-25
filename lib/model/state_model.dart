class StateModel {
  int? id;
  String? name;

  StateModel({this.id, this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['Id'],
      name: json['Name'],
    );
  }
}
