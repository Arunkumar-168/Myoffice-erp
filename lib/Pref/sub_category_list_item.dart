import 'package:flutter_application_1/Pref/courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import '../api/constants.dart';

class SubCategoryListItem extends StatelessWidget {
  final int? id;
  final String? name;
  final int? parent;
  final int? number_of_courses;
  final int? index;

  const SubCategoryListItem(
      {Key? key,
        required this.id,
        required this.name,
        required this.parent,
        required this.number_of_courses,
        required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          CoursesScreen.routeName,
          arguments: {
            'category_id': id,
            'seacrh_query': null,
            'type': CoursesPageData.Category,
          },
        );
      },
      child: Card(
        // color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15),
              child: Text(
                "${index!+1}.",
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                width: double.infinity,
                // height: 80,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          HtmlUnescape().convert(name!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$number_of_courses Courses',
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: iCardColor,
                  child: const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    child: Icon(Icons.arrow_forward, color: Colors.orange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
