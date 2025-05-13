import 'package:dio/dio.dart';
import 'package:journal/data/api/article/preview/article_preview_model.dart';
import 'package:journal/data/api/tag/tag_response_dto.dart';
import 'package:journal/data/api/user/edit_profile_request_dto.dart';
import 'package:journal/data/api/user/login_request_dto.dart';
import 'package:journal/data/api/user/login_response_dto.dart';
import 'package:journal/data/api/user/registration_request_dto.dart';
import 'package:journal/data/api/user/registration_response_dto.dart';
import 'package:journal/data/api/user/statistics_response_dto.dart';
import 'package:journal/data/api/user/subscribe_request_dto.dart';
import 'package:journal/data/api/user/user_dto.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import 'article/article_details_dto.dart';
import 'article/requests/fetch_all_article_by_author_request_dto.dart';
import 'article/requests/fetch_article_by_id_request_body.dart';
import 'article/requests/user_id_and_article_id_request_body.dart';
import 'article/requests/user_id_and_draft_article_id_request_body.dart';
import 'draft/change_authors_dto.dart';
import 'draft/create_article_request_dto.dart';
import 'draft/draft_article_dto.dart';
import 'draft/draft_article_preview_dto.dart';
import 'draft/fetch_draft_article_request_dto.dart';
import 'draft/save_article_request_dto.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://192.168.1.37:8080/api/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('article/fetchArticleForYou/{userId}')
  Future<List<ArticlePreviewModel>> getArticleList(@Path("userId") int userId);

  @POST('article/fetchById')
  Future<ArticleDetailsDto> getArticleById(@Body() FetchArticleByIdRequestBody requestBody);

  @POST('article/fetchAllByAuthor')
  Future<List<ArticlePreviewModel>> getArticlesByAuthor(@Body() FetchAllArticleByAuthorRequestDto requestBody);

  @POST('article/likeArticle')
  Future<void> likeArticle(@Body() UserIdAndArticleIdRequestBody requestBody);

  @POST('article/showArticle')
  Future<void> showArticle(@Body() UserIdAndArticleIdRequestBody requestBody);

  @POST('article/hideArticle')
  Future<void> hideArticle(@Body() UserIdAndArticleIdRequestBody requestBody);

  @POST('article/bookmark')
  Future<void> bookmark(@Body() UserIdAndArticleIdRequestBody requestBody);

  @POST('article/publish')
  Future<void> publish(@Body() UserIdAndDraftArticleIdRequestBody requestBody);

  @GET('tags/getAll')
  Future<List<TagResponseDto>> getAllTags();

  @GET('user/edit')
  Future<void> editProfile(@Body() EditProfileRequestDto requestBody);

  @GET('user/profile/{userId}/{profileId}')
  Future<UserDto> profile(@Path("userId") int userId, @Path("profileId") int profileId);

  @GET('user/registration')
  Future<RegistrationResponseDto> registration(@Body() RegistrationRequestDto requestBody);

  @GET('user/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto requestBody);

  @GET('user/statistics/{userId}')
  Future<StatisticsResponseDto> statistics(@Path("userId") int userId);

  @GET('user/subscribe')
  Future<void> subscribe(@Body() SubscribeRequestDto requestBody);

  @GET('user/unsubscribe')
  Future<void> unsubscribe(@Body() SubscribeRequestDto requestBody);

  @POST("user/fetchUserFollowers/{userId}")
  Future<List<UserDto>> fetchUserFollowers(@Path("userId") int userId);

  @POST("user/fetchUserFollowings/{userId}")
  Future<List<UserDto>> fetchUserFollowings(@Path("userId") int userId);

  @GET("draftArticle/create")
  Future<Map<String, int>> createDraftArticle(@Body() CreateArticleRequestDto body);

  @GET("draftArticle/save")
  Future<Map<String, int>> saveDraftArticle(@Body() SaveArticleRequestDto body);

  @GET("draftArticle/addNewAuthors")
  Future<void> addNewAuthors(@Body() ChangeAuthorsDto body);

  @GET("draftArticle/removeAuthors")
  Future<void> removeAuthors(@Body() ChangeAuthorsDto body);

  @GET("draftArticle/fetchDraftArticle")
  Future<DraftArticleDto> fetchDraftArticleById(@Body() FetchDraftArticleRequestDto body);

  @GET("draftArticle/fetchDraftArticlesByAuthor/{userId}")
  Future<List<DraftArticlePreviewDto>> fetchDraftArticlesByUserId(@Path("userId") int userId);

  @GET("draftArticle/deleteDraftArticle/{draftArticleId}")
  Future<void> deleteDraftArticleByDraftArticleId(@Path("draftArticleId") int draftArticleId);

}