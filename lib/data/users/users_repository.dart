import 'package:journal/data/api/user/subscribe_request_dto.dart';
import 'package:journal/domain/authors/entities/author_entity.dart';

import '../../di/domain_di.dart';
import '../api_service.dart';

class UsersRepository {
  final _apiClient = ApiService.client;
  final _userSettings = DomainDi().userSettings;

  Future<UserEntity> getUserDetails(int profileId) async {
    final userId = (await _userSettings.id)!;
    final response = await _apiClient.profile(userId, profileId);
    final currentUserId = await _userSettings.id;

    return UserEntity(
      id: response.id,
      name: response.name,
      aboutMe: response.aboutMe,
      followers: response.followers,
      following: response.followings,
      avatarBytes: response.avatarBytes,
      isMe: currentUserId == response.id,
      isFollowings: response.isFollowed
    );
  }

  Future<List<UserEntity>> getFollowersByUserId(int userId) async {
    final response = await _apiClient.fetchUserFollowers(userId);

    return response.map((user) {
      return UserEntity(
        id: user.id,
        name: user.name,
        aboutMe: user.aboutMe,
        followers: user.followers,
        following: user.followings,
        isMe: false,
        isFollowings: user.isFollowed
      );
    }).toList();
  }

  Future<List<UserEntity>> getFollowingsByUserId(int userId) async {
    final response = await _apiClient.fetchUserFollowers(userId);

    return response.map((user) {
      return UserEntity(
          id: user.id,
          name: user.name,
          aboutMe: user.aboutMe,
          followers: user.followers,
          following: user.followings,
          isMe: false,
          isFollowings: user.isFollowed
      );
    }).toList();
  }

  Future<void> toggleFollow({
    required int authorId,
    required int userId,
  }) async {
    final requestBody = SubscribeRequestDto(
      userId: authorId,
      followerId: userId,
    );
    await _apiClient.subscribe(requestBody);
  }
}
