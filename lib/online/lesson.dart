
class Lesson {
  int? id;
  String? title;
  String? duration;
  String? videoUrl;
  String? lessonType;
  String? summary;
  String? is_free;
  String? attachmentType;
  String? attachment;
  String? attachmentUrl;
  String? isCompleted;
  String? videoUrlWeb;
  String? videoTypeWeb;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessonType,
    required this.is_free,
    required this.videoUrl,
    required this.summary,
    required this.attachmentType,
    required this.attachment,
    required this.attachmentUrl,
    required this.isCompleted,
    required this.videoUrlWeb,
    required this.videoTypeWeb,
  });
}
