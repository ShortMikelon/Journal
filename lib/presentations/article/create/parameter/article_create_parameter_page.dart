import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/presentations/article/create/parameter/article_create_parameter_provider.dart';
import 'package:journal/presentations/article/create/parameter/tags_dialog/tags_dialog.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:provider/provider.dart';

final class ArticleCreateParameterPage extends StatelessWidget {
  final int draftArticleId;

  const ArticleCreateParameterPage({super.key, required this.draftArticleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ArticleCreateParameterProvider(
            draftArticleId: draftArticleId,
            draftArticlesRepository: DataDi().draftArticleRepository,
            articlesRepository: DataDi().articlesRepository,
            tagRepository: DataDi().tagRepository,
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
    return Consumer<ArticleCreateParameterProvider>(
      builder: (context, provider, _) {
        _handleEvents(context, provider);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult:
              (didPop, _) => _onBackPressed(context, provider),
          child: Scaffold(
            appBar: _ArticleAppBar(
              onBackPressed: () => _onBackPressed(context, provider),
            ),
            body: _ArticleBody(
              username: provider.username,
              avatarBytes: provider.avatarBytes,
              titleController: provider.titleController,
              subtitleController: provider.subtitleController,
              selectedTags: provider.selectedTopics,
              onTagSelected: (tag) {
                provider.toggleTopic(tag);
              },
              onEditPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.articleCreateSandbox,
                  arguments: provider.draftArticle?.id ?? -1,
                );
              },
            ),
            bottomNavigationBar: _PublishButton(
              onPressed: () => provider.publishArticle(),
            ),
          ),
        );
      },
    );
  }

  void _handleEvents(
    BuildContext context,
    ArticleCreateParameterProvider provider,
  ) {
    final loadingState = provider.showLoadingEvent?.value;
    if (loadingState == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      });
    } else if (loadingState == false) {
      Navigator.pop(context);
    }

    final errorMessage = provider.showErrorEvent?.value;
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      });
    }

    final fixedComponents = provider.textFixedEvent?.value;
    if (fixedComponents != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Текст успешно исправлен'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    final navigateToSandbox = provider.navigateToSandboxPageEvent?.value;
    if (navigateToSandbox != null && navigateToSandbox) {
      Navigator.pushReplacementNamed(context, Routes.articleCreateSandbox);
    }

    final publishIsSuccess = provider.publishEvent?.value;
    if (publishIsSuccess != null && publishIsSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
              (route) => false,
        );
      });
    }
  }

  Future<void> _onBackPressed(
    BuildContext context,
    ArticleCreateParameterProvider provider,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Сохранить черновик?'),
            content: const Text('Вы хотите сохранить изменения перед выходом?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Выйти без сохранения',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Сохранить и выйти',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
    );

    if (result == null) return;

    if (result) {
      provider.saveDraft();
    }

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}

final class _ArticleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const _ArticleAppBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      title: const Text('Параметры статьи'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

final class _ArticleBody extends StatelessWidget {
  final String username;
  final Uint8List? avatarBytes;
  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final List<Tag> selectedTags;
  final void Function(Tag) onTagSelected;
  final void Function() onEditPressed;

  const _ArticleBody({
    required this.username,
    required this.avatarBytes,
    required this.titleController,
    required this.subtitleController,
    required this.selectedTags,
    required this.onTagSelected,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DescriptionText(),
          const SizedBox(height: 24),
          _ArticlePreviewCard(
            username: username,
            avatarBytes: avatarBytes,
            titleController: titleController,
            subtitleController: subtitleController,
            onEditPressed: onEditPressed,
          ),
          const SizedBox(height: 32),
          _TagsSection(selectedTags: selectedTags, tagSelected: onTagSelected),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

final class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Так ваша история будет показана читателям в публичных местах, например на домашней странице.',
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
    );
  }
}

final class _ArticlePreviewCard extends StatelessWidget {
  final String username;
  final Uint8List? avatarBytes;
  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final void Function() onEditPressed;

  const _ArticlePreviewCard({
    required this.username,
    required this.avatarBytes,
    required this.titleController,
    required this.subtitleController,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AuthorInfo(username: username, avatarBytes: avatarBytes),
            const SizedBox(height: 16),
            _TitleField(controller: titleController),
            _SubtitleField(controller: subtitleController),
            _EditButton(onPressed: onEditPressed),
          ],
        ),
      ),
    );
  }
}

final class _AuthorInfo extends StatelessWidget {
  final String username;
  final Uint8List? avatarBytes;

  const _AuthorInfo({required this.username, required this.avatarBytes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCircleAvatar(username: username, avatarBytes: avatarBytes),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            username,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

final class _TitleField extends StatelessWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Заголовок статьи',
      ),
    );
  }
}

final class _SubtitleField extends StatelessWidget {
  final TextEditingController controller;

  const _SubtitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Описание статьи',
      ),
    );
  }
}

final class _EditButton extends StatelessWidget {
  final void Function() onPressed;

  const _EditButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Редактировать',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

final class _TagsSection extends StatelessWidget {
  final List<Tag> selectedTags;
  final void Function(Tag) tagSelected;

  const _TagsSection({required this.selectedTags, required this.tagSelected});

  @override
  Widget build(BuildContext context) {
    return _SectionTile(
      title: 'Тэги',
      subtitle:
          selectedTags.isEmpty
              ? 'Тэги отсутствует'
              : selectedTags.map((tag) => tag.name).join(', '),
      onTap:
          () => _showTagsDialog(
            context,
            context.read<ArticleCreateParameterProvider>(),
          ),
    );
  }

  void _showTagsDialog(
    BuildContext context,
    ArticleCreateParameterProvider provider,
  ) {
    showTagsDialog(
      context: context,
      selectedTags: selectedTags,
      tagRepository: DataDi().tagRepository,
      parameterProvider: provider,
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
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

final class _PublishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PublishButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            await context
                .read<ArticleCreateParameterProvider>()
                .publishArticle();
            Navigator.pushReplacementNamed(context, Routes.home);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text('Опубликовать'),
        ),
      ),
    );
  }
}
