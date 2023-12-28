import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/API/connect.dart';
import 'package:notes/constants/color_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/route_names.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  @override
  void initState() {
    super.initState();
    addUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/icons/splash.svg'),
      ),
    );
  }

  Future<void> addUser() async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.adduser));

      if (response.statusCode == 201) {
        final Map<String, dynamic> user = jsonDecode(response.body);
        print(response.body);
        if (user['success'] == true) {
          final int userId = user['data']['userId'];
          print(user);

          // Coba menyimpan ID user ke dalam session manager
          bool saveSuccess = await saveUserId(userId);

          if (saveSuccess) {
            // Jika penyimpanan berhasil, lanjutkan dengan navigasi
            Navigator.pushReplacementNamed(context, '/main-screen');

            // Print hasil setelah berhasil menyimpan ke session manager
            print("User ID berhasil disimpan di SharedPreferences: $userId");
          } else {
            // Handle penyimpanan gagal jika diperlukan
            print("Failed to save user_id to SharedPreferences");
          }
        }
      } else {
        // Handle response status code other than 200
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> saveUserId(int userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      return true; // Penyimpanan berhasil
    } catch (e) {
      print("Error saving user_id to SharedPreferences: $e");
      return false; // Penyimpanan gagal
    }
  }
}
