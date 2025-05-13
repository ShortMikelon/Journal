import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:journal/common/utils/datetime_utils.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';
import 'package:journal/presentations/article/details/entities/ui_comment.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:provider/provider.dart';

final class ArticleDetailsPage extends StatelessWidget {
  final int articleId;

  const ArticleDetailsPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ArticleDetailsProvider(
          articlesRepository: DataDi().articlesRepository,
          usersRepository: DataDi().usersRepository,
          userSettings: DomainDi().userSettings,
        )..fetchArticle(articleId);
      },
      child: Consumer<ArticleDetailsProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          final scrollController = ScrollController();
          final commentsKey = GlobalKey();

          void scrollToComments() {
            final context = commentsKey.currentContext;
            if (context != null) {
              Scrollable.ensureVisible(
                context,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
                ...switch (state) {
                  LoadingState() => [
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                  ErrorState(:final message) => [
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ],
                  SuccessState(:final article) => [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 4.0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _ArticleHeader(
                            title: article.title,
                            date: article.date,
                            authors: article.authors,
                            isCurrentUserAuthor: article.isCurrentUserAuthor,
                            onFollowPressed: (author) => context.read<ArticleDetailsProvider>().followOnPressed(author),
                          ),
                          const SizedBox(height: 16),
                          _ArticleInteractionBar(
                            likes: article.likes,
                            isLiked: article.isLiked,
                            comments: article.comments.length,
                            likeOnPressed: provider.likeOnPressed,
                            bookmarkOnPressed: provider.bookmarkOnPressed,
                            commentOnPressed: scrollToComments,
                          ),

                          const SizedBox(height: 16),

                          _ArticleContent(content: article.content),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 16),
                          _ArticleFooter(
                            authors: article.authors,
                            isCurrentUserAuthor: article.isCurrentUserAuthor,
                            followOnPressed: provider.followOnPressed,
                          ),
                          const Divider(color: Colors.grey),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: _ArticleCommentsSection(
                        commentsKey: commentsKey,
                        comments: article.comments,
                        username: article.currentUsername,
                        userAvatarBytes: article.currentUserAvatarBytes,
                      ),
                    ),
                  ],
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _ArticleHeader extends StatelessWidget {
  final String title;
  final List<ArticleAuthors> authors;
  final String date;
  final void Function(ArticleAuthors author)? onFollowPressed;
  final bool isCurrentUserAuthor;

  const _ArticleHeader({
    required this.title,
    required this.authors,
    required this.date,
    required this.onFollowPressed,
    required this.isCurrentUserAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: authors.map(
                  (author) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 260,
                  child: Row(
                    children: [
                      AppCircleAvatar(
                        username: author.author,
                        avatarBytes: author.authorAvatarUrl,
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author.author,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (author.authorDescription.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                author.authorDescription,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              '${author.followers} подписчиков',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                            ),
                            if (!isCurrentUserAuthor)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () => onFollowPressed?.call(author),
                                  child: Text(
                                    author.isFollowed ? 'Отписаться' : '+ Подписаться',
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

final class _ArticleInteractionBar extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final int comments;
  final void Function()? likeOnPressed;
  final void Function()? commentOnPressed;
  final void Function()? bookmarkOnPressed;

  const _ArticleInteractionBar({
    required this.likes,
    required this.isLiked,
    required this.comments,
    required this.likeOnPressed,
    required this.commentOnPressed,
    required this.bookmarkOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: IconButton(
            key: ValueKey(isLiked),
            onPressed: likeOnPressed,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.black,
              size: 30.0,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            key: ValueKey(likes),
            "$likes",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isLiked ? Colors.red : Colors.black),
          ),
        ),
        const SizedBox(width: 18),
        IconButton(
          onPressed: commentOnPressed,
          icon: const Icon(Icons.chat_bubble_outline, size: 30),
        ),
        Text("$comments",  style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        IconButton(
          onPressed: bookmarkOnPressed,
          icon: const Icon(Icons.bookmark_border, size: 30.0,),
        ),
        const SizedBox(width: 18),
        IconButton(onPressed: null, icon: const Icon(Icons.share, size: 30.0,)),
      ],
    );
  }
}

final class _ArticleContent extends StatelessWidget {
  final List<BodyComponent> content;

  const _ArticleContent({required this.content});

  @override
  Widget build(BuildContext context) {
    content.sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((component) {
        if (component is TextBodyComponent) {
          return TextBodyComponentWidget(component: component);
        } else if (component is ImageBodyComponent) {
          return ImageBodyComponentWidget(component: component);
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}

final class _ArticleFooter extends StatelessWidget {
  final List<ArticleAuthors> authors;
  final bool isCurrentUserAuthor;
  final void Function(ArticleAuthors author) followOnPressed;

  const _ArticleFooter({
    required this.authors,
    required this.isCurrentUserAuthor,
    required this.followOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Авторы статьи',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: authors.map((author) {
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppCircleAvatar(
                          username: author.author,
                          avatarBytes: author.authorAvatarUrl,
                          radius: 24,
                        ),
                        if (!isCurrentUserAuthor)
                          ElevatedButton(
                            onPressed: () => followOnPressed(author),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: author.isFollowed ? Colors.white : Colors.black,
                              foregroundColor: author.isFollowed ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.black),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: Theme.of(context).textTheme.titleSmall,
                            ),
                            child: Text(author.isFollowed ? 'Подписаны' : 'Подписаться'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Автор: ${author.author}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${author.followers} подписчики",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      author.authorDescription,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blue),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

final class _ArticleCommentsSection extends StatelessWidget {
  final List<UiComment> comments;
  final String username;
  final Uint8List? userAvatarBytes;
  final GlobalKey commentsKey;

  const _ArticleCommentsSection({
    required this.comments,
    required this.username,
    this.userAvatarBytes,
    required this.commentsKey,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      key: commentsKey,
      delegate: SliverChildListDelegate([
        const SizedBox(height: 12),
        Text(
          comments.isEmpty
              ? "Нет комментариев"
              : comments.length == 1
              ? "1 комментарий"
              : "Комментариев: ${comments.length}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            AppCircleAvatar(username: username, avatarBytes: userAvatarBytes),
            const SizedBox(width: 12),
            Text(username, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: "Какие у вас мысли?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 20),
        ...comments.map(
          (comment) => _ArticleComment(
            author: comment.author,
            avatarUrl: comment.authorAvatarUrl,
            content: comment.text,
            likes: comment.likes,
            isLiked: comment.isLiked,
            date: formatDate(comment.datetime),
          ),
        ),
      ]),
    );
  }
}

final class _ArticleComment extends StatelessWidget {
  final String author;
  final String date;
  final String content;
  final bool isLiked;
  final int likes;
  final String? avatarUrl;

  const _ArticleComment({
    required this.author,
    required this.date,
    required this.content,
    required this.likes,
    required this.isLiked,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            AppCircleAvatar(username: author, avatarUrl: avatarUrl),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text("$likes", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 16),
            Icon(Icons.comment, size: 16, color: Colors.grey[600]),
          ],
        ),

        const SizedBox(height: 12),

        Divider(color: Colors.grey[300]),
      ],
    );
  }
}


class TextBodyComponentWidget extends StatelessWidget {
  final TextBodyComponent component;

  const TextBodyComponentWidget({super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        component.text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class ImageBodyComponentWidget extends StatelessWidget {
  final ImageBodyComponent component;

  const ImageBodyComponentWidget({super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.memory(component.imageBytes),
          const SizedBox(height: 8),
          Text(
            component.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

