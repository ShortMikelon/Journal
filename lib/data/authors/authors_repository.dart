import 'package:journal/domain/authors/entities/author_entity.dart';

final class AuthorsRepository {

  final _authors = <UserEntity>[
    // UserEntity(id: 1, name: 'John Doe', followers: 150),
    // UserEntity(id: 2, name: 'Jane Smith', followers: 201),
    // UserEntity(id: 3, name: 'Alice Brown', followers: 1),
    // UserEntity(id: 4, name: 'Robert Wilson', followers: 87),
    // UserEntity(id: 5, name: 'Lucas Moore', followers: 3000),
  ];

  Future<UserEntity> getById(int id) async {
    return _authors.firstWhere((author) => author.id == id);
  }

  Future<List<UserEntity>> getByIds(List<int> ids) async {
    return _authors.where((author) => ids.contains(author.id)).toList();
  }
}