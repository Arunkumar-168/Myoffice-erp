import 'package:flutter_application_1/course/my_courses.dart';
import 'package:flutter_application_1/online/abc.dart';
import 'package:flutter_application_1/profile/edit_password_screen.dart';
import 'package:flutter_application_1/profile/edit_profile_screen.dart';
import 'package:flutter_application_1/profile/forgot_password_screen.dart';
import 'package:flutter_application_1/profile/login.dart';
import 'package:flutter_application_1/profile/signup.dart';
import 'package:flutter_application_1/profile/verification_screen.dart';
import 'package:flutter_application_1/search/Dynamic.dart';
import 'package:flutter_application_1/search/auth.dart';
import 'package:flutter_application_1/search/categories.dart';
import 'package:flutter_application_1/search/misc_provider.dart';
import 'package:flutter_application_1/search/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'Pref/courses_screen.dart';
import 'Pref/temp_view_screen.dart';
import 'Video/chip.dart';
import 'course/courses.dart';
import 'course/my_course_detail_screen.dart';
import 'coursedetails/webview_screen.dart';
import 'coursedetails/webview_screen_iframe.dart';
import 'models/sub_category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses([], []),
          update: (ctx, auth, prevoiusCourses) => Courses(
            prevoiusCourses == null ? [] : prevoiusCourses.items,
            prevoiusCourses == null ? [] : prevoiusCourses.topItems,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          create: (ctx) => MyCourses([], []),
          update: (ctx, auth, previousMyCourses) => MyCourses(
            previousMyCourses == null ? [] : previousMyCourses.items,
            previousMyCourses == null ? [] : previousMyCourses.sectionItems,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Languages(),
        ),
      ],child: Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.orange,
              selectionColor: Colors.orange,
              selectionHandleColor: Colors.orange,
            ),
          ),
          debugShowCheckedModeBanner: false,
         home:  SplashScreen(),
        navigatorObservers: [
          VdoPlayerController.navigatorObserver('/player/(.*)')
        ],
          routes: {
            '/home': (ctx) => const TabsScreen(),
            SearchWidget.routeName: (ctx) => SearchWidget(),
            VdoPlaybackView.routeName: (ctx) =>const VdoPlaybackView(),
            ForgotPassword.routeName: (ctx) => const ForgotPassword(),
            loginpage.routeName: (ctx) => const loginpage(),
            SignupPage.routeName: (ctx) => const SignupPage(),
            CoursesScreen.routeName: (ctx) => const CoursesScreen(),
            CourseDetailScreen.routeName: (ctx) => const CourseDetailScreen(),
            MyCourseDetailScreen.routeName: (ctx) => const MyCourseDetailScreen(),
            TempViewScreen.routeName: (ctx) => const TempViewScreen(),
            WebViewScreen.routeName: (ctx) =>  WebViewScreen(),
            WebViewScreenIframe.routeName: (ctx) => WebViewScreenIframe(),
            EditPasswordScreen.routeName: (ctx) => const EditPasswordScreen(),
            EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
            VerificationScreen.routeName: (ctx) => const VerificationScreen(),
            SubCategoryScreen.routeName: (ctx) => const SubCategoryScreen(),
         },
        ),
      ),
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
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('isLogging') == null ||
        prefs.getString('isLogging') == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const loginpage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Image.asset('assets/images/osj.png'),
        ),
      ),
    );
  }
}































