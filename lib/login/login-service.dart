import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import corrected

// class LoginService {
//   late SharedPreferences prefs;
//   late String BaseURL;

  // Future<void> initialize() async {
  //   prefs = await SharedPreferences.getInstance();
  //   var baseURL = prefs.getString('url');
  //
  //   if (baseURL != null) {
  //     BaseURL = baseURL;
  //   }
  // }

  // LoginService() {
  //   initialize();
  // }

//   Future<dynamic> login(url, email, password) async {
//     prefs = await SharedPreferences.getInstance();
//     BaseURL = (await prefs.getString('url'))!;
//     if (BaseURL.isEmpty) {
//       throw Exception("BaseURL is not initialized.");
//     }
//
//     var fullUrl = BaseURL + '/Api/validate';
//
//     var body = jsonEncode({'username': email, 'password': password});
//
//     var response = await http.post(
//       Uri.parse(fullUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Accept': 'application/json; charset=UTF-8',
//       },
//       body: body,
//     );
//     return response;
//   }
// }
