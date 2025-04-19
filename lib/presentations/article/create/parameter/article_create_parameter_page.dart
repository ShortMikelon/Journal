import 'package:flutter/material.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:provider/provider.dart';
import 'article_create_parameter_provider.dart';

final class ArticleCreateParameterPage extends StatelessWidget {
  final int draftArticleId;

  const ArticleCreateParameterPage({super.key, required this.draftArticleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticleCreateParameterProvider(
        draftArticleId: draftArticleId,
        draftArticlesRepository: DataDi().draftArticleRepository,
        userSettings: DomainDi().userSettings,
      ),
      child: const _ArticleCreateParameterView(),
    );
  }
}

final class _ArticleCreateParameterView extends StatelessWidget {
  const _ArticleCreateParameterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Параметры статьи'),
      ),
      body: Consumer<ArticleCreateParameterProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This is how your story will be shown to readers in public places, like Medium\'s homepage and subscribers\' inboxes. Changes made here will not affect the contents of the story itself.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppCircleAvatar(
                              username: provider.username,
                              avatarUrl: provider.avatarUrl,
                            ),
                            const SizedBox(width: 8),
                            Text(provider.username),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: provider.titleController,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Заголовок статьи',
                          ),
                        ),
                        TextField(
                          controller: provider.subtitleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Описание статьи',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Редактировать'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _SectionTile(
                  title: 'Тэги',
                  subtitle: provider.selectedTopics.isEmpty 
                    ? 'Тэги отсутствует'
                    : provider.selectedTopics.join(', '),
                  onTap: () {
                    // TODO: Implement topics selection
                  },
                ),
                const SizedBox(height: 32)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              context.read<ArticleCreateParameterProvider>().publishArticle();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Опубликовать'),
          ),
        ),
      ),
    );
  }
}

final class _SectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SectionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
