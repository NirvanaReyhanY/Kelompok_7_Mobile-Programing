import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/API/service.dart';
import 'package:notes/models/notes.dart';
import '../../widgets/note_card.dart';
import '../../widgets/search_input.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController _inputSearchController;
  late ServiceApiAktiv _serviceApiAktiv;
  List<Notes> _aktivitasList = [];

  @override
  void initState() {
    super.initState();
    _inputSearchController = TextEditingController();
    _serviceApiAktiv = ServiceApiAktiv();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Notes> data = await _serviceApiAktiv.getData();

      // Filter the notes based on the search query
      String query = _inputSearchController.text.toLowerCase();
      if (query.isNotEmpty) {
        data = data
            .where((note) =>
                note.title!.toLowerCase().contains(query) ||
                note.notes!.toLowerCase().contains(query) ||
                note.date!.toLowerCase().contains(query))
            .toList();
      }

      setState(() {
        _aktivitasList = data;
      });
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotesCard();
  }
}
