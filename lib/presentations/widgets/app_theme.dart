import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class AppTheme extends StatelessWidget {
  final Widget child;

  const AppTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: theme.primaryColor,
      systemNavigationBarColor: theme.primaryColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }
}