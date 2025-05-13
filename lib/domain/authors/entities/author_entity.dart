import 'dart:typed_data';

final class UserEntity {
  final int id;
  final String name;
  final String aboutMe;
  final Uint8List? avatarBytes;
  final int followers;
  final int following;
  final bool isFollowings;
  final bool isMe;

  const UserEntity({
    required this.id,
    required this.name,
    required this.aboutMe,
    this.avatarBytes,
    required this.followers,
    required this.following,
    required this.isFollowings,
    required this.isMe,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? aboutMe,
    Uint8List? avatarBytes,
    int? followers,
    int? following,
    bool? isFollowings,
    bool? isMe,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      aboutMe: aboutMe ?? this.aboutMe,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isFollowings: isFollowings ?? this.isFollowings,
      isMe: isMe ?? this.isMe,
    );
  }
}