import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

String BaseURL = '';

class HighData {
  final String id;
  final String url;
  final String filename;

  HighData({
    required this.id,
    required this.url,
    required this.filename,
  });

  factory HighData.fromJson(Map<String, dynamic> json) {
    return HighData(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      filename: json['filename'] ?? '',
    );
  }
}

Future<void> initialize() async {
  var prefs = await SharedPreferences.getInstance();
  var baseURL = prefs.getString('url') ?? '';
  if (baseURL.isNotEmpty) {
    BaseURL = baseURL;
  }
}

class PurePage extends StatefulWidget {
  static const String routeName = '/purchase';
  const PurePage({Key? key}) : super(key: key);

  @override
  _PurePageState createState() => _PurePageState();
}

class _PurePageState extends State<PurePage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  List<XFile> files = [];
  List<HighData> printList = [];
  bool isLoading = true;
  String? localPath;
  bool downloading = false;
  String? pdfUrl;
  String? fileName;
  String? fullURL;
  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  void initState() {
    super.initState();
    initialize().then((_) {
      createPDF();
    });
  }

  Future<void> createPDF() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var baseURL = prefs.getString('url') ?? '';
      if (baseURL.isEmpty) {
        throw Exception('Base URL is not set');
      }
      var fullUrl = '$baseURL/Api/purchasebill/1';
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('bill')) {
          final List<dynamic> billList = jsonData['bill'];
          setState(() {
            printList = billList.map((data) => HighData.fromJson(data)).toList();
            pdfUrl = printList.isNotEmpty ? printList[0].url : null;
            fileName = printList.isNotEmpty ? printList[0].filename : null;
            fullURL = (pdfUrl != null && fileName != null) ? '$pdfUrl$fileName' : null;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  Future<void> generatePDF() async {
    setState(() {
      downloading = true;
    });

    try {
      if (fullURL != null) {
        Dio dio = Dio();
        Directory? appDocDir = await getExternalStorageDirectory();

        // Format today's date as part of the file name
        String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
        String savePath = "${appDocDir!.path}/$formattedDate-$fileName"; // Adjusted file name with date

        await download(dio, fullURL!, savePath);
        setState(() {
          localPath = savePath;
          downloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded successfully')),
        );
      }
    } catch (e) {
      setState(() {
        downloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: ${e.toString()}')),
      );
    }
  }

  Future<void> download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }

  void showDownloadProgress(int received, int total) {
    if (total != -1) {
      print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
    }
  }

  Future<void> sharePDF(BuildContext context) async {
    try {
      if (localPath != null && localPath!.isNotEmpty) {
        final result = await Share.shareXFiles(
          [XFile(localPath!)],
          text: 'Check out this PDF file!',
        );
        if (result.status == ShareResultStatus.success) {
          print('PDF shared successfully!');
        } else {
          print('Failed to share PDF.');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download the first pdf file')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 91, 67, 230),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Purchase Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial Black',
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : fullURL != null
          ? SfPdfViewer.network(
        fullURL!,
        key: _pdfViewerKey,
      )
          : Center(child: Text('No PDF available')),
      bottomNavigationBar: BottomButtons(
        generatePDF: generatePDF,
        sharePDF: () async {
          await sharePDF(context);
        },
        downloading: downloading,
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  final VoidCallback generatePDF;
  final Future<void> Function() sharePDF;
  final bool downloading;

  const BottomButtons({
    Key? key,
    required this.generatePDF,
    required this.sharePDF,
    required this.downloading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        color: Colors.grey[300],
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: downloading ? null : generatePDF,
              icon: Icon(Icons.print),
              label: Text('Print & Download'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Text color
                backgroundColor: Colors.green, // Button color
              ),
            ),
            // Use Builder to get the widget context
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton.icon(
                  onPressed: () => sharePDF(),
                  icon: Icon(Icons.share),
                  label: Text('Share PDF'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Colors.green, // Button color
                  ),
                );
              },
            )
          ],
        ),

      ),
    );
  }
}
