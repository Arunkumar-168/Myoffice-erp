import 'dart:io';
import 'package:flutter_application_1/profile/user_image_picker.dart';
import 'package:flutter_application_1/search/tabs_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/constants.dart';
import '../course/common_functions.dart';
import '../models/user.dart';
import '../search/auth.dart';
import 'package:country_picker/country_picker.dart';



class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();


  bool _isLoading = false;

  final Map<String, String> _userData = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'bio': '',
    'twitter': '',
    'facebook': '',
    'linkedin': '',
  };

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _accanumberController = TextEditingController();
  final _icnumberController = TextEditingController();
  final _passportController = TextEditingController();
  final _whatappController = TextEditingController();

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
      // Log user in
      // print(_userData['first_name']);
      final updateUser = User(
        userId: 'Temp',
        firstName: _userData['first_name'],
        lastName: _userData['last_name'],
        email: _userData['email'],
        role: 'Temp',
        biography: _userData['bio'],
        twitter: _userData['twitter'],
        facebook: _userData['facebook'],
        linkedIn: _userData['linkedin'],
      );
      await Provider.of<Auth>(context, listen: false)
          .updateUserData(updateUser);
      CommonFunctions.showSuccessToast('User updated Successfully');
    } on HttpException {
      var errorMsg = 'Update failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      // print(error);
      const errorMsg = 'Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );


  InputDecoration getInputDecoration(String hintext, IconData iconData,{double iconSize = 1.0}) {
    return InputDecoration(
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: const TextStyle(color: kFormInputColor),
      hintText: hintext,
      fillColor: Colors.white70,
      prefixIcon: Icon(
        iconData,
        color: kFormInputColor,
        // color:Colors.orange,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    _whatappController.selection = TextSelection.fromPosition(
      TextPosition(offset: _whatappController.text.length),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(TabsScreen.routeName);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/dd.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).getUserInfo(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          } else {
            return Consumer<Auth>(
              builder: (context, authData, child) {
                final user = authData.user;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Padding(
                      //   padding:
                      //   EdgeInsets.only(left: 80, top: 10, bottom: 5.0),
                      //   child: Text(
                      //     'Update Profile Picture',
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: UserImagePicker(
                          image: user.image,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, bottom: 5.0),
                                    child: Text(
                                      'First Name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    initialValue: user.firstName,
                                    decoration: getInputDecoration(
                                        'First Name', Icons.person),
                                    keyboardType: TextInputType.name,
                                    // controller: _firstNameController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Your First name';
                                      }
                                    },
                                    onSaved: (value) {
                                      _userData['first_name'] =
                                          value.toString();
                                      _firstNameController.text =
                                      value as String;
                                    },
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Last Name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    initialValue: user.lastName,
                                    decoration: getInputDecoration(
                                      'Last Name',
                                      Icons.person,
                                    ),
                                    keyboardType: TextInputType.name,
                                    // controller: _lastNameController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Your Last name';
                                      }
                                    },
                                    onSaved: (value) {
                                      _userData['last_name'] =
                                          value.toString();
                                      _lastNameController.text =
                                      value as String;
                                    },
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    initialValue: user.email,
                                    decoration: getInputDecoration(
                                      'Email',
                                      Icons.email,
                                    ),
                                    // controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (input) =>
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(input!)
                                        ? "Enter Your Email"
                                        : null,
                                    onSaved: (value) {
                                      _userData['email'] = value.toString();
                                      _emailController.text = value as String;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'ACCA Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    cursorColor: Colors.orange,
                                    decoration: getInputDecoration(
                                        'ACCA Number', FontAwesomeIcons.message,
                                        iconSize: 1.0),
                                    // Specify the desired icon size
                                    keyboardType: TextInputType.name,
                                    controller: _accanumberController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Your ACCA Number';
                                      }
                                    },
                                    onSaved: (value) {
                                      // _authData['email'] = value.toString();
                                      _accanumberController.text = value as String;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'IC Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    cursorColor: Colors.orange,
                                    decoration: getInputDecoration(
                                        'IC Number', FontAwesomeIcons.message),
                                    keyboardType: TextInputType.phone,
                                    controller: _icnumberController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter your IC Number';
                                      }
                                    },
                                    onSaved: (value) {
                                      // _authData['icnumber'] = value.toString();
                                      _icnumberController.text = value as String;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Passport Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    cursorColor: Colors.orange,
                                    decoration: getInputDecoration(
                                        'Passport Number', FontAwesomeIcons.passport),
                                    keyboardType: TextInputType.name,
                                    controller: _passportController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Your Passport Number';
                                      }
                                    },
                                    onSaved: (value) {
                                      // _authData['email'] = value.toString();
                                      _passportController.text = value as String;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Whats App Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _whatappController,
                                    onChanged: (value) {
                                      setState(() {
                                        // No code here, as the onChanged callback is not used
                                      });
                                    },
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Enter your Whats App number';
                                      } else if (value?.length != 10) {
                                        return 'Mobile number must be 10 digits';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _whatappController.text = value ?? '';
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Whats App Number",
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                        borderSide: BorderSide(color: Colors.white, width: 2),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                        borderSide: BorderSide(color: Colors.orange, width: 2),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            showCountryPicker(
                                              context: context,
                                              countryListTheme: const CountryListThemeData(
                                                bottomSheetHeight: 550,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0),
                                                ),
                                              ),
                                              onSelect: (value) {
                                                setState(() {
                                                  selectedCountry = value;
                                                });
                                              },
                                            );
                                          },
                                          child: Text(
                                            "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      suffixIcon: _whatappController.text.length > 9
                                          ? Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.amber,
                                        ),
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )
                                          : null,
                                    ),
                                  ),
                                ), const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Biography',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  initialValue: user.biography,
                                  decoration: getInputDecoration(
                                    'Biography',
                                    Icons.edit,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  onSaved: (value) {
                                    _userData['bio'] = value.toString();
                                  },
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Facebook Link',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  initialValue: user.facebook,
                                  decoration: getInputDecoration(
                                    'Facebook Link',
                                    MdiIcons.facebook,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) {
                                    _userData['facebook'] = value.toString();
                                  },
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Twitter Link',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  initialValue: user.twitter,
                                  decoration: getInputDecoration(
                                    'Twitter Link',
                                    MdiIcons.twitter,

                                  ),
                                  keyboardType: TextInputType.emailAddress,

                                  onSaved: (value) {
                                    _userData['twitter'] = value.toString();
                                  },
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'LinkedIn Link',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  initialValue: user.linkedIn,
                                  decoration: getInputDecoration(
                                    'LinkedIn Link',
                                    MdiIcons.linkedin,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) {
                                    _userData['linkedin'] = value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : MaterialButton(
                                    onPressed: _submit,
                                    child: const Text(
                                      'Update Now',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.orange,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    splashColor: Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(7.0),
                                      side: const BorderSide(
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),

    );
  }
}
