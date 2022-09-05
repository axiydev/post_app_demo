class PostModel {
  final String? username;
  final String? description;
  final String? createdDate;
  final String? id;
  final String? imageUrl;
  PostModel(
      {required this.createdDate,
      required this.description,
      required this.id,
      required this.imageUrl,
      required this.username});
  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        createdDate = json['createdDate'],
        username = json['username'];
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'username': username,
      'createdDate': createdDate
    };
  }

  PostModel copyWith({
    String? username,
    String? description,
    String? createdDate,
    String? id,
    String? imageUrl,
  }) =>
      PostModel(
          createdDate: createdDate ?? this.createdDate,
          description: description ?? this.description,
          id: id ?? this.id,
          imageUrl: imageUrl ?? this.imageUrl,
          username: username ?? this.username);
}
