class ChatUser {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });
}