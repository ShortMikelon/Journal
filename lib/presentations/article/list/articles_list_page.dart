import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:journal/presentations/widgets/article_list_card.dart';
import 'package:provider/provider.dart';

import 'articles_list_provider.dart';

final class ArticlesListPage extends StatelessWidget {
  const ArticlesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ArticlesListProvider(
            articlesRepository: DataDi().articlesRepository,
            tagRepository: DataDi().tagRepository,
          ),
      child: Consumer<ArticlesListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
            onRefresh: () => provider.refresh(),
            child: CustomScrollView(
              controller: provider.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: false,
                  expandedHeight: 100,
                  flexibleSpace: Align(
                    alignment: const Alignment(-1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Главная",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(
                            width: 250,
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: 'Поиск по имени',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[300],
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                // светлый синий фон
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onChanged: (value) {
                                context
                                    .read<ArticlesListProvider>()
                                    .searchArticles(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...switch (provider.state) {
                  LoadingState() => [_Loading()],
                  ErrorState(:final message) => [_Error(message)],
                  SuccessState(:final articles, :final tags) => [
                    SliverStickyHeader(
                      header: _TagsHorizontalList(
                        tags: tags,
                        tagOnPressed:
                            (tag) => context
                                .read<ArticlesListProvider>()
                                .toggleTag(tag.name),
                        selectedTag:
                            context.read<ArticlesListProvider>().selectedTag,
                      ),
                      sliver: _ArticlesList(articles),
                    ),
                  ],
                  LoadingMoreState(:final articles, :final tags) => [
                    SliverStickyHeader(
                      header: _TagsHorizontalList(
                        tags: tags,
                        tagOnPressed:
                            (tag) => context
                                .read<ArticlesListProvider>()
                                .toggleTag(tag.name),
                        selectedTag:
                            context.read<ArticlesListProvider>().selectedTag,
                      ),
                      sliver: _ArticlesList(articles),
                    ),
                    _Loading(),
                  ],
                  LoadingMoreErrorState(
                    :final articles,
                    :final errorMessage,
                    :final tags,
                  ) =>
                    [
                      _TagsHorizontalList(
                        tags: tags,
                        tagOnPressed:
                            (tag) => context
                                .read<ArticlesListProvider>()
                                .toggleTag(tag.name),
                        selectedTag:
                            context.read<ArticlesListProvider>().selectedTag,
                      ),
                      _ArticlesList(articles),
                      _Error(errorMessage),
                    ],
                  LoadingMoreEmptyState(:final articles, :final tags) => [
                    SliverStickyHeader(
                      header: _TagsHorizontalList(
                        tags: tags,
                        tagOnPressed:
                            (tag) => context
                                .read<ArticlesListProvider>()
                                .toggleTag(tag.name),
                        selectedTag:
                            context.read<ArticlesListProvider>().selectedTag,
                      ),
                      sliver: _ArticlesList(articles),
                    ),
                    const _Empty("Больше нет статей"),
                  ],
                  _ => [const SliverToBoxAdapter(child: SizedBox.shrink())],
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _TagsHorizontalList extends StatelessWidget {
  final List<Tag> tags;
  final void Function(Tag)? tagOnPressed;
  final String? selectedTag;

  const _TagsHorizontalList({
    required this.tags,
    required this.tagOnPressed,
    required this.selectedTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => VerticalDivider(color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = selectedTag == tag.name;
          return TextButton(
            style: TextButton.styleFrom(
              backgroundColor:
                  isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 10.1)
                      : null,
            ),
            child: Text(
              tag.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey[500],
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
            onPressed: () {
              if (tagOnPressed != null) tagOnPressed!(tag);
            },
          );
        },
      ),
    );
  }
}

final class _ArticlesList extends StatelessWidget {
  final List<ArticleListPreviewEntity> articles;

  const _ArticlesList(this.articles);

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: articles.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final article = articles[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.articleDetails,
              arguments: article.id,
            );
          },
          child: ArticleListCard(
            imageBytes: article.imageBytes,
            title: article.title,
            subtitle: article.subtitle,
            authors: article.authors,
            date: article.createdAt,
            comments: article.comments,
            likes: article.likes,
          ),
        );
      },
    );
  }
}

final class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final class _Error extends StatelessWidget {
  final String message;

  const _Error(this.message);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

final class _Empty extends StatelessWidget {
  final String message;

  const _Empty(this.message);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}