import 'dart:convert';

UserRoleResponse userRoleResponseFromJson(String str) =>
    UserRoleResponse.fromJson(json.decode(str));

class UserRoleResponse {
  bool? status;
  String? message;
  UserRoleData? data;

  UserRoleResponse({this.status, this.message, this.data});

  factory UserRoleResponse.fromJson(Map<String, dynamic> json) {
    return UserRoleResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] == null ? null : UserRoleData.fromJson(json["Data"]),
    );
  }
}

class UserRoleData {
  CurrentRole? currentRole;
  List<AvailableRole>? availableRoles;
  bool? hasW9;

  UserRoleData({
    this.currentRole,
    this.availableRoles,
    this.hasW9,
  });

  factory UserRoleData.fromJson(Map<String, dynamic> json) {
    return UserRoleData(
      currentRole: json["CurrentRole"] == null
          ? null
          : CurrentRole.fromJson(json["CurrentRole"]),
      availableRoles: json["AvailableRoles"] == null
          ? []
          : List<AvailableRole>.from(
              json["AvailableRoles"].map(
                (x) => AvailableRole.fromJson(x),
              ),
            ),
      hasW9: json["HasW9"],
    );
  }
}

class CurrentRole {
  String? roleId;
  String? roleName;
  String? description;

  CurrentRole({this.roleId, this.roleName, this.description});

  factory CurrentRole.fromJson(Map<String, dynamic> json) {
    return CurrentRole(
      roleId: json["RoleId"],
      roleName: json["RoleName"],
      description: json["Description"],
    );
  }
}

class AvailableRole {
  String? roleId;
  String? roleName;
  String? description;

  AvailableRole({this.roleId, this.roleName, this.description});

  factory AvailableRole.fromJson(Map<String, dynamic> json) {
    return AvailableRole(
      roleId: json["RoleId"],
      roleName: json["RoleName"],
      description: json["Description"],
    );
  }
}
