import 'package:flutter/material.dart';
import 'package:journal/common/utils/datetime_utils.dart';
import 'package:journal/di/data_di.dart';
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
                            author: article.author,
                            authorAvatarUrl: article.authorAvatarUrl,
                            followers: article.followers,
                            isFollowed: article.isFollowed,
                            isCurrentUserAuthor: article.isCurrentUserAuthor,
                            onFollowPressed: () => context.read<ArticleDetailsProvider>().followOnPressed(),
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
                            author: article.author,
                            authorDescription: article.authorDescription,
                            authorAvatarUrl: article.authorAvatarUrl,
                            followers: article.followers,
                            isFollowed: article.isFollowed,
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
                        userAvatarUrl: article.currentUserAvatarUrl,
                      ),
                    ),
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

final class _ArticleHeader extends StatelessWidget {
  final String title;
  final String author;
  final String? authorAvatarUrl;
  final int followers;
  final bool isFollowed;
  final String date;
  final void Function()? onFollowPressed;
  final bool isCurrentUserAuthor;

  const _ArticleHeader({
    required this.title,
    required this.author,
    required this.isFollowed,
    required this.followers,
    this.authorAvatarUrl,
    required this.date,
    required this.onFollowPressed,
    required this.isCurrentUserAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          children: [
            AppCircleAvatar(username: author, avatarUrl: authorAvatarUrl, radius: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$followers подписчиков',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(width: 12),
            if (!isCurrentUserAuthor)
              TextButton(
                onPressed: onFollowPressed,
                child: Text(
                  isFollowed ? "Отписаться" : '+ Подписаться',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
          ],
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
  final List<String> content;

  const _ArticleContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          content.map((paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                paragraph,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }).toList(),
    );
  }
}

final class _ArticleFooter extends StatelessWidget {
  final String? authorAvatarUrl;
  final String author;
  final int followers;
  final bool isCurrentUserAuthor;
  final bool isFollowed;
  final String authorDescription;
  final void Function() followOnPressed;

  const _ArticleFooter({
    this.authorAvatarUrl,
    required this.author,
    required this.followers,
    required this.isCurrentUserAuthor,
    required this.isFollowed,
    required this.authorDescription,
    required this.followOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AppCircleAvatar(username: author, avatarUrl: authorAvatarUrl),
            if (!isCurrentUserAuthor) ElevatedButton(
              onPressed: followOnPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowed ? Colors.white : Colors.black,
                foregroundColor: isFollowed ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text(isFollowed ? 'Подписаны' : 'Подписатся', style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Автор: $author",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text("$followers подписчики", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 12),
        Text(authorDescription, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blue)),
        const SizedBox(height: 12),
      ],
    );
  }
}

final class _ArticleCommentsSection extends StatelessWidget {
  final List<UiComment> comments;
  final String username;
  final String? userAvatarUrl;
  final GlobalKey commentsKey;

  const _ArticleCommentsSection({
    required this.comments,
    required this.username,
    this.userAvatarUrl,
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
            AppCircleAvatar(username: username, avatarUrl: userAvatarUrl),
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
