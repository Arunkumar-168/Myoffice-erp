import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import '../Pref/temp_view_screen.dart';
import '../Video/chip.dart';
import '../api/constants.dart';
import '../coursedetails/file_data_screen.dart';
import '../coursedetails/live_class_tab_widget.dart';
import '../coursedetails/vimeo_player_widget.dart';
import '../coursedetails/webview_screen.dart';
import '../models/youtube_player_widget.dart';
import '../online/abc.dart';
import '../online/common_functions.dart';
import '../online/custom_text.dart';
import '../online/lesson.dart';
import 'my_courses.dart';


class MyCourseDetailScreen extends StatefulWidget {
  static const routeName = '/my-course-details';
  const MyCourseDetailScreen({Key? key}) : super(key: key);

  @override
  _MyCourseDetailScreenState createState() => _MyCourseDetailScreenState();
}

class _MyCourseDetailScreenState extends State<MyCourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  // late bool fixedScroll;

  var _isInit = true;
  var _isLoading = false;
  int? selected;

  dynamic liveClassStatus;
  dynamic data;
  Lesson? _activeLesson;

  final ReceivePort _port = ReceivePort();
  String buttonText = "Download";
  String downloadId = "";

  dynamic path;
  dynamic fileName;
  dynamic lessonId;
  dynamic courseId;
  dynamic sectionId;
  dynamic courseTitle;
  dynamic sectionTitle;
  dynamic thumbnail;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    super.initState();
    // addonStatus();
    // FlutterDownloader.registerCallback(downloadCallback);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    // if (fixedScroll) {
    //   _scrollController.jumpTo(0);
    // }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 3),
      curve: Curves.ease,
    );

    // setState(() {
    //   fixedScroll = _tabController.index == 1;
    // });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final myCourseId = ModalRoute.of(context)!.settings.arguments as int;

      Provider.of<MyCourses>(context, listen: false)
          .fetchCourseSections(myCourseId)
          .then((_) {
        final activeSections =
            Provider.of<MyCourses>(context, listen: false).sectionItems;
        setState(() {
          _isLoading = false;
          _activeLesson = activeSections.first.mLesson!.first;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }



  // Future<void> addonStatus() async {
  //   var url = BaseURL + 'addon_status?unique_identifier=live-class';
  //   final response = await http.get(Uri.parse(url));
  //   liveClassStatus = json.decode(response.body)['status'];
  // }

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: _activeLesson!.videoUrlWeb,
          newKey: UniqueKey(),
        );
      },
    );
  }

  void _showVimeoModal(BuildContext ctx, String vimeoVideoId) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return VimeoPlayerWidget(
          videoId: vimeoVideoId,
          newKey: UniqueKey(),
        );
      },
    );
  }

  void lessonAction(Lesson lesson) async {
    if (lesson.lessonType == 'video') {
      if (lesson.videoTypeWeb == 'system' ||
          lesson.videoTypeWeb == 'html5' ||
          lesson.videoTypeWeb == 'amazon') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TempViewScreen(videoUrl: lesson.videoUrlWeb)),
        );
        // print(lesson.videoUrlWeb);
        Navigator.of(context)
            .pushNamed(TempViewScreen.routeName, arguments: lesson.videoUrlWeb);
      } else if (lesson.videoTypeWeb == 'Vimeo') {
        String vimeoVideoId = lesson.videoUrlWeb!.split('/').last;
        // print(lesson.vimeoVideoId);
        _showVimeoModal(context, vimeoVideoId);
      } else {

        _showYoutubeModal(context);
      }
    } else if (lesson.lessonType == 'quiz') {
      //print(lesson.id);
      final _url = 'https://osjglobaltest.graspsoftwaresolutions.xyz/home/quiz_mobile_web_view/${lesson.id}';
      // print(_url);
      Navigator.of(context).pushNamed(WebViewScreen.routeName, arguments: _url);
    } else {
      if (lesson.attachmentType == 'iframe') {
        final _url = lesson.attachment;
        String? url = lesson.attachment;
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

        // Print or use otp and playbackInfo as needed
        // print('OTP: $otp');
        // print('PlaybackInfo: $playbackInfo');

        Navigator.of(context).push(
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/player-ui/sample/video'),
            builder: (BuildContext context) {
              return VdoPlaybackView(
                embedInfo: EmbedInfo.streaming(
                  otp: otp,
                  playbackInfo: playbackInfo,
                  embedInfoOptions: EmbedInfoOptions(autoplay: true),
                ),
                controls: true,
              );
            },
          ),
        );
      }
      // }  else if (lesson.attachmentType == 'iframe') {
      //   final _url = lesson.attachment;
      //   Navigator.of(context)
      //       .pushNamed(VdoPlaybackView.routeName, arguments: _url);
      // }
      else if(lesson.attachmentType == 'description') {
        data = lesson.attachment;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FileDataScreen(textData: data, note: lesson.summary!)));

      } else if(lesson.attachmentType == 'txt') {
        final _url =
            BaseURL + '/uploads/lesson_files/' + lesson.attachment.toString();
        data = await http.read(Uri.parse(_url));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FileDataScreen(textData: data, note: lesson.summary!)));

      } else {
        final _url =
            BaseURL + '/uploads/lesson_files/' + lesson.attachment.toString();
        _launchURL(_url);
      }
    }
  }

  void _launchURL(lessonUrl) async {
    if (await canLaunch(lessonUrl)) {
      await launch(lessonUrl);
    } else {
      throw 'Could not launch $lessonUrl';
    }
  }

  Widget getLessonSubtitle(Lesson lesson) {
    if (lesson.lessonType == 'video') {
      return CustomText(
        text: lesson.duration,
        fontSize: 12,
      );
    } else if (lesson.lessonType == 'quiz') {
      return RichText(
        text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.event_note,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Quiz',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    } else {
      return RichText(
        text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.attach_file,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Attachment',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myCourseId = ModalRoute.of(context)!.settings.arguments as int;
    final myLoadedCourse =
    Provider.of<MyCourses>(context, listen: false).findById(myCourseId);
    final sections =
        Provider.of<MyCourses>(context, listen: false).sectionItems;
    myCourseBody() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Card(
                elevation: 0.3,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  // Set the border color
                  borderRadius:
                  BorderRadius.circular(4.0),
                ),
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: myLoadedCourse.title,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'details') {
                                  Navigator.of(context).pushNamed(
                                      CourseDetailScreen.routeName,
                                      arguments: myLoadedCourse.id);
                                } else {
                                  // Share.share(myLoadedCourse.shareableLink.toString());
                                }
                              },
                              icon: const Icon(
                                Icons.more_vert,
                              ),
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  child: Text('Course Details'),
                                  value: 'details',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: LinearPercentIndicator(
                          lineHeight: 8.0,
                          backgroundColor: kBackgroundColor,
                          percent: myLoadedCourse.courseCompletion! / 100,
                          progressColor:Colors.orange,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomText(
                                  text: '${myLoadedCourse.courseCompletion}% Complete',
                                  fontSize: 12,
                                  colors: Colors.black54,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CustomText(
                                text:
                                '${myLoadedCourse.totalNumberOfCompletedLessons}/${myLoadedCourse.totalNumberOfLessons}',
                                fontSize: 14,
                                colors: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                key: Key('builder ${selected.toString()}'), //attention
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sections.length,
                itemBuilder: (ctx, index) {
                  final section = sections[index];
                  return Card(
                    elevation: 0.3,
                    child: ExpansionTile(
                      key: Key(index.toString()), //attention
                      initiallyExpanded: index == selected,
                      onExpansionChanged: ((newState) {
                        if (newState) {
                          setState(() {
                            selected = index;
                          });
                        } else {
                          setState(() {
                            selected = -1;
                          });
                        }
                      }), //attention
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: CustomText(
                                text: HtmlUnescape()
                                    .convert(section.title.toString()),
                                colors: kDarkGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kTimeBackColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: section.totalDuration,
                                        fontSize: 10,
                                        colors: kTimeColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kLessonBackColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kLessonBackColor,
                                          borderRadius:
                                          BorderRadius.circular(3),
                                        ),
                                        child: CustomText(
                                          text:
                                          '${section.mLesson!.length} Lessons',
                                          fontSize: 10,
                                          colors: kDarkGreyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(flex: 2, child: Text("")),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final lesson = section.mLesson![index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _activeLesson = lesson;
                                });
                                lessonAction(_activeLesson!);
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    color: Colors.white60,
                                    width: double.infinity,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            activeColor: Colors.orange,
                                            value: lesson.isCompleted == '1' ? true : false,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                lesson.isCompleted = value! ? '1' : '0';
                                                if (value) {
                                                  myLoadedCourse.totalNumberOfCompletedLessons =
                                                      myLoadedCourse.totalNumberOfCompletedLessons! + 1;
                                                } else {
                                                  myLoadedCourse.totalNumberOfCompletedLessons =
                                                      myLoadedCourse.totalNumberOfCompletedLessons! - 1;
                                                }
                                                var completePerc = (myLoadedCourse.totalNumberOfCompletedLessons! /
                                                    myLoadedCourse.totalNumberOfLessons!) * 100;
                                                myLoadedCourse.courseCompletion = completePerc.round();
                                              });
                                              Provider.of<MyCourses>(context, listen: false)
                                                  .toggleLessonCompleted(lesson.id!.toInt(), value! ? 1 : 0)
                                                  .then((_) {
                                                CommonFunctions.showSuccessToast('Course Progress Updated');
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              CustomText(
                                                text: lesson.title,
                                                fontSize: 14,
                                                colors: kTextColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              getLessonSubtitle(lesson),
                                            ],
                                          ),
                                        ),
                                        if (lesson.lessonType == 'video')
                                          const Icon(Icons.video_library, color: Colors.blue),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: section.mLesson!.length,
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    myCourseBodyTwo() {
      return Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              key: Key('builder ${selected.toString()}'), //attention
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              itemBuilder: (ctx, index) {
                final section = sections[index];
                return Card(
                  elevation: 0.3,
                  child: ExpansionTile(
                    key: Key(index.toString()), //attention
                    initiallyExpanded: index == selected,
                    onExpansionChanged: ((newState) {
                      if (newState) {
                        setState(() {
                          selected = index;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    }), //attention
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: CustomText(
                              text: HtmlUnescape()
                                  .convert(section.title.toString()),
                              colors: kDarkGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kTimeBackColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: section.totalDuration,
                                      fontSize: 10,
                                      colors: kTimeColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kLessonBackColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kLessonBackColor,
                                        borderRadius:
                                        BorderRadius.circular(3),
                                      ),
                                      child: CustomText(
                                        text:
                                        '${section.mLesson!.length} Lessons',
                                        fontSize: 10,
                                        colors: kDarkGreyColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(flex: 2, child: Text("")),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          final lesson = section.mLesson![index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _activeLesson = lesson;
                              });
                              lessonAction(_activeLesson!);
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  color: Colors.white60,
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                            activeColor: Colors.orange,
                                            value: lesson.isCompleted == '1'
                                                ? true
                                                : false,
                                            onChanged: (bool? value) {
                                              // print(value);

                                              setState(() {
                                                lesson.isCompleted =
                                                value! ? '1' : '0';
                                                if (value) {
                                                  myLoadedCourse
                                                      .totalNumberOfCompletedLessons =
                                                      myLoadedCourse
                                                          .totalNumberOfCompletedLessons! +
                                                          1;
                                                } else {
                                                  myLoadedCourse
                                                      .totalNumberOfCompletedLessons =
                                                      myLoadedCourse
                                                          .totalNumberOfCompletedLessons! -
                                                          1;
                                                }
                                                var completePerc = (myLoadedCourse
                                                    .totalNumberOfCompletedLessons! /
                                                    myLoadedCourse
                                                        .totalNumberOfLessons!) *
                                                    100;
                                                myLoadedCourse
                                                    .courseCompletion =
                                                    completePerc.round();
                                              });
                                              Provider.of<MyCourses>(context,
                                                  listen: false)
                                                  .toggleLessonCompleted(
                                                  lesson.id!.toInt(),
                                                  value! ? 1 : 0)
                                                  .then((_) => CommonFunctions
                                                  .showSuccessToast(
                                                  'Course Progress Updated'));
                                            }),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CustomText(
                                              text: lesson.title,
                                              fontSize: 14,
                                              colors: kTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            getLessonSubtitle(lesson),
                                          ],
                                        ),
                                      ),
                                      if (lesson.lessonType == 'video')
                                        Icon(Icons.video_library, color: Colors.blue),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: section.mLesson!.length,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    liveClassBody() {
      return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 0.3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: myLoadedCourse.title,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'details') {
                                    Navigator.of(context).pushNamed(
                                        CourseDetailScreen.routeName,
                                        arguments: myLoadedCourse.id);
                                  } else {
                                    // Share.share(myLoadedCourse.shareableLink.toString());
                                  }
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    child: Text('Course Details'),
                                    value: 'details',
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Share this Course'),
                                    value: 'share',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: LinearPercentIndicator(
                            lineHeight: 8.0,
                            backgroundColor: kBackgroundColor,
                            percent: myLoadedCourse.courseCompletion! / 100,
                            progressColor: Colors.orange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: CustomText(
                                    text: '${myLoadedCourse.courseCompletion}% Complete',
                                    fontSize: 12,
                                    colors: Colors.black54,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomText(
                                  text:
                                  '${myLoadedCourse.totalNumberOfCompletedLessons}/${myLoadedCourse.totalNumberOfLessons}',
                                  fontSize: 14,
                                  colors: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorColor: Colors.orange,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                  unselectedLabelColor: Colors.black87,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.play_lesson,
                            size: 15,
                          ),
                          Text(
                            'Lessons',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.video_call),
                          Text(
                            'Live Class',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            myCourseBodyTwo(),
            LiveClassTabWidget(courseId: myCourseId),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/dd.png',
          height: 200,
          width: 200,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      )
          : liveClassStatus == false
          ? myCourseBody()
          : liveClassBody(),
    );
  }
}
