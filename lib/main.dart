import 'package:flutter/material.dart';
import 'package:my_office_erp/bottom/about.dart';
import 'package:my_office_erp/bottom/contact.dart';
import 'package:my_office_erp/home/slide.dart';
import 'package:my_office_erp/login/ui/page.dart';
import 'package:my_office_erp/test/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'download/dcprint.dart';
import 'download/puchage print.dart';
import 'download/quatation print.dart';
import 'download/sales print.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 91, 67, 230),
          selectionColor: Color.fromARGB(255, 91, 67, 230),
          selectionHandleColor: Color.fromARGB(255, 91, 67, 230),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/home': (ctx) => const TabsScreen(),
        PurePage.routeName: (ctx) => const PurePage(),
        DesignPage.routeName: (ctx) => const DesignPage(),
        ReportPage.routeName: (ctx) => const ReportPage(),
        PrintPage.routeName: (ctx) => const PrintPage(),
        SlidePage.routeName: (ctx) => const SlidePage(),
        AboutPage.routeName: (ctx) => const AboutPage(),
        ContactPage.routeName: (ctx) => const ContactPage(),
        Vertical.routeName: (ctx) => const Vertical(),
        '/logout': (context) => const Vertical(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(context);
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await _checkLoggedIn(); // Use your actual login check logic
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('isLogging'));
    if (prefs.getString('isLogging')== null || prefs.getString('isLogging')== '') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Vertical()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabsScreen()),
      );
    }
  }

  Future<bool> _checkLoggedIn() async {
    // Your logic to check if the user is logged in
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Image.asset('assets/images/jkr.png'),
        ),
      ),
    );
  }
}