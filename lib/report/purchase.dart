import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/download/puchage%20print.dart';
import 'package:shared_preferences/shared_preferences.dart';

class purchasePage extends StatefulWidget {
  const purchasePage({Key? key}) : super(key: key);

  @override
  _purchasePageState createState() => _purchasePageState();
}

class purchaseData {
  final String id;
  final String purchaseno;
  final String invoicedate;
  final String suppliername;
  final String grandtotal;

  purchaseData({
    required this.id,
    required this.purchaseno,
    required this.invoicedate,
    required this.suppliername,
    required this.grandtotal,
  });

  factory purchaseData.fromJson(Map<String, dynamic> json) {
    return purchaseData(
      id: json['id'],
      purchaseno: json['purchaseno'],
      invoicedate: json['invoicedate'],
      suppliername: json['suppliername'],
      grandtotal: (json['grandtotal']),
    );
  }
}

class _purchasePageState extends State<purchasePage> {
  List<purchaseData> voucherDataList = [];
  var BaseURL;
  bool isLoading = false;

  @override
  void initState() {
    fetchvoucherData();
    initialize();
    fetchData();
    super.initState();
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var baseURL = prefs.getString('url');
    print(baseURL);
    if (baseURL != null) {
      BaseURL = baseURL;
    }
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

  Future<void> fetchvoucherData() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url');
    var fullUrl = BaseURL + '/Api/purchase_report';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        voucherDataList =
            jsonData.map((data) => purchaseData.fromJson(data)).toList();
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
          'Purchase Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial white',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            // Navigate to the PurePage when tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PurePage(),
              ),
            );
          },
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 91, 67, 230),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      for (final sale in voucherDataList)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          // Add vertical spacing between each sale
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
                                      sale.purchaseno,
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
                                              sale.invoicedate,
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
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding:
                                    //         const EdgeInsets.symmetric(vertical: 1),
                                    //     child:
                                    Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Text(
                                          '₹${sale.grandtotal}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    //   ),
                                    // ),
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
                                      sale.suppliername,
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
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
