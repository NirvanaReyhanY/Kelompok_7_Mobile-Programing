import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../widgets/note_card.dart';
import '../../widgets/search_input.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController _inputSearchController;

  @override
  void initState() {
    super.initState();
    _inputSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchInput(
          controller: _inputSearchController,
          hint: 'Search notes',
          onChanged: (query) {
            log('search: $query');
          },
        ),
        Expanded(
          child: MasonryGridView.count(
            itemCount: 4,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => NoteCard(index: index),
          ),
        )
      ],
    );
  }
}
