import 'dart:typed_data';

import 'package:flutter/material.dart';

final class AppCircleAvatar extends StatelessWidget {
  final String username;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final double radius;

  const AppCircleAvatar({
    super.key,
    required this.username,
    this.avatarUrl,
    this.avatarBytes,
    this.radius = 24,
  });

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
    ImageProvider? imageProvider;
    if (avatarUrl != null) {
      imageProvider = NetworkImage(avatarUrl!);
    } else if (avatarBytes != null) {
      imageProvider = MemoryImage(avatarBytes!);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor:
          imageProvider == null ? _getBackgroundColor(username) : null,
      backgroundImage: imageProvider,
      child:
          imageProvider == null
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
