class FeedModel {
  final String username;
  final email;
  final String caption;
  final List<String> imageUrls;
  String? profileImageUrl;

  FeedModel({
    required this.username,
    required this.email,
    required this.caption,
    required this.imageUrls,
  });
}
