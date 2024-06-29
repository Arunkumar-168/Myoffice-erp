import 'package:flutter/material.dart';
import '../models/sub_category_screen.dart';

class CategoryListItem extends StatelessWidget {
  final int? id;
  final String? name;
  final String? thumbnail;
  final int? numberOfSubCategories;

  const CategoryListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.numberOfSubCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          SubCategoryScreen.routeName,
          arguments: {
            'category_id': id,
            'title': name,
          },
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage('$thumbnail'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$numberOfSubCategories Sub-Categories',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.arrow_forward, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
