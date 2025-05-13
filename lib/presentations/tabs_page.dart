import 'package:flutter/material.dart';
import 'package:journal/presentations/bookmarks/bookmarks_page.dart';
import 'package:journal/presentations/profile/profile_page.dart';
import 'package:journal/presentations/routes.dart';

import 'package:journal/presentations/article/list/articles_list_page.dart';

final class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

final class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  static final _pages = [
    const ArticlesListPage(),
    const BookmarksPage(),
    const ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, Routes.articleCreateSandbox);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

