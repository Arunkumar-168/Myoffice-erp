import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pref/filter_widget.dart';
import 'package:flutter_application_1/home/slide.dart';
import 'package:flutter_application_1/profile/edit.dart';
import 'package:flutter_application_1/profile/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/constants.dart';
import '../course/my_courses_screen.dart';
import '../course/my_wishlist_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  List<Widget> _pages = [
    const HomeScreen(),
    logoutpage(),
    logoutpage(),
    logoutpage(),
  ];

  int _selectedPageIndex = 0;
  var _isInit = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      bool _isAuth;
      dynamic userData;
      dynamic response;
      dynamic token;
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = (prefs.getString('userData') ?? '');
      });
      if (userData != null && userData.isNotEmpty) {
        response = json.decode(userData);
        token = response['token'];
      }
      if (token != null && token.isNotEmpty) {
        _isAuth = true;
      } else {
        _isAuth = false;
      }

      if (_isAuth) {
        _pages = [
          const HomeScreen(),
          const MyCoursesScreen(),
          MyWishlistScreen(),
          EditProfilePage(),
        ];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }


  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return const FilterWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterModal(context),
        child: const Icon(Icons.filter_list,color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.brown,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'My Course',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}