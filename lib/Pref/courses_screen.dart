import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/constants.dart';
import '../course/courses.dart';
import '../search/course_list_item.dart';

class CoursesScreen extends StatefulWidget {
  static const routeName = '/courses';
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  var _isInit = true;
  var _isLoading = false;
  late Map<String, dynamic> routeArgs;
  late CoursesPageData pageDataType;
  int? categoryId;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      pageDataType = routeArgs['type'] as CoursesPageData;

      if (pageDataType == CoursesPageData.Category) {
        categoryId = routeArgs['category_id'] as int;
        _fetchCoursesByCategory(categoryId!);
      } else if (pageDataType == CoursesPageData.Search) {
        searchQuery = routeArgs['search_query'] as String;
        _fetchCoursesBySearchQuery(searchQuery!);
      } else if (pageDataType == CoursesPageData.All) {
        _fetchAllCourses();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _fetchCoursesByCategory(int categoryId) {
    Provider.of<Courses>(context, listen: false)
        .fetchCoursesByCategory(categoryId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _fetchCoursesBySearchQuery(String searchQuery) {
    Provider.of<Courses>(context, listen: false)
        .fetchCoursesBySearchQuery(searchQuery)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _fetchAllCourses() {
    Provider.of<Courses>(context, listen: false)
        .filterCourses('all', 'all', 'all', 'all', 'all')
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> refreshList() async {
    setState(() {
      _isLoading = true;
    });

    if (pageDataType == CoursesPageData.Category) {
      await Provider.of<Courses>(context, listen: false)
          .fetchCoursesByCategory(categoryId!);
    } else if (pageDataType == CoursesPageData.Search) {
      await Provider.of<Courses>(context, listen: false)
          .fetchCoursesBySearchQuery(searchQuery!);
    } else if (pageDataType == CoursesPageData.All) {
      await Provider.of<Courses>(context, listen: false)
          .filterCourses('all', 'all', 'all', 'all', 'all');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseData = Provider.of<Courses>(context).items;
    final courseCount = courseData.length;
    return Scaffold(
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
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      )
          : RefreshIndicator(
        onRefresh: refreshList,
        color: Colors.orange,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Showing $courseCount Courses',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return Center(
                      child: CourseListItem(
                        id: courseData[index].id!.toInt(),
                        title: courseData[index].title.toString(),
                        thumbnail: courseData[index].thumbnail.toString(),
                        rating: courseData[index].rating!.toInt(),
                        price: courseData[index].price.toString(),
                        level: courseData[index].level.toString(),
                        instructor: courseData[index].instructor.toString(),
                        noOfRating:
                        courseData[index].totalNumberRating!.toInt(),
                      ),
                    );
                  },
                  itemCount: courseData.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
