import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/search/update_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pref/SharedPreferenceHelper.dart';
import '../api/constants.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  User _user =
      User(userId: '', firstName: '', lastName: '', email: '', role: '',image: '');

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  User get user {
    return _user;
  }

  Future<void> login(String email, String password) async {
    var url = BaseURL + 'login?email=$email&password=$password';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      if (responseData['validity'] == 0) {
        throw const HttpException('Auth Failed');
      }
      _token = responseData['token'];
      _userId = responseData['user_id'];
      final loadedUser = User(
        userId: responseData['user_id'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        email: responseData['email'],
        role: responseData['role'],
      );
      _user = loadedUser;
      notifyListeners();
      await SharedPreferenceHelper().setAuthToken(_token!);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user_id': _userId,
        'user': jsonEncode(_user),
      });
      prefs.setString('userData', userData);
      print('Login Token ${_token}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getUserInfo() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BaseURL + 'userdata?auth_token=$authToken';
    try {
      if (authToken == null) {
        throw const HttpException('No Auth User');
      }
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      _user.firstName = responseData['first_name'];
      _user.lastName = responseData['last_name'];
      _user.email = responseData['email'];
      _user.image = responseData['image'];
      _user.facebook = responseData['facebook'];
      _user.twitter = responseData['twitter'];
      _user.linkedIn = responseData['linkedin'];
      _user.biography = responseData['biography'];
      // print(_user.image);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<UpdateUserModel> signUp(
      String firstName,
      String lastName,
      String email,
      String password,
      String accaNumber,
      String icNumber,
      String passportNumber,
      String whatsappNumber) async {
    const String apiUrl = BaseURL + "signup";
    final response = await http.post(Uri.parse(apiUrl), body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'accanumber': accaNumber,
      'icnumber': icNumber,
      'passportnumber': passportNumber,
      'whatsappnumber': whatsappNumber,
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return updateUserModelFromJson(responseString);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<void> logout() async {
  //   _token = null;
  //   // _user = null;
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove('userData');
  //   prefs.clear();
  // }

  Future<void> logout() async {
    _token = '';
    _userId = null;
    _user = User(userId: '', firstName: '', lastName: '', email: '', role: '');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user_id');
    prefs.remove('userData');
    prefs.clear();
    // Remove user data but do not clear the entire prefs
  }

  Future<void> userImageUpload(File image) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    var url = BaseURL + 'upload_user_image';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.fields['auth_token'] = token!;

    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), image.lengthSync(),
        filename: basename(image.path)));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          final responseData = json.decode(value);
          if (responseData['status'] != 'success') {
            throw const HttpException('Upload Failed');
          }
          notifyListeners();
          // print(value);
        });
      }

      // final responseData = json.decode(response.body);
    } catch (error) {
      rethrow;
    }
  }


  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    const url = BaseURL + 'update_password';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );

      final responseData = json.decode(response.body);
      print("Response : ${response.body}");
      if (responseData['status'] == 'failed') {
        throw const HttpException('Password update Failed');
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<void> updateUserData(User user) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    const url = BaseURL + 'update_userdata';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'biography': user.biography,
          'twitter_link': user.twitter,
          'facebook_link': user.facebook,
          'linkedin_link': user.linkedIn,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw const HttpException('Update Failed');
      }

      _user.firstName = responseData['first_name'];
      _user.lastName = responseData['last_name'];
      _user.email = responseData['email'];
      _user.image = responseData['image'];
      _user.twitter = responseData['twitter'];
      _user.linkedIn = responseData['linkedin'];
      _user.biography = responseData['biography'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }


}
