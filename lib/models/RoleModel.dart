class RoleModel {
  RoleModel({
    this.id,
    required this.name,
  });

  String? id;
  String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  RoleModel.fromJson(Map<String, dynamic> roleJson)
      : id = roleJson['id'],
        name = roleJson['name'];
}
