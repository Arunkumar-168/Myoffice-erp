import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pref/sub_category_list_item.dart';
import '../api/constants.dart';
import '../search/categories.dart';

class SubCategoryScreen extends StatefulWidget {
  static const routeName = '/sub-cat';
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {


  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final categoryId = routeArgs?['category_id'] as int ?? 0;
    final title = routeArgs?['title'] as String? ?? 'Sub Categories';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(title, maxLines: 2),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Provider.of<Categories>(context, listen: false)
              .fetchSubCategories(categoryId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              );
            } else {
                return Consumer<Categories>(
                  builder: (context, myCourseData, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Showing ${myCourseData.subItems.length} Sub-Categories',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: myCourseData.subItems.length,
                          itemBuilder: (ctx, index) {
                            return SubCategoryListItem(
                              id: myCourseData.subItems[index].id,
                              name: myCourseData.subItems[index].name,
                              parent: myCourseData.subItems[index].parent,
                              number_of_courses:myCourseData.subItems[index].number_of_courses,
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
