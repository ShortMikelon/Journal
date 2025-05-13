import '../api_service.dart';

final class Tag {
  final String name;

  const Tag(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Tag && runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

}

final class TagRepository {
  final _apiClient = ApiService.client;

  Future<List<Tag>> getAllTags() async {
    final response = await _apiClient.getAllTags();

    return response.map((tag) => Tag(tag.name)).toList();
  }
}