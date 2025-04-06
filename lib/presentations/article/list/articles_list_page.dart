import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/di/presentation_di.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:provider/provider.dart';

import 'articles_list_provider.dart';

final class ArticlesListPage extends StatelessWidget {
  const ArticlesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresentationDi().articlesListProvider,
      child: Consumer<ArticlesListProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            bottomNavigationBar: const _BottomNavBar(),
            body: _ArticlesBody(
              state: provider.state,
              scrollController: provider.scrollController,
            ),
          );
        },
      ),
    );
  }
}

class _ArticlesBody extends StatelessWidget {
  final ArticlesListState state;
  final ScrollController scrollController;

  const _ArticlesBody({required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
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
                vertical: 16.0,
              ),
              child: Text(
                "Главная",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        ...switch (state) {
          LoadingState() => [_Loading()],
          ErrorState(:final message) => [_Error(message)],
          SuccessState(:final articles, :final tags) => [
            SliverStickyHeader(
              header: _TagsHorizontalList(tags: tags, tagOnPressed: null),
              sliver: _ArticlesList(articles),
            ),
          ],
          LoadingMoreState(:final articles, :final tags) => [
            SliverStickyHeader(
              header: _TagsHorizontalList(tags: tags, tagOnPressed: null),
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
              _TagsHorizontalList(tags: tags, tagOnPressed: null),
              _ArticlesList(articles),
              _Error(errorMessage),
            ],
          LoadingMoreEmptyState(:final articles, :final tags) => [
            SliverStickyHeader(
              header: _TagsHorizontalList(tags: tags, tagOnPressed: null),
              sliver: _ArticlesList(articles),
            ),
            const _Empty("Больше нет статей"),
          ],
          _ => [const SliverToBoxAdapter(child: SizedBox.shrink())],
        },
      ],
    );
  }
}

final class _TagsHorizontalList extends StatelessWidget {
  final List<Tag> tags;
  final void Function(Tag)? tagOnPressed;

  const _TagsHorizontalList({required this.tags, required this.tagOnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => VerticalDivider(color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return TextButton(
            child: Text(
              tag.name,
              style: Theme.of(context).textTheme.titleMedium,
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
          child: _ArticleListCard(
            imageUrl: article.imageUrl,
            authorAvatarUrl: article.authorAvatarUrl,
            title: article.title,
            subtitle: article.subtitle,
            author: article.author,
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

final class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}

final class _ArticleListCard extends StatelessWidget {
  final String? authorAvatarUrl;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String author;
  final String date;
  final int likes;
  final int comments;

  const _ArticleListCard({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.authorAvatarUrl,
    required this.author,
    required this.date,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            _AuthorInfo(author: author, avatarUrl: authorAvatarUrl),
            const SizedBox(height: 12),
            _ArticleTitle(title: title),
            const SizedBox(height: 8),
            _ArticleSubtitle(subtitle: subtitle),
            const SizedBox(height: 26),
            _ArticleStats(date: date, likes: likes, comments: comments),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

final class _AuthorInfo extends StatelessWidget {
  final String author;
  final String? avatarUrl;

  const _AuthorInfo({required this.author, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCircleAvatar(avatarUrl: avatarUrl, username: author),
        const SizedBox(width: 8),
        Text(author, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

final class _ArticleTitle extends StatelessWidget {
  final String title;

  const _ArticleTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

final class _ArticleSubtitle extends StatelessWidget {
  final String subtitle;

  const _ArticleSubtitle({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
        ),
      ],
    );
  }
}

final class _ArticleStats extends StatelessWidget {
  final String date;
  final int likes;
  final int comments;

  const _ArticleStats({
    required this.date,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 22, color: Colors.orange),
        const SizedBox(width: 8),
        Text(date, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 16),
        const Icon(Icons.remove_red_eye, size: 22, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$likes", style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 16),
        const Icon(Icons.comment, size: 22, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$comments", style: Theme.of(context).textTheme.titleSmall),
        const Spacer(),
        const Icon(Icons.more_vert, size: 24, color: Colors.grey),
      ],
    );
  }
}
