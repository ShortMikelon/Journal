import 'package:json_annotation/json_annotation.dart';

part 'change_authors_dto.g.dart';

@JsonSerializable()
class ChangeAuthorsDto {
  final int draftArticleId;
  final List<int> authorIds;

  ChangeAuthorsDto({
    required this.draftArticleId,
    required this.authorIds,
  });

  factory ChangeAuthorsDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeAuthorsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeAuthorsDtoToJson(this);
}
