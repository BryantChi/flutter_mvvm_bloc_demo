class User {
  // final String login;
  // final String avatarUrl;
  // final bool siteAdmin;
  // final String bio;
  //
  // User({
  //   required this.login,
  //   required this.avatarUrl,
  //   required this.siteAdmin,
  //   required this.bio
  // });
  //
  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     login: json['login'],
  //     avatarUrl: json['avatar_url'],
  //     siteAdmin: json['site_admin'],
  //     bio: json['bio'] ?? 'No bio available'
  //   );
  // }
  final String login;
  final int id;
  final String nodeId;
  final String avatarUrl;
  final String gravatarId;
  final String url;
  final String htmlUrl;
  final String followersUrl;
  final String followingUrl;
  final String gistsUrl;
  final String starredUrl;
  final String subscriptionsUrl;
  final String organizationsUrl;
  final String reposUrl;
  final String eventsUrl;
  final String receivedEventsUrl;
  final String type;
  final bool siteAdmin;
  final String name;
  final String company;
  final String blog;
  final String location;
  final String email;
  final bool hireable;
  final String bio;
  final String twitterUsername;
  final int publicRepos;
  final int publicGists;
  final int followers;
  final int following;

  User({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.siteAdmin,
    required this.name,
    required this.company,
    required this.blog,
    required this.location,
    required this.email,
    required this.hireable,
    required this.bio,
    required this.twitterUsername,
    required this.publicRepos,
    required this.publicGists,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    login: json["login"] ?? '',
    id: json["id"] ?? 0,
    nodeId: json["node_id"] ?? '',
    avatarUrl: json["avatar_url"] ?? '',
    gravatarId: json["gravatar_id"] ?? '',
    url: json["url"] ?? '',
    htmlUrl: json["html_url"] ?? '',
    followersUrl: json["followers_url"] ?? '',
    followingUrl: json["following_url"] ?? '',
    gistsUrl: json["gists_url"] ?? '',
    starredUrl: json["starred_url"] ?? '',
    subscriptionsUrl: json["subscriptions_url"] ?? '',
    organizationsUrl: json["organizations_url"] ?? '',
    reposUrl: json["repos_url"] ?? '',
    eventsUrl: json["events_url"] ?? '',
    receivedEventsUrl: json["received_events_url"] ?? '',
    type: json["type"] ?? '',
    siteAdmin: json["site_admin"] ?? false,
    name: json["name"] ?? '',
    company: json["company"] ?? '',
    blog: json["blog"] ?? '',
    location: json["location"] ?? '',
    email: json["email"] ?? '',
    hireable: json["hireable"] ?? false,
    bio: json["bio"] ?? 'No bio available',
    twitterUsername: json["twitter_username"] ?? '',
    publicRepos: json["public_repos"] ?? -1,
    publicGists: json["public_gists"] ?? -1,
    followers: json["followers"] ?? -1,
    following: json["following"] ?? -1
  );
}
