import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Pref/SharedPreferenceHelper.dart';
import '../api/constants.dart';
import '../online/lesson.dart';
import '../online/section.dart';
import 'my_course.dart';


class MyCourses with ChangeNotifier {
  List<MyCourse> _items = [];
  List<Section> _sectionItems = [];

  MyCourses(this._items, this._sectionItems);

  List<MyCourse> get items {
    return [..._items];
  }

  List<Section> get sectionItems {
    return [..._sectionItems];
  }

  int get itemCount {
    return _items.length;
  }

  MyCourse findById(int id) {
    return _items.firstWhere((myCourse) => myCourse.id == id);
  }

  Future<void> fetchMyCourses() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BaseURL + 'my_courses?auth_token=$authToken';
    try {
      _items.clear();
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData.isEmpty || extractedData == null) {
        return;
      }
      _items = buildMyCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }



  List<MyCourse> buildMyCourseList(List extractedData) {
    final List<MyCourse> loadedCourses = [];
    loadedCourses.clear();
    for (var courseData in extractedData) {
      loadedCourses.add(MyCourse(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        instructor: courseData['instructor_name'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        courseCompletion: courseData['completion'],
        totalNumberOfLessons: courseData['total_number_of_lessons'],
        totalNumberOfCompletedLessons:
        courseData['total_number_of_completed_lessons'],
      ));
      // print(catData['name']);
    }
    return loadedCourses;
  }

  Future<void> fetchCourseSections(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        BaseURL + 'sections?auth_token=$authToken&course_id=$courseId';
    print("URL : ${url}");
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<Section> loadedSections = [];
      for (var sectionData in extractedData) {
        loadedSections.clear();
        loadedSections.add(Section(
          id: int.parse(sectionData['id']),
          numberOfCompletedLessons: sectionData['completed_lesson_number'],
          title: sectionData['title'],
          totalDuration: sectionData['total_duration'],
          lessonCounterEnds: sectionData['lesson_counter_ends'],
          lessonCounterStarts: sectionData['lesson_counter_starts'],
          mLesson: buildSectionLessons(sectionData['lessons'] as List<dynamic>),
        ));
      }
      _sectionItems = loadedSections;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Lesson> buildSectionLessons(List extractedLessons) {
    final List<Lesson> loadedLessons = [];
    loadedLessons.clear();
    for (var lessonData in extractedLessons) {
      loadedLessons.add(Lesson(
        id: int.parse(lessonData['id']),
        title: lessonData['title'],
        duration: lessonData['duration'],
        is_free: lessonData['is_free'],
        lessonType: lessonData['lesson_type'],
        videoUrl: lessonData['video_url'],
        summary: lessonData['summary'],
        attachmentType: lessonData['attachment_type'],
        attachment: lessonData['attachment'],
        attachmentUrl: lessonData['attachment_url'],
        isCompleted: lessonData['is_completed'].toString(),
        videoUrlWeb: lessonData['video_url_web'],
        videoTypeWeb: lessonData['video_type_web'],
      ));
    }
    // print(loadedLessons.first.title);
    return loadedLessons;
  }

  Future<void> toggleLessonCompleted(int lessonId, int progress) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BaseURL +
        'save_course_progress?auth_token=$authToken&lesson_id=$lessonId&progress=$progress';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['course_id'] != null) {
        final myCourse = findById(int.parse(responseData['course_id']));
        myCourse.courseCompletion = responseData['course_progress'];
        myCourse.totalNumberOfCompletedLessons =
        responseData['number_of_completed_lessons'];

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BaseURL +
        'enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
