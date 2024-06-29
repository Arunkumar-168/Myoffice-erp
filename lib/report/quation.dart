import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/download/quatation%20print.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../download/dcprint.dart';

class quatationPage extends StatefulWidget {
  static const String routeName = '/quotation';
  const quatationPage({Key? key}) : super(key: key);

  @override
  _quatationPageState createState() => _quatationPageState();
}

class quatationData {
  final String id;
  final String quotationno;
  final String quotationdate;
  final String customerName;
  final String total;

  quatationData({
    required this.id,
    required this.quotationno,
    required this.quotationdate,
    required this.customerName,
    required this.total,
  });

  factory quatationData.fromJson(Map<String, dynamic> json) {
    return quatationData(
      id: json['id'],
      quotationno: json['quotationno'],
      quotationdate: json['quotationdate'],
      customerName: json['customername'],
      total: (json['total']),
    );
  }
}

class _quatationPageState extends State<quatationPage> {
  List<quatationData> voucherDataList = [];
  bool isLoading = false;
  var BaseURL;
  @override
  void initState() {
    fetchvoucherData();
    initialize();
    fetchData();
    super.initState();
  }
  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });
    // Simulate fetching data
    await Future.delayed(Duration(seconds: 2));

    // After fetching data, set isLoading to false
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var baseURL = prefs.getString('url');
    print(baseURL);
    if (baseURL != null) {
      BaseURL = baseURL;
    }
  }

  Future<void> fetchvoucherData() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url');
    var fullUrl = BaseURL + '/Api/quotationreport';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        voucherDataList =
            jsonData.map((data) => quatationData.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 67, 230),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Quotation Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial white',
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 91, 67, 230),
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final sale in voucherDataList)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      DesignPage.routeName,
                      arguments: sale.id,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 100, 98, 187),
                          Color.fromARGB(255, 102, 121, 129),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.list,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              sale.quotationno,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      sale.quotationdate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                Text(
                                  '₹${sale.total}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.factory,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              sale.customerName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class PdfViewerPage extends StatelessWidget {
  final String filePath;

  const PdfViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}