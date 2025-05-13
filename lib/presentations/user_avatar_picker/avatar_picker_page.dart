import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import 'avatar_picker_provider.dart';

final class AvatarPickerPage extends StatelessWidget {
  const AvatarPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvatarPickerProvider(),
      child: const _AvatarPickerView(),
    );
  }
}

final class _AvatarPickerView extends StatelessWidget {
  const _AvatarPickerView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AvatarPickerProvider>();
    final navEvent = provider.navigateToNextPageEvent?.value;
    final error = provider.errorEvent?.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navEvent == true) {
        Navigator.pushReplacementNamed(context, Routes.userPreferences);
      }

      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    });

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
          'Выбор аватарки',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        )),
      ),
      body: Center(
        child: GestureDetector(
          onTap: provider.pickImage,
          child: Container(
            padding: const EdgeInsets.all(4), // пространство под рамку
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 160,
              backgroundImage:
                  provider.selectedImage != null
                      ? FileImage(provider.selectedImage!)
                      : null,
              child:
                  provider.selectedImage == null
                      ? const Icon(Icons.add_a_photo, size: 64)
                      : null,
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ElevatedButton(
          onPressed: provider.isLoading ? null : () => provider.submit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: Text(
            provider.selectedImage != null ? 'Сохранить' : 'Пропустить',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
