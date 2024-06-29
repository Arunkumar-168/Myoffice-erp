import 'package:flutter/material.dart';
import 'package:flutter_application_1/Video/chip.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'lesson.dart';

class LessonListItem extends StatefulWidget {
  final Lesson? lesson;

  LessonListItem({Key? key, required this.lesson}) : super(key: key);

  @override
  _LessonListItemState createState() => _LessonListItemState();
}

class _LessonListItemState extends State<LessonListItem> {
  void navigateToLesson(BuildContext context) {
    print('Navigating to ${widget.lesson!.title}');
  }

  IconData getLessonIcon(String lessonType) {
    if (lessonType == 'video') {
      return Icons.play_arrow;
    } else if (lessonType == 'quiz') {
      return Icons.help_outline;
    } else if (lessonType == 'is_free') {
      return Icons.remove_red_eye;
    } else {
      return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToLesson(context),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    getLessonIcon(widget.lesson?.lessonType ?? ''),
                    size: 14,
                    color: Colors.black45,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.lesson?.title ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black45),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.lesson?.is_free == "1" &&
                          widget.lesson?.attachment != null) {
                        String url =
                        widget.lesson!.attachment!; // Ensure non-null value
                        final _url = widget.lesson!.attachment;
                        // print('URL : ${_url!}');
                        String htmlString = url!;
                        // Remove style attribute
                        htmlString = htmlString.replaceAll(RegExp(r'" style="[^"]*"'), '');

                        // Remove allowFullScreen attribute
                        htmlString = htmlString.replaceAll(RegExp(r'allowFullScreen="[^"]*"'), '');

                        // Remove allow attribute
                        htmlString = htmlString.replaceAll(RegExp(r'allow="[^"]*'), '');

                        // Parsing the URL
                        Uri uri = Uri.parse(htmlString);

                        // Extracting query parameters
                        String otp = uri.queryParameters['otp'] ?? '';
                        String playbackInfo = uri.queryParameters['playbackInfo'] ?? '';

                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            settings: const RouteSettings(
                                name: '/player-ui/sample/video'),
                            builder: (BuildContext context) {
                              return VdoPlaybackView(
                                embedInfo: EmbedInfo.streaming(
                                  otp: otp,
                                  playbackInfo: playbackInfo,
                                  embedInfoOptions:
                                  EmbedInfoOptions(autoplay: true),
                                ),
                                controls: true,
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        widget.lesson?.is_free == "1"
                            ? const Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: Colors.orange,
                        )
                            : Container(),
                        const SizedBox(width: 10),
                        Text(
                          widget.lesson?.is_free == "1" ? 'Preview' : '',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
