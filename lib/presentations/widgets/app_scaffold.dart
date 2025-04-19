import 'package:flutter/material.dart';

import 'app_theme.dart';

final class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffold({super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return AppTheme(
        child: Scaffold(
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        )
    );
  }
}