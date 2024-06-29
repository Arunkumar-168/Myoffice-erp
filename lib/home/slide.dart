import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pref/courses_screen.dart';
import '../api/constants.dart';
import '../course/common_functions.dart';
import '../course/courses.dart';
import '../coursedetails/category_list_item.dart';
import '../coursedetails/course_grid.dart';
import '../search/Dynamic.dart';
import '../search/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var topCourses = [];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //_startTimer();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Courses>(context).fetchTopCourses().then((_) {
        setState(() {
          _isLoading = false;
          topCourses = Provider.of<Courses>(context, listen: false).topItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();

      setState(() {
        _isLoading = false;
        topCourses = Provider.of<Courses>(context, listen: false).topItems;
      });
    } catch (error) {
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/dd.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        'assets/images/search.png',
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchWidget(),
                          ),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Provider.of<Categories>(context, listen: false)
                .fetchCategories(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                );
              } else if (dataSnapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .15),
                      // Image.asset(
                      //   "assets/images/no_connection.png",
                      //   height: MediaQuery.of(context).size.height * .35,
                      // ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: [
                              Image.asset('assets/images/cc.png',
                                  fit: BoxFit.cover),
                              Image.asset('assets/images/dcb.png',
                                  fit: BoxFit.cover),
                              Image.asset('assets/images/gft.png',
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Top Course',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  CoursesScreen.routeName,
                                  arguments: {
                                    'category_id': null,
                                    'search_query': null,
                                    'type': CoursesPageData.All,
                                  },
                                );
                              },
                              child: Row(
                                children: const [
                                  Text('All courses'),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(0),
                            )
                          ],
                        ),
                      ),
                      _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      )
                          : Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 280.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return CourseGrid(
                              id: topCourses[index].id,
                              title: topCourses[index].title,
                              level: topCourses[index].level,
                              thumbnail: topCourses[index].thumbnail,
                              rating: topCourses[index].rating,
                              price: topCourses[index].price,
                            );
                          },
                          itemCount: topCourses.length,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Course Categories',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  CoursesScreen.routeName,
                                  arguments: {
                                    'category_id': null,
                                    'search_query': null,
                                    'type': CoursesPageData.All,
                                  },
                                );
                              },
                              padding: const EdgeInsets.all(0),
                            )
                          ],
                        ),
                      ),
                      Consumer<Categories>(
                        builder: (context, myCourseData, child) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return CategoryListItem(
                                id: myCourseData.items[index].id,
                                name: myCourseData.items[index].name,
                                thumbnail: myCourseData.items[index].thumbnail,
                                numberOfSubCategories:
                                myCourseData.items[index].numberOfSubCategories,
                              );
                            },
                            itemCount: myCourseData.items.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
