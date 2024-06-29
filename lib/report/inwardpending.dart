import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class intPage extends StatefulWidget {
  const intPage({Key? key}) : super(key: key);

  @override
  _intPageState createState() => _intPageState();
}

class InwardpendingData {
  final String id;
  final String inwardno;
  final String inwarddate;
  final String customerName;
  final String cusdcno;
  final String itemname;

  InwardpendingData({
    required this.id,
    required this.inwardno,
    required this.inwarddate,
    required this.customerName,
    required this.cusdcno,
    required this.itemname,
  });

  factory InwardpendingData.fromJson(Map<String, dynamic> json) {
    return InwardpendingData(
      id: json['id'],
      inwardno: json['inwardno'],
      inwarddate: json['inwarddate'],
      customerName: json['customername'],
      cusdcno: (json['cusdcno']),
      itemname: (json['itemname']),
    );
  }
}

class _intPageState extends State<intPage> {
  List<InwardpendingData> voucherDataList = [];
  String? BaseURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initialize().then((_) {
      fetchvoucherData();
    });
    fetchData();
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
      setState(() {
        BaseURL = baseURL;
      });
    }
  }

  Future<void> fetchvoucherData() async {
    if (BaseURL == null) {
      print('BaseURL is null, cannot fetch data.');
      return;
    }

    var fullUrl = '$BaseURL/Api/inward_pending';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        voucherDataList = jsonData.map((data) => InwardpendingData.fromJson(data)).toList();
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
          'Inward Pending Report',
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
          onTap: () {
            // Navigate to the pending page when the sale item is tapped
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const PrintPage(),
            //   ),
            // );
          },
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
              for (final sale in voucherDataList)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  // Add vertical spacing between each sale
                  child: Container(
                    width: double.infinity,
                    height: 100,
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
                              sale.inwardno,
                              style: const TextStyle(
                                fontSize: 14,
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
                                      sale.inwarddate,
                                      style: const TextStyle(
                                        fontSize: 14,
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      sale.cusdcno,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                              sale.itemname,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              sale.customerName,
                              style: const TextStyle(
                                fontSize: 15,
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
            ],
          ),
        ),
      ),
    );
  }
}
