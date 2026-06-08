import 'dart:convert';

class AuthResponseModel {
  final User? user;
  final String? token;

  AuthResponseModel({this.user, this.token});

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(user: User.fromMap(json["user"]), token: json["token"]);

  Map<String, dynamic> toMap() => {"user": user?.toMap(), "token": token};
}

class User {
  final int? id;
  final String? username;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? name;
  final dynamic avatarUrl;
  final int? totalXp;
  final int? level;
  final int? gems;
  final int? currentStreak;
  final int? longestStreak;
  final dynamic createdAt;
  final dynamic updatedAt;

  User({
    this.id,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.name,
    this.avatarUrl,
    this.totalXp,
    this.level,
    this.gems,
    this.currentStreak,
    this.longestStreak,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    name: json["name"],
    avatarUrl: json["avatar_url"],
    totalXp: json["total_xp"],
    level: json["level"],
    gems: json["gems"],
    currentStreak: json["current_streak"],
    longestStreak: json["longest_streak"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "name": name,
    "avatar_url": avatarUrl,
    "total_xp": totalXp,
    "level": level,
    "gems": gems,
    "current_streak": currentStreak,
    "longest_streak": longestStreak,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
