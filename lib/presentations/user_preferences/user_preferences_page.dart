import 'package:flutter/material.dart';
import 'package:journal/presentations/user_preferences/user_preferences_provider.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

final class UserPreferencesPage extends StatelessWidget {
  const UserPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserPreferencesProvider(),
      child: const _UserPreferencesView(),
    );
  }
}

final class _UserPreferencesView extends StatelessWidget {
  const _UserPreferencesView();

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    final provider = context.watch<UserPreferencesProvider>();

    final error = provider.errorEvent?.value;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Не удалось сохранить данные, пожалуйста повторите позже',
              ),
            ),
          );
        }
      });
    }

    final navigateToHome = provider.navigateToHome?.value;
    if (navigateToHome != null) {
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, Routes.home);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Тэги',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: _bodyBuilder(context, provider),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:
              provider.isSubmitting || provider.selectedTags.isEmpty
                  ? null
                  : () => context.read<UserPreferencesProvider>().submit(),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                provider.isSubmitting ? Colors.grey : colorSchema.secondary,
            minimumSize: const Size.fromHeight(48),
          ),
          child:
              provider.isSubmitting
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    'Подтвердить',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorSchema.onSecondary,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _bodyBuilder(BuildContext context, UserPreferencesProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = provider.errorEvent?.value;

    if (provider.loadingErrorEvent != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? 'Произошла ошибка', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  () => context.read<UserPreferencesProvider>().fetchTags(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: TagButtonsList(),
    );
  }
}

final class TagButtonsList extends StatelessWidget {
  const TagButtonsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserPreferencesProvider>();
    final tags = provider.tags;
    final selectedTags = provider.selectedTags;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          tags.map((tag) {
            final isSelected = selectedTags.contains(tag);

            final colorSchema = Theme.of(context).colorScheme;

            return ChoiceChip(
              label: Text(tag.name),
              selected: isSelected,
              onSelected: (_) => provider.selectTag(tag),
              selectedColor: colorSchema.secondary,
              disabledColor: colorSchema.primary,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isSelected
                        ? colorSchema.onSecondary
                        : colorSchema.onPrimary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
    );
  }
}
