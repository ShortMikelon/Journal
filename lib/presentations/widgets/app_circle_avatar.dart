import 'package:flutter/material.dart';

class AppCircleAvatar extends StatelessWidget {
  final String username;
  final String? avatarUrl;
  final double radius;

  const AppCircleAvatar({super.key, required this.username, this.avatarUrl, this.radius = 24});

  Color _getBackgroundColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarUrl == null ? _getBackgroundColor(username) : null,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child:
          avatarUrl == null
              ? Text(
                username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
              : null,
    );
  }
}
