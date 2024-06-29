import 'package:flutter_application_1/Pref/SharedPreferenceHelper.dart';
import 'package:flutter_application_1/api/constants.dart';
import 'package:flutter_application_1/online/abc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Courses {
  int? id;
  String? title;
  String? thumbnail;
  String? price;

  Courses({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      id: int.parse(json['id']),
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: json['price'],
    );
  }
}

List<Courses> buildCourseList(List extractedData) {
  final List<Courses> courses = [];
  for (var data in extractedData) {
    courses.add(Courses(
      id: int.parse(data['id']),
      title: data['title'],
      thumbnail: data['thumbnail'],
      price: data['price'],
    ));
  }
  return courses;
}

class MyNotifierClass extends ChangeNotifier {}

class MyWishlistScreen extends StatefulWidget {
  const MyWishlistScreen({Key? key}) : super(key: key);

  @override
  _MyWishlistScreenState createState() => _MyWishlistScreenState();
}

class _MyWishlistScreenState extends State<MyWishlistScreen> {
  late List<Courses> _items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMyWishlist();
  }

  Future<void> fetchMyWishlist() async {
    setState(() {
      isLoading = false
      ;
    });
    try {
      _items.clear();
      var authToken = await SharedPreferenceHelper().getAuthToken();
      var url = BaseURL + '/my_wishlist?auth_token=$authToken';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        setState(() {
          _items = buildCourseList(extractedData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load wishlist');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  // void removeFromWishlist(Courses course) {
  //   // Implement the logic to remove the course from the wishlist
  //   setState(() {
  //     _items.remove(course);
  //   });
  // }

  Future<void> refreshList() async {
    await fetchMyWishlist();
  }



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyNotifierClass>(
      create: (_) => MyNotifierClass(),
      child: Consumer<MyNotifierClass>(
        builder: (context, myNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              title: Image.asset(
                'assets/images/dd.png',
                height: 200,
                width: 200,
              ),
            ),
            body: isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            )
                : RefreshIndicator(
              onRefresh: refreshList,
              color: Colors.orange,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'My Wishlist',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (var course in _items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            CourseDetailScreen.routeName,
                            arguments: course.id,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(course.thumbnail!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.title!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial Black',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
