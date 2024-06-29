import 'package:flutter/foundation.dart';

class Course {
  int? id;
  String? title;
  String? thumbnail;
  String? price;
  String? isFreeCourse;
  String? instructor;
  String? attachmentType;
  String? attachment;
  String? level;
  int? rating;
  int? totalNumberRating;
  int? numberOfEnrollment;
  String? shareableLink;
  String? courseOverviewProvider;
  String? courseOverviewUrl;
  String? vimeoVideoId;

  Course({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.isFreeCourse,
    required this.level,
    required this.attachmentType,
    required this.attachment,
    required this.instructor,
    required this.rating,
    required this.totalNumberRating,
    required this.numberOfEnrollment,
    required this.shareableLink,
    required this.courseOverviewProvider,
    required this.courseOverviewUrl,
    required this.vimeoVideoId,
  });
}
