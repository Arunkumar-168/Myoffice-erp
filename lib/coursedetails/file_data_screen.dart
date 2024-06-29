import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import '../api/constants.dart';

class FileDataScreen extends StatefulWidget {
  static const routeName = '/file-data';
  final String textData;
  final String note;
  const FileDataScreen({Key? key, required this.textData, required this.note}) : super(key: key);

  @override
  _FileDataScreenState createState() => _FileDataScreenState();
}

class _FileDataScreenState extends State<FileDataScreen> {

  @override
  Widget build(BuildContext context) {
    var text = html.Element.span()
      ..appendHtml(
          widget.textData.toString());
    var textData = text.innerText;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/dd.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),       backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(textData),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,),
                child: Container(
                  width: double.infinity,
                  color: kNoteColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Note: ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.note,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            wordSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
