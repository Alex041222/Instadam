class Post {
  final String id;
  final String ownerId;
  final String imageUrl;
  final String? description;
  final int likes;

  Post({
    required this.id,
    required this.ownerId,
    required this.imageUrl,
    this.description,
    required this.likes,
  });
}
