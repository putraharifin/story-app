class UserSession {
  const UserSession({
    required this.userId,
    required this.name,
    required this.token,
  });

  final String userId;
  final String name;
  final String token;
}
