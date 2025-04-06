final class UserEntity {
  final int id;
  final String name;
  final String aboutMe;
  final String? avatarUrl;
  final int followers;

  const UserEntity({
    required this.id,
    required this.name,
    required this.aboutMe,
    this.avatarUrl,
    required this.followers,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? aboutMe,
    String? avatarUrl,
    int? followers,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      aboutMe: aboutMe ?? this.aboutMe,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followers: followers ?? this.followers,
    );
  }
}