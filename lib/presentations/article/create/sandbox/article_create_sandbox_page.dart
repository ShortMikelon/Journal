import 'package:flutter/material.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

import 'article_create_sandbox_provider.dart';

final class ArticleCreateSandboxPage extends StatelessWidget {
  final int draftArticleId;

  const ArticleCreateSandboxPage({super.key, required this.draftArticleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ArticleCreateSandboxProvider(
            draftArticleId: draftArticleId,
            userSettings: DomainDi().userSettings,
            draftArticlesRepository: DataDi().draftArticleRepository,
          ),
      child: AppScaffold(body: const _ArticleCreateSandboxBody()),
    );
  }
}

final class _ArticleCreateSandboxAppBar extends StatelessWidget {
  const _ArticleCreateSandboxAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 5.0,
      floating: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        TextButton(
          onPressed:
              () =>
                  context
                      .read<ArticleCreateSandboxProvider>()
                      .navigateToParameters(),
          child: Text(
            "Перейти к параметрам",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

final class _ArticleCreateSandboxBody extends StatelessWidget {
  const _ArticleCreateSandboxBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleCreateSandboxProvider>(
      builder: (context, provider, _) {
        final snackBarMessage = provider.showSnackBarEvent?.value;
        if (snackBarMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snackBarMessage),
                duration: Duration(seconds: 1),
              ),
            );
          });
        }

        final draftId = provider.navigateToParametersEvent?.value;
        if (draftId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(
              context,
              Routes.articleCreateParameter,
              arguments: draftId,
            );
          });
        }

        return CustomScrollView(
          slivers: [
            const _ArticleCreateSandboxAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: provider.titleController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintText: 'Заголовок статьи',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(provider.bodyComponents.length, (index) {
                      return TextField(
                        controller:
                            provider.bodyComponents
                                .firstWhere(
                                  (component) => component.order == index + 1,
                                )
                                .controller,
                        focusNode:
                            provider.bodyComponents
                                .firstWhere(
                                  (component) => component.order == index + 1,
                                )
                                .focusNode,
                        decoration: InputDecoration(
                          hintText: 'Введите текст...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => provider.addNewTextField(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
