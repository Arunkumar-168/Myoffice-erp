import 'dart:async';
import 'package:flutter_application_1/profile/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class logoutpage extends StatefulWidget {
  static const routeName = '/logout';
  const logoutpage({Key? key}) : super(key: key);
  @override
  _logoutpageState createState() => _logoutpageState();
}

class _logoutpageState extends State<logoutpage> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;// Ensure correct type declaration

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
  Color _getTextColor(Set<MaterialState> states) =>
      states.any(<MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      }.contains)
          ? Colors.orangeAccent
          : Colors.orange;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  _connectionStatus == ConnectivityResult.none
          ? Center(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * .22),
            Image.asset(
              "assets/images/dd.png",
              height: MediaQuery.of(context).size.height * .27,
            ),
            // const Padding(
            //   padding: EdgeInsets.all(4.0),
            //   child: Text('There is no Internet connection'),
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(4.0),
            //   child: Text('Please check your Internet connection'),
            // ),
          ],
        ),
      )
          : Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * .35,
          ),
          Center(
            child: Image.asset(
              'assets/images/login_forget.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * .27,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(loginpage.routeName);
              },
              child: const Text(
                'Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Colors.orange,
              textColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
                // side: const BorderSide(color: kRedColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

