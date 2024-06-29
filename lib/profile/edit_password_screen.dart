import 'dart:io';
import 'package:flutter_application_1/api/constants.dart';
import 'package:flutter_application_1/search/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../course/common_functions.dart';

class EditPasswordScreen extends StatefulWidget {
  static const routeName = '/edit-password';
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  var _isLoading = false;
  final Map<String, String> _passwordData = {
    'oldPassword': '',
    'newPassword': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });


    try {
      await Provider.of<Auth>(context, listen: false).updateUserPassword(
        _passwordData['oldPassword'].toString(),
        _passwordData['newPassword'].toString(),
      );
      CommonFunctions.showSuccessToast('Password updated Successfully');
      // Navigate to home page
      Navigator.of(context).pushReplacementNamed('/home');  // Replace '/home' with your actual home route name
    } on HttpException {
      var errorMsg = 'Enter your Current Password';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Enter your Current Password';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintText, IconData icon, Widget? suffixIcon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: const TextStyle(color: kFormInputColor),
      fillColor: Colors.white70,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/dd.png',
              height: 200, // Adjust the height as needed
              width: 200, // Adjust the width as needed
            ),
          ],
        ),
      ),
      // Replace with your background color
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Update Password',
                  style: TextStyle(
                    color: Colors.black, // Replace with your text color
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'Current Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      obscureText: !_currentPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.black12, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.orange, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        hintText: 'Current password',
                        prefixIcon: Icon(Icons.vpn_key,
                            color: kFormInputColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _currentPasswordVisible = !_currentPasswordVisible;
                            });
                          },
                          icon: Icon(
                            color: kTextLowBlackColor,
                            _currentPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Your Current Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordData['oldPassword'] = value.toString();
                      },
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      controller: _passwordController,
                      obscureText: !_newPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.black12, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.orange, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        hintText: 'New password',
                        prefixIcon: Icon(Icons.vpn_key,
                          color: kFormInputColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                          icon: Icon(
                            color: kTextLowBlackColor,
                            _newPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Your new password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordData['newPassword'] = value.toString();
                      },
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.black12, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.orange, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        hintText: 'Confirm password',
                        prefixIcon: Icon(Icons.vpn_key,
                          color: kFormInputColor,),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                          icon: Icon(
                            color: kTextLowBlackColor,
                            _confirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Your Confirm Password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Update Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.orange, // Replace with your button color
                        textColor: Colors.white, // Replace with your text color
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        splashColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          side: const BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
