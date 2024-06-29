// import 'dart:convert';
// import 'package:academy/online/section.dart';
// import 'package:flutter/material.dart';
// import 'package:academy/Pref/temp_view_screen.dart';
// import 'package:academy/api/constants.dart';
// import 'package:academy/online/tab_view_details.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:http/http.dart' as http;
// import '../Pref/SharedPreferenceHelper.dart';
// import '../api/star_display_widget.dart';
// import '../search/Dynamic.dart';
// import 'custom_text.dart';
// import 'lesson.dart';
// import 'lesson_list_item.dart';
//
// class CourseData {
//   final String id;
//   final String title;
//   final String thumbnail;
//   final String price;
//   final String instructorName;
//   final String shortdescription;
//   final String description;
//   final String level;
//   final int rating;
//   final int numberOfRatings;
//   final String shareableLink;
//   final String courseOverviewProvider;
//   final String videoUrl;
//
//   CourseData({
//     required this.id,
//     required this.title,
//     required this.thumbnail,
//     required this.price,
//     required this.instructorName,
//     required this.rating,
//     required this. shortdescription,
//     required this. description,
//     required this. level,
//     required this.numberOfRatings,
//     required this.shareableLink,
//     required this.courseOverviewProvider,
//     required this.videoUrl,
//   });
//
//   factory CourseData.fromCourse(course) {
//     return CourseData(
//       id: course.id,
//       title: course.title,
//       thumbnail: course.thumbnail,
//       price: course.price,
//       shortdescription: course.shortdescription,
//       description: course.description,
//       level: course.level,
//       instructorName: course.instructorName,
//       rating: course.rating,
//       numberOfRatings: course.numberOfRatings,
//       shareableLink: course.shareableLink,
//       courseOverviewProvider: course.courseOverviewProvider,
//       videoUrl: course.videoUrl,
//       // mSection: buildCourseSections(json['sections']),
//     );
//   }
//
//   static List<Section> buildCourseSections(List<dynamic> sectionData) {
//     return sectionData.map((section) => Section.fromJson(section)).toList();
//   }
// }
//
// class MyNotifierClass with ChangeNotifier {
//   List<CourseData> _items = [];
//
// }
//
// List<CourseData> buildCourseList(List extractedData) {
//   final List<CourseData> course = [];
//   for (var courseData in extractedData) {
//     course.add(CourseData(
//       id: courseData['id'],
//       title: courseData['title'],
//       thumbnail: courseData['thumbnail'],
//       price: courseData['price'],
//       shortdescription: courseData['short_description'],
//       description: courseData['description'],
//       level: courseData['level'],
//       instructorName: courseData['instructor_name'],
//       courseOverviewProvider:courseData['course_Overview_Provider'],
//       rating: courseData['rating'],
//       numberOfRatings: courseData['number_of_ratings'],
//       shareableLink: courseData['shareable_link'],
//       videoUrl: courseData['video_url'],
//       // mSection: [], // assuming mSection starts as an empty list
//     ));
//   }
//   return course;
// }
//
//
//
// class Oneplus extends StatefulWidget {
//   static const routeName = '/one';
//
//   const Oneplus({Key? key}) : super(key: key);
//
//   @override
//   _OneplusState createState() => _OneplusState();
// }
//
// class _OneplusState extends State<Oneplus> with SingleTickerProviderStateMixin {
//   late final  Oneplus section;
//   bool showCurriculum = false;
//   bool show = false;
//   bool Curriculum = false;
//   late TabController _tabController;
//   late List<dynamic> listdata = [];
//   bool showDetails = false;
//   bool isLoading = true;
//   var _isLoading = false;
//   var args;
//   int? selected;
//   bool _isAuth = false;
//   var _isInit = true;
//
//   List<CourseData> get items {
//     return [...items];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     loadData().then((_) {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   Future<void> loadData() async {
//     // Simulated data loading process
//     await Future.delayed(Duration(seconds: 1));
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Future<void> didChangeDependencies() async {
//     args = ModalRoute.of(context)!.settings.arguments as String;
//     courseData(args);
//     if (_isInit) {
//       var token = await SharedPreferenceHelper().getAuthToken();
//       setState(() {
//         _isLoading = true;
//         // _authToken = Provider.of<Auth>(context, listen: false).token;
//         if (token != null && token.isNotEmpty) {
//           _isAuth = true;
//         } else {
//           _isAuth = false;
//         }
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }
//
//   Future<void> courseData(args) async {
//     final response = await http.get(Uri.parse(
//         '${BaseURL}course_details_by_id?course_id=$args&auth_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMSIsImZpcnN0X25hbWUiOiJKYXlhcHJha2FzaCIsImxhc3RfbmFtZSI6InMiLCJlbWFpbCI6ImpwQGlkcmVhbWRldmVsb3BlcnMuY29tIiwicm9sZSI6ImFkbWluIiwidmFsaWRpdHkiOjF9.7EoGbJa7LB9lgtecZuDvf2YVlE3YL6dByPwMw5_5a2Q'));
//     try {
//       if (response.statusCode == 200) {
//         setState(() {
//           listdata = json.decode(response.body);
//         });
//       } else {
//         throw Exception(
//             'Failed to load data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Catch Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double coverHeight =
//     220.0; // Example value, replace with your actual cover image height
//     double profileHeight =
//     100.0; // Example value, replace with your actual profile image height
//     final double top = coverHeight - profileHeight / 2;
//     return Scaffold(
//             backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/dd.png',
//               height: 200,
//               width: 200,
//             ),
//             SizedBox(width: 8),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     suffixIcon: IconButton(
//                       icon: Image.asset(
//                         'assets/images/search.png',
//                         height: 20,
//                         width: 20,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SearchWidget(),
//                           ),
//                         );
//                       },
//                     ),
//                     contentPadding: EdgeInsets.all(10),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//               ),
//             )
//                 : ListView(
//               padding: const EdgeInsets.all(8),
//               children: listdata.map((listdetails) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         alignment: Alignment.bottomCenter,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15),
//                             child: Container(
//                               height: 200,
//                               width: 320,
//                               decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     colorFilter: ColorFilter.mode(
//                                         Colors.black.withOpacity(0.7),
//                                         BlendMode.dstATop),
//                                     image: NetworkImage(
//                                         (listdetails['thumbnail'])),
//                                   )),
//                               child: IconButton(
//                                 icon:
//                                 const Icon(Icons.play_circle_filled),
//                                 iconSize: 50,
//                                 color: Colors.white,
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           TempViewScreen(
//                                               videoUrl: listdetails[
//                                               'video_url']),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                        ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: RichText(
//                               textAlign: TextAlign.left,
//                               text: TextSpan(
//                                 text: listdetails['title'],
//                                 style: const TextStyle(
//                                   fontSize: 20, color: Colors.black,
//                                   fontWeight: FontWeight.w700,),
//                               ),
//                             ),
//                           ),
//                           const Expanded(
//                             flex: 1,
//                             child: Text(''),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               right: 10,
//                             ),
//                             child: StarDisplayWidget(
//                               // Assuming `listdetails['rating']` is nullable
//                               value: listdetails['rating'] != null
//                                   ? listdetails['rating']!.toInt()
//                                   : 0,
//                               filledStar: const Icon(
//                                 Icons.star,
//                                 color: kStarColor,
//                                 size: 25,
//                               ),
//                               unfilledStar: const Icon(
//                                 Icons.star_border,
//                                 color: kStarColor,
//                                 size: 25,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: Text(
//                               '( ${listdetails['rating']?.toStringAsFixed(1) ?? '0.0'} )',
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           CustomText(
//                             text:
//                             '${listdetails['number_of_ratings']}+ Rating',
//                             fontSize: 11,
//                             colors: Colors.yellow,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.only(
//                           right: 15, left: 15, top: 0, bottom: 5),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Expanded(
//                             flex: 2,
//                             child: CustomText(
//                               text: listdetails['price'],
//                               fontSize: 17,
//                               fontWeight: FontWeight.w500,
//                               colors: Colors.black,
//                             ),
//                           ),
//                           Container(
//                             width: 100,
//                             height: 35,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.green,
//                             ),
//                             child: TextButton(
//                               onPressed: () {},
//                               child: Text(
//                                 'Buy Now',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'Arial Black',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Card(
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 side: BorderSide(color: Colors.white!), // Set the border color
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: TabBar(
//                                       controller: _tabController,
//                                       indicatorSize: TabBarIndicatorSize.tab,
//                                       indicator: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.orange,
//                                       ),
//                                       unselectedLabelColor: kTextColor,
//                                       labelColor: Colors.white,
//                                       tabs: const <Widget>[
//                                         Tab(
//                                           child: Text(
//                                             "Includes",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w900,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                         Tab(
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               "Outcomes",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w900,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Tab(
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               "Requirements",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w900,
//                                                 fontSize: 11,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     height: 150,
//                                     padding: const EdgeInsets.only(
//                                       right: 10,
//                                       left: 10,
//                                       top: 10,
//                                       bottom: 0,
//                                     ),
//                                     child: TabBarView(
//                                       controller: _tabController,
//                                       children: [
//                                         TabViewDetails(
//                                           titleText: 'What is Included',
//                                           listText: [
//                                             listdetails['short_description']
//                                           ], // Wrap the single string in a list
//                                         ),
//                                         TabViewDetails(
//                                           titleText: 'What you will learn',
//                                           listText: listdetails['outcomes']
//                                               .map<String>((outcome) => outcome.toString())
//                                               .toList(),
//                                         ),
//                                         TabViewDetails(
//                                           titleText: 'Course Requirements',
//                                           listText: [
//                                             listdetails['description']
//                                           ], // Wrap the single string in a list
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(width: 20),
//                               // Adjusted SizedBox width to move the text
//                               Text(
//                                 "Course Curriculum",
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: ListView.builder(
//                               key: Key('builder ${selected.toString()}'),
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: listdetails['sections'].length,
//                               itemBuilder: (ctx, index) {
//                                 final section = listdetails['sections'][index];
//                                 return Card(
//                                   shape: RoundedRectangleBorder(
//                                     side: BorderSide(color: Colors.white), // Set the border color
//                                     borderRadius: BorderRadius.circular(4.0),
//                                   ),
//                                   elevation: 0, // Remove elevation
//                                   child: ExpansionTile(
//                                     key: Key(index.toString()),
//                                     initiallyExpanded: index == selected,
//                                     onExpansionChanged: (newState) {
//                                       setState(() {
//                                         selected = newState ? index : -1;
//                                       });
//                                     },
//                                     title: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Align(
//                                           alignment: Alignment.centerLeft,
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 5),
//                                             child: CustomText(
//                                               text: HtmlUnescape().convert(section['title'].toString() ?? ''),
//                                               colors: Colors.grey,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5.0),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.green[100],
//                                                     borderRadius: BorderRadius.circular(3),
//                                                   ),
//                                                   padding: const EdgeInsets.symmetric(
//                                                     vertical: 3,
//                                                     horizontal: 5,
//                                                   ),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Text(
//                                                       section['total_duration'].toString() ?? '',
//                                                       style: TextStyle(
//                                                         fontSize: 10,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 10.0),
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.amber[100],
//                                                     borderRadius: BorderRadius.circular(3),
//                                                   ),
//                                                   padding: const EdgeInsets.symmetric(
//                                                     vertical: 3,
//                                                   ),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Text(
//                                                       '${section['lessons']?.length ?? 0} Lesson(s)',
//                                                       style: TextStyle(
//                                                         fontSize: 10,
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Expanded(
//                                                 flex: 1,
//                                                 child: Text(""),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     trailing: null,
//                                     children: List.generate(
//                                       section['lessons'].length,
//                                           (lessonIndex) {
//                                         Lesson lesson = Lesson.fromJson(section['lessons'][lessonIndex]);
//                                         return LessonListItem(
//                                           lesson: lesson,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }).toList(),
//             ),
//           );
//   }
// }
