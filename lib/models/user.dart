class User {
  final String login;
  final String avatarUrl;
  final bool siteAdmin;
  final String? bio;

  User({
    required this.login,
    required this.avatarUrl,
    required this.siteAdmin,
    this.bio
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      siteAdmin: json['site_admin'],
      bio: json['bio']
    );
  }
}
