import 'package:flutter/foundation.dart';

class SubCategory {
  final int? id;
  final String? name;
  final int? parent;
  final int? number_of_courses;

  SubCategory({
    required this.id,
    required this.name,
    required this.parent,
    required this.number_of_courses,
  });
}
