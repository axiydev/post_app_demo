class PostModel {
  final String? username;
  final String? description;
  final String? createdDate;
  final String? id;
  final String? userId;
  final String? imageUrl;
  final String? imageName;
  PostModel(
      {required this.imageName,
      required this.createdDate,
      required this.description,
      required this.id,
      required this.userId,
      required this.imageUrl,
      required this.username});
  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        createdDate = json['createdDate'],
        imageName = json['imageName'],
        username = json['username'];
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'id': id,
      'userId': userId,
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
    String? userId,
    String? imageName,
  }) =>
      PostModel(
          createdDate: createdDate ?? this.createdDate,
          description: description ?? this.description,
          id: id ?? this.id,
          userId: userId ?? this.userId,
          imageUrl: imageUrl ?? this.imageUrl,
          imageName: imageName ?? this.imageName,
          username: username ?? this.username);
}
