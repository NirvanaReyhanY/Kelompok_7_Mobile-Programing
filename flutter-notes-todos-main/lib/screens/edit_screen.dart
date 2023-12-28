import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/API/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StatefulWidget for editing and updating notes.
class EditScreen extends StatefulWidget {
  const EditScreen({
    Key? key,
    required this.noteId,
    required this.title,
    required this.notes,
    required this.date,
  }) : super(key: key);

  final String noteId;
  final String title;
  final String notes;
  final String date;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

// State class for EditScreen.
class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              editNotes();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteData(widget.noteId);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController..text = widget.title,
              maxLines: null,
              decoration: InputDecoration(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: descriptionController..text = widget.notes,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to edit and update notes.
  Future<void> editNotes() async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.edit), body: {
        "id": widget.noteId,
        "title": titleController.text.isNotEmpty
            ? titleController.text
            : widget.title,
        "notes": descriptionController.text.isNotEmpty
            ? descriptionController.text
            : widget.notes,
        "date": DateTime.now().toString(),
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> notes = jsonDecode(response.body);
        print(response.body);
        Navigator.pushReplacementNamed(context, '/main-screen');
        if (notes['success'] == true) {
          Navigator.pushReplacementNamed(context, '/main-screen');
        }
      } else {
        // Handle response status code other than 201
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Function to delete a note based on its ID.
  Future<void> deleteData(String? noteId) async {
    try {
      var response = await http.post(
        Uri.parse(ApiConnect.delete),
        body: {
          "id": noteId,
        },
      );

      if (response.statusCode == 200) {
        // Navigate to the main screen after successful deletion.
        Navigator.pushReplacementNamed(context, '/main-screen');
        print("Success");
      } else {
        throw Exception("Failed to delete data from the server");
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }
}
