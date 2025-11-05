class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  AppUser({required this.uid, required this.name, required this.email, this.photoUrl});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory AppUser.fromJson(Map<dynamic, dynamic> json) => AppUser(
        uid: json['uid'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String?,
      );
}
