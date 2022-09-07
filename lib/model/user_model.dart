class UserModel {
  final String? uid;
  final String? name;
  final String? createdAt;

  UserModel({required this.createdAt, required this.name, required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        createdAt: json['createdAt'], name: json['name'], uid: json['uid']);
  }

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'createdAt': createdAt};
}
