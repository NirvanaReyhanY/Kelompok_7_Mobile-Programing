import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:notes/API/connect.dart';
import 'package:notes/models/notes.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// This class provides a simplified version of the service API for retrieving notes data.
class ServiceApiAktiv {
  // Asynchronously retrieves data from the API.
  Future getData() async {
    // Retrieve user ID from SharedPreferences for API authentication.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    print("$userId Ini Session");
    try {
      // Send a POST request to the API to fetch notes data.
      final response = await http.post(Uri.parse(ApiConnect.notes), body: {
        "id": userId.toString(),
      });

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a list of Notes objects.
        print(response.body);
        Iterable it = jsonDecode(response.body);
        List<Notes> notesList = it.map((e) => Notes.fromJson(e)).toList();
        print(notesList);
        return notesList;
      }
    } catch (e) {
      // Handle any errors that occur during the API request.
      print(e.toString());
    }
  }
}
