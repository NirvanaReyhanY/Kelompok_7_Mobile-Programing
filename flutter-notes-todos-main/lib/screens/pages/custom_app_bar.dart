import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onChecklist;
  final VoidCallback onTrash;

  CustomAppBar({
    required this.onBack,
    required this.onChecklist,
    required this.onTrash,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.check),
          onPressed: onChecklist,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: onTrash,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
