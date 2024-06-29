import 'package:flutter_application_1/online/lesson.dart';
class Section {
  int? id;
  int? numberOfCompletedLessons;
  String? title;
  String? totalDuration;
  int? lessonCounterStarts;
  int? lessonCounterEnds;
  List<Lesson>? mLesson;

  Section({
    required this.id,
    required this.numberOfCompletedLessons,
    required this.title,
    required this.totalDuration,
    required this.lessonCounterEnds,
    required this.lessonCounterStarts,
    required this.mLesson,
  });
}
