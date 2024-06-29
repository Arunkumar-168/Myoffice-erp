import 'dart:async';
import 'package:flutter_application_1/profile/edit_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../online/custom_text.dart';
import '../search/auth.dart';
import 'account_list_tile.dart';
import 'edit_profile_screen.dart'; // Make sure to import EditProfileScreen if it's in a different file

class EditProfilePage extends StatefulWidget {
  static const routeName = '/edit-Page';
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription; // Ensure correct type declaration

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Color _getTextColor(Set<MaterialState> states) => states.any(<MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      }.contains)
          ? Colors.white
          : Colors.white;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).getUserInfo(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return _connectionStatus == ConnectivityResult.none
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .15,
                          ),
                          Image.asset(
                            "assets/images/login.png",
                            height: MediaQuery.of(context).size.height * .35,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //       return const DownloadedCourseList();
                                //     }));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    _getTextColor),
                              ),
                              icon: const Icon(Icons.download_done_rounded),
                              label: const Text(
                                'Play offline courses',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            Provider.of<Auth>(context, listen: false)
                                .logout()
                                .then((_) => Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (r) => false));
                          },
                        ),
                        // const Center(
                        //   child: Text('Error Occurred'),
                        // ),
                      ],
                    );
            } else {
              return Consumer<Auth>(
                builder: (context, authData, child) {
                  final user = authData.user;
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                NetworkImage(user.image.toString()),
                            backgroundColor: Colors.orange,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CustomText(
                              text: '${user.firstName} ${user.lastName}',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.1,
                                child: GestureDetector(
                                  child: const AccountListTile(
                                    titleText: 'Edit Profile',
                                    icon: Icons.account_circle,
                                    actionType: 'edit',
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(EditProfileScreen.routeName);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.1,
                                child: GestureDetector(
                                  child: const AccountListTile(
                                    titleText: 'Change Password',
                                    icon: Icons.vpn_key,
                                    actionType: 'change_password',
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        EditPasswordScreen.routeName);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.1,
                                child: GestureDetector(
                                  child: const AccountListTile(
                                    titleText: 'Log Out',
                                    icon: Icons.exit_to_app,
                                    actionType: 'logout',
                                  ),
                                  onTap: () async {
                                    // Get the Auth provider
                                    final auth = Provider.of<Auth>(context,
                                        listen: false);

                                    // Access SharedPreferences
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    // Clear the 'isLogging' key
                                    await prefs.setString('isLogging', '');
                                    // Perform logout
                                    await auth.logout();
                                    // Navigate to the login screen and remove all previous routes
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/login', (route) => false);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
