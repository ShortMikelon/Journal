import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/presentations/article/create/parameter/article_create_parameter_provider.dart';
import 'package:journal/presentations/article/create/parameter/tags_dialog/tags_dialog_provider.dart';
import 'package:provider/provider.dart';

void showTagsDialog({
  required BuildContext context,
  required List<Tag> selectedTags,
  required TagRepository tagRepository,
  required ArticleCreateParameterProvider parameterProvider,
}) {
  showModalBottomSheet<List<Tag>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (_) {
          return TagsDialogProvider(
            tagRepository: tagRepository,
            selectedTags: selectedTags,
          );
        },
        child: _TagsDialog(tagSelected: parameterProvider.toggleTopic),
      );
    },
  );
}

final class _TagsDialog extends StatelessWidget {
  final void Function(Tag) tagSelected;

  const _TagsDialog({required this.tagSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<TagsDialogProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Выберите тэги',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed:
                          () => Navigator.pop(context, provider.selectedTags),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              if (provider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.error!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.allTags.length,
                    itemBuilder: (context, index) {
                      final tag = provider.allTags[index];
                      final isSelected = provider.selectedTags.contains(tag);

                      return CheckboxListTile(
                        title: Text(tag.name),
                        value: isSelected,
                        onChanged: (_) {
                          provider.toggleTag(tag);
                          tagSelected(tag);
                        },
                      );
                    },
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.pop(context, provider.selectedTags),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Готово'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
