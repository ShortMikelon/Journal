final class Tag {
  final String name;

  const Tag(this.name);
}

final class TagRepository {
  final _tags = <Tag>[
    Tag('Flutter'),
    Tag('React Native'),
    Tag('AI'),
    Tag('Технологии'),
    Tag('Dart'),
    Tag('Программирование'),
    Tag('Безопасность'),
    Tag('IT'),
    Tag('Web3'),
    Tag('Блокчейн'),
    Tag('Rust'),
    Tag('Мобильная разработка'),
    Tag('Big Data'),
    Tag('Аналитика'),
    Tag('Фронтенд'),
    Tag('Разработка'),
    Tag('Игры'),
    Tag('5G'),
    Tag('Связь'),
    Tag('Робототехника'),
    Tag('AI'),
    Tag('Медицина'),
    Tag('Финансы'),
    Tag('Будущее'),
    Tag('Генетика'),
    Tag('Биотехнологии'),
    Tag('Энергетика'),
    Tag('Экология'),
    Tag('Транспорт'),
    Tag('Космос'),
    Tag('Наука')
  ];

  Future<List<Tag>> getAllTags() async {
    return _tags;
  }
}