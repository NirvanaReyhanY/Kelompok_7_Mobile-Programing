import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/API/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              addNotes();
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
              controller: titleController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Title',
                // border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    print("$userId Ini Session");
    try {
      var response = await http.post(Uri.parse(ApiConnect.add), body: {
        "user_id": userId.toString(),
        "title": titleController.text,
        "notes": descriptionController.text,
        "date": DateTime.now().toString(),
      });

      if (response.statusCode == 201) {
        final Map<String, dynamic> notes = jsonDecode(response.body);
        print(response.body);
        if (notes['success'] == true) {
          Navigator.pushReplacementNamed(context, '/main-screen');
        }
      } else {
        // Handle response status code other than 200
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
