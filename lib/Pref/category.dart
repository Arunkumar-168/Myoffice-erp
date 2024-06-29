import 'package:flutter/foundation.dart';

class Category {
  final int? id;
  final String? name;
  final String? thumbnail;
  final int? numberOfCourses;
  final int? numberOfSubCategories;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.numberOfCourses,
    required this.numberOfSubCategories,
  });
}
