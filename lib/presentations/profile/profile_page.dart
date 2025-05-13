import 'package:flutter/material.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/presentations/profile/profile_provider.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_circle_avatar.dart';
import 'package:journal/presentations/widgets/article_list_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(
        userSettings: DomainDi().userSettings,
        articlesRepository: DataDi().articlesRepository,
        draftArticlesRepository: DataDi().draftArticleRepository,
        usersRepository: DataDi().usersRepository,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          if (profileProvider.isLoading) {
            return _buildShimmer(); 
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                snap: false,
                expandedHeight: 80,
                flexibleSpace: Align(
                  alignment: const Alignment(-1.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

              ),
              SliverToBoxAdapter(
                child: ListTile(
                  leading: AppCircleAvatar(
                    // radius: 40,
                    username: profileProvider.username,
                    avatarBytes: profileProvider.avatarBytes,
                  ),
                  title: Text(
                    profileProvider.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "${profileProvider.followers} Followers · ${profileProvider.following} Following",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 35)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            "View stats",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Edit your profile",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: _TabSelector(
                  selected: profileProvider.selected,
                  postFilterOnChanged: profileProvider.postFilterOnChanged,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: _ArticlesOrDraftList(
                  selectedFilter: profileProvider.selected,
                  articles: profileProvider.articles,
                  drafts: profileProvider.drafts,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                    ),
                    title: Container(height: 12, color: Colors.white),
                    subtitle: Container(
                      height: 12,
                      margin: const EdgeInsets.only(top: 4),
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container(height: 40, color: Colors.white)),
                      const SizedBox(width: 10),
                      Expanded(child: Container(height: 40, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 30, color: Colors.white),
                  const SizedBox(height: 50),
                  Container(height: 12, width: 150, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class _TabSelector extends StatelessWidget {
  final PostFilter selected;
  final void Function(PostFilter?) postFilterOnChanged;

  final Map<PostFilter, String> _labels = {
    PostFilter.public: 'Public',
    PostFilter.draft: 'Draft',
  };

  _TabSelector({required this.selected, required this.postFilterOnChanged});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'Stories'),
              Tab(text: 'Lists'),
              Tab(text: 'About'),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PostFilter>(
                    value: selected,
                    isExpanded: false,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: postFilterOnChanged,
                    items:
                        PostFilter.values.map((filter) {
                          return DropdownMenuItem<PostFilter>(
                            value: filter,
                            child: Row(
                              children: [
                                Text(_labels[filter]!),
                                if (selected == filter) ...[
                                  const SizedBox(width: 6),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticlesOrDraftList extends StatelessWidget {
  final PostFilter selectedFilter;
  final List<DraftArticle> drafts;
  final List<ArticleListPreviewEntity> articles;

  const _ArticlesOrDraftList({
    required this.selectedFilter,
    required this.drafts,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedFilter) {
      case PostFilter.public:
        return articles.isEmpty
            ? const Text("You don’t have any public posts.")
            : ListView.separated(
              shrinkWrap: true,
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
                  child: ArticleListCard(
                    title: article.title,
                    subtitle: article.subtitle,
                    date: article.createdAt,
                    likes: article.likes,
                    authors: article.authors,
                    comments: article.comments,
                    imageBytes: article.imageBytes,
                  ),
                );
              },
            );
      case PostFilter.draft:
        return drafts.isEmpty
            ? const Text("You don’t have any drafts.")
            : ListView.separated(
              shrinkWrap: true,
              itemCount: drafts.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final draft = drafts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.articleCreateSandbox,
                      arguments: draft.id,
                    );
                  },
                  child: ListTile(
                    title: Text(draft.title),
                    subtitle: Text(draft.subtitle),
                  ),
                );
              },
            );
    }
  }
}

enum PostFilter { public, draft }

// final class _DraftArticleListCard extends StatelessWidget {
//   final DraftArticle draft;
//
//   const _DraftArticleListCard({
//     required this.draft,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 6),
//             _AuthorInfo(author: draft.author, avatarBytes: authorAvatarBytes),
//             const SizedBox(height: 12),
//             _ArticleTitle(title: draft.title),
//             const SizedBox(height: 8),
//             _ArticleSubtitle(subtitle: subtitle),
//             const SizedBox(height: 26),
//             _ArticleStats(date: date, likes: likes, comments: comments),
//             const SizedBox(height: 6),
//           ],
//         ),
//       ),
//     );
//   }
// }
