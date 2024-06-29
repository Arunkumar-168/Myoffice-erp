// import 'package:flutter/material.dart';
// import 'package:my_office_erp/login/login-service.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import corrected
// import '../home/slide.dart';
//
// class LoginController {
//   var loginservice = LoginService();
//     // Obtain shared preferences.
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   Future<dynamic> login(url, email, password, context) async {
//       // Save an integer value to 'counter' key.
//     await prefs.setString('url', url);
//     var response = await loginservice.login(url, email, password);
//
//     if (response.statusCode == 200) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const SlidePage()),
//       );
//     } else {
//       // If the server did not return a 201 CREATED response,
//       // then throw an exception.
//       throw Exception('Failed to create album.');
//     }
//     return response;
//   }
// }
//
// class LoginController {
//   final LoginService loginService = LoginService();
//
//   Future<void> login(
//       String url, String username, String password, BuildContext context) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('url', url);
//
//     var response = await loginService.login(url, username, password);
//
//     if (response.statusCode == 200) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const SlidePage()),
//       );
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to login.');
//     }
//   }
// }
