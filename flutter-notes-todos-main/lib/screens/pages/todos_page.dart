// Import necessary packages and files
import 'dart:developer';
import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/API/connect.dart';
import 'package:notes/models/notes.dart'; // Import model Notes
import 'package:notes/API/service.dart'; // Import service
import 'package:http/http.dart' as http;
import 'package:notes/screens/edit_screen.dart';
import '../../constants/color_scheme.dart';
import '../../widgets/search_input.dart';

// StatefulWidget representing the main page for displaying and managing todos.
class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

// State class for TodosPage.
class _TodosPageState extends State<TodosPage> {
  late TextEditingController _inputSearchController;
  late ServiceApiAktiv _serviceApiAktiv;
  List<Notes> _notesList = []; // List to store data

  @override
  void initState() {
    super.initState();
    _inputSearchController = TextEditingController();
    _serviceApiAktiv = ServiceApiAktiv();
    _loadData(); // Call _loadData function during initialization
  }

  // Function to load data based on search query
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
        _notesList = data;
      });
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SearchInput(
        controller: _inputSearchController,
        hint: 'Search todos',
        onChanged: (query) {
          _loadData();
        },
      ),
      Expanded(
          child: ListView.builder(
        itemCount: _notesList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final Notes note = _notesList[index];
          return Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                extentRatio: 0.18,
                motion: ScrollMotion(),
                children: [
                  InkWell(
                    onTap: () {
                      // Call deleteData method with the note's ID
                      deleteData(_notesList[index].id);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          'assets/icons/trash.svg',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(
                          noteId: note.id ?? '',
                          title: note.title ?? '',
                          notes: note.notes ?? '',
                          date: note.date ?? '',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => status(
                          note.id,
                          note.status == 'selesai'
                              ? 'belum'
                              : 'selesai', // Toggle the status
                        ),
                        child: SvgPicture.asset(
                          note.status == 'selesai'
                              ? 'assets/icons/todo-checked.svg'
                              : 'assets/icons/todo-unchecked.svg',
                          // Change the icon based on the note status
                          color: note.status == 'selesai'
                              ? whiteColor
                              : primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          note.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: note.status == 'selesai'
                                ? whiteColor
                                : blackColor,
                            fontWeight: note.status == 'selesai'
                                ? FontWeight.w400
                                : FontWeight.w600,
                            decoration: note.status == 'selesai'
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
      ))
    ]);
  }

  // Function to delete a note based on its ID
  Future<void> deleteData(String? noteId) async {
    try {
      var response = await http.post(
        Uri.parse(ApiConnect.delete),
        body: {
          "id": noteId,
        },
      );

      if (response.statusCode == 200) {
        // Remove the deleted note from the local list
        setState(() {
          _notesList.removeWhere((note) => note.id == noteId);
        });
        print("Success");
      } else {
        throw Exception("Failed to delete data from the server");
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  // Function to update the status of a note
  Future<void> status(String? noteId, String? statusup) async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.edit),
          body: {"id": noteId, "status": statusup.toString()});

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
}
