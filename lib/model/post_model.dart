class PostModel {
  final String? username;
  final String? description;
  final String? createdDate;
  final String? id;
  final String? imageUrl;
  final String? imageName;
  PostModel(
      {required this.imageName,
      required this.createdDate,
      required this.description,
      required this.id,
      required this.imageUrl,
      required this.username});
  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        createdDate = json['createdDate'],
        imageName = json['imageName'],
        username = json['username'];
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'username': username,
      'createdDate': createdDate,
      'imageName': imageName
    };
  }

  PostModel copyWith({
    String? username,
    String? description,
    String? createdDate,
    String? id,
    String? imageUrl,
    String? imageName,
  }) =>
      PostModel(
          createdDate: createdDate ?? this.createdDate,
          description: description ?? this.description,
          id: id ?? this.id,
          imageUrl: imageUrl ?? this.imageUrl,
          imageName: imageName ?? this.imageName,
          username: username ?? this.username);
}
