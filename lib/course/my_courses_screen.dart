import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/course/my_course_grid.dart';
import 'package:flutter_application_1/course/my_courses.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MyNotifierClass extends ChangeNotifier {}

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  _MyCoursesScreenState createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/dd.png',
          height: 200,
          width: 200,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    'My Courses',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: Provider.of<MyCourses>(context, listen: false).fetchMyCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<MyCourses>(
                      builder: (context, myCourseData, child) =>
                          StaggeredGridView.countBuilder(
                            padding: const EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            itemCount: myCourseData.items.length,
                            itemBuilder: (ctx, index) {
                              return MyCourseGrid(
                                myCourse: myCourseData.items[index],
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
