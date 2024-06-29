import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/download/dcprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dcreport {
  final String id;
  final String dctype;
  final String dcno;
  final String dcdate;
  // final String inwardno;
  final String cusname;

  dcreport({
    required this.id,
    required this.dctype,
    required this.dcno,
    required this.dcdate,
  //  required this.inwardno,
    required this.cusname,
  });

  factory dcreport.fromJson(Map<String, dynamic> json) {
    return dcreport(
      id: json['id'],
      dctype: json['dctype'],
      dcno: json['dcno'],
      dcdate: json['dcdate'],
    //  inwardno: json['inwardno'],
      cusname: json['cusname'],
    );
  }
}

class DcPage extends StatefulWidget {
  static const String routeName = '/dc';
  const DcPage({Key? key}) : super(key: key);

  @override
  _DcPageState createState() => _DcPageState();
}

class _DcPageState extends State<DcPage> {
  List<dcreport> dclist = [];
  bool isLoading = false;
  var baseUrl;

  @override
  void initState() {
    super.initState();
    fetchDcData();
    initialize();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    // Simulate fetching data
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var baseURL = prefs.getString('url');
    print(baseURL);
    if (baseURL != null) {
      baseUrl = baseURL;
    }
  }



  Future<void> fetchDcData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var prefs = await SharedPreferences.getInstance();
      baseUrl = prefs.getString('url');// Provide a default value if null
        var fullUrl = baseUrl + '/Api/dcreport';

      final response = await http.get(Uri.parse(fullUrl));

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          // print(response.body);
          setState(() {
            dclist = jsonData.map((data) => dcreport.fromJson(data)).toList();
          });
          // print(dclist);
        } else {
          throw Exception('Failed to load data');
        }
    } catch (e) {
      print('Error fetching party data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
          'DC Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial white',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          child: isLoading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 91, 67, 230)),
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (final sale in dclist)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ReportPage.routeName,
                        arguments: sale.id,
                      );
                    },
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
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
                              sale.dcno,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 20),
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
                                      sale.dcdate,
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

                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.factory,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              sale.cusname,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.connect_without_contact_sharp,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              sale.dctype,
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
      ),
    );
  }
}
