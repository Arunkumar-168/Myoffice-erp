import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/test/common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Vertical extends StatefulWidget {
  static const routeName = '/vertical';

  const Vertical({Key? key});

  @override
  _VerticalState createState() => _VerticalState();
}

class _VerticalState extends State<Vertical> {
  bool _isLoading = false;
  bool _showPassword = false;
  bool hidePassword = true;

  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with your default URL
    urlController.text = 'https://';
  }

  Future<void> submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Save the URL to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('url', urlController.text);

      // Perform login API request
      final response = await login(
        urlController.text,
        usernameController.text,
        passwordController.text,
      );

      if (response.statusCode == 200) {
        // Login successful, navigate to home page
        final results = response.body;
        final responseData = json.decode(response.body);
        if (responseData["result"] == "yes") {
          await prefs.setString('isLogging', "true");
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          CommonFunctions.showSuccessToast('Login Successful');
        } else {
          var errorMsg = 'Enter the Correct username and Password';
          CommonFunctions.showErrorDialog(errorMsg, context);
        }
      }
    } on HttpException {
      var errorMsg = 'Enter the Correct Password';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      // print("ERROR : $error");
      const errorMsg = 'Please Enter the correct Username and Password';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<http.Response> login(
      String url, String username, String password) async {
    var fullUrl = url + '/Api/validate';
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;

    var response = await http.post(
      Uri.parse(fullUrl),
      body: map,
    );
    print(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: SizedBox(
          height: height,
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 91, 67, 230),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Office ERP ',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'V',
                              style: TextStyle(
                                fontSize: 25, // Adjust the size of the "V"
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '1.1',
                              style: TextStyle(
                                fontSize: 18, // Adjust the size of "1.1"
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 700,
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/loginback.png',
                                // Corrected image path
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, right: 10),
                            child: Text(
                              'URL',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 17.0, right: 10),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: urlController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !value.startsWith('https://')) {
                                return 'Please enter a valid URL starting with "https://"';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Color.fromARGB(255, 91, 67, 230)),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 15),
                              prefixIcon: Icon(
                                Icons.link,
                                color: Color.fromARGB(255, 91, 67, 230),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, right: 10),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 17.0, right: 10),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: usernameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Color.fromARGB(255, 91, 67, 230),),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                              hintText: "Username",
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 15),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 91, 67, 230),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, right: 10),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 3) {
                                return 'Password should be more than 3 characters';
                              }
                              return null;
                            },
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(color: Color.fromARGB(255, 91, 67, 230),),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                              hintText: "password",
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 15),
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: Color.fromARGB(255, 91, 67, 230),
                              ),
                              suffixIcon: IconButton(
                                color: Color.fromARGB(255, 91, 67, 230),
                                icon: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 320,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 91, 67, 230),
                              ),
                              child: TextButton(
                                onPressed: submit,
                                child: Text(
                                  'Log In',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial black',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
