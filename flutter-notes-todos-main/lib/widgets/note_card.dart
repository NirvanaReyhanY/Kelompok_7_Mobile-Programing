import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/API/connect.dart';
import 'package:notes/API/service.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/screens/edit_screen.dart';
import 'package:notes/widgets/search_input.dart';
import '../constants/color_scheme.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

// StatefulWidget for displaying notes in a staggered grid view.
class NotesCard extends StatefulWidget {
  const NotesCard({Key? key}) : super(key: key);

  @override
  State<NotesCard> createState() => _NotesCardState();
}

// State class for NotesCard.
class _NotesCardState extends State<NotesCard> {
  late ServiceApiAktiv _serviceApiAktiv;
  late TextEditingController _inputSearchController;
  List<Notes> _notesList = [];
  late Timer _debounce;

  @override
  void initState() {
    super.initState();
    _inputSearchController = TextEditingController();
    _serviceApiAktiv = ServiceApiAktiv();
    _debounce = Timer(Duration(milliseconds: 500), () {});
    _loadData();
  }

  // Function to load notes data with debounce for search input.
  Future<void> _loadData() async {
    try {
      // Clear existing debounce timer
      if (_debounce.isActive) _debounce.cancel();

      // Set up a new debounce timer
      _debounce = Timer(Duration(milliseconds: 500), () async {
        List<Notes> data = await _serviceApiAktiv.getData();

        // Filter the notes based on the search query
        String query = _inputSearchController.text.toLowerCase();
        if (query.isNotEmpty) {
          data = data
              .where((notes) =>
                  notes.title!.toLowerCase().contains(query) ||
                  notes.notes!.toLowerCase().contains(query) ||
                  notes.date!.toLowerCase().contains(query))
              .toList();
        }

        setState(() {
          _notesList = data;
        });
      });
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  @override
  void dispose() {
    // Cancel the debounce timer when the widget is disposed
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search input widget
        SearchInput(
          controller: _inputSearchController,
          hint: 'Search todos',
          onChanged: (query) {
            _loadData();
          },
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: _notesList.length,
            itemBuilder: (context, index) {
              // Individual note widget
              Notes notes = _notesList[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the edit screen when a note is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        noteId: notes.id ?? '',
                        title: notes.title ?? '',
                        notes: notes.notes ?? '',
                        date: notes.date ?? '',
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Note title
                      Text(
                        notes.title ?? 'Title',
                        style: TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Note description
                      Text(
                        notes.notes ?? 'No description available',
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: lightGreyColor),
                      ),
                      const SizedBox(height: 16),
                      // Note date
                      Text(
                        notes.date ?? 'May 05, 2022',
                        style: TextStyle(
                          fontSize: 12,
                          color: lightGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
