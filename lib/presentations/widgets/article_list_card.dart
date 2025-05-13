import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'app_circle_avatar.dart';

final class ArticleListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? imageBytes;
  final String date;
  final int likes;
  final int comments;
  final List<ArticleAuthorUi> authors;

  const ArticleListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageBytes,
    required this.authors,
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
            _AuthorInfo(authors: authors),
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
  final List<ArticleAuthorUi> authors;

  const _AuthorInfo({required this.authors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...authors.map(
              (author) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCircleAvatar(
                  avatarUrl: author.authorUrl,
                  username: author.author,
                  avatarBytes: author.authorBytes,
                ),
                const SizedBox(width: 8),
                Text(
                  author.author,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
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

final class ArticleAuthorUi {
  final String author;
  final Uint8List? authorBytes;
  final String? authorUrl;

  const ArticleAuthorUi({
    required this.author,
    this.authorBytes,
    this.authorUrl,
  });
}