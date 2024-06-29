import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_office_erp/bottom/about.dart';
import 'package:my_office_erp/bottom/contact.dart';
import 'package:my_office_erp/bottom/support.dart';
import 'package:my_office_erp/home/slide.dart';
import 'package:my_office_erp/login/ui/page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TabsScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  bool isLoading = false;
  final List<Widget> _pages = const [
    SlidePage(),
    ContactPage(),
    AboutPage(),
    SupportPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }
  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });
    // Simulate fetching data
    await Future.delayed(Duration(seconds: 2));

    // After fetching data, set isLoading to false
    setState(() {
      isLoading = false;
    });
  }
  Future<void> _logout(BuildContext context) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'login');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('isLogging', '');
      // print(prefs.getString('isLogging'));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Vertical()),
            (route) => false,
      );
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color.fromARGB(255, 91, 67, 230),
        color: const Color.fromARGB(255, 91, 67, 230),
        animationDuration: const Duration(milliseconds: 700),
        height: 50,
        items:const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 20, color: Colors.white),
              Text('Home',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call, size: 20, color: Colors.white),
              Text('Call',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 20, color: Colors.white),
              Text('Support',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 20, color: Colors.white),
              Text('Info',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20, color: Colors.white),
              Text('Logout',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13)),
            ],
          ),
        ],
        onTap: (index) {
          if (index == 4) {
            _logout(context); // Handle logout action
            return;
          }
          setState(() {
            _selectedIndex = index; // Update selected index for page navigation
          });
        },

      ),
    );
  }
}