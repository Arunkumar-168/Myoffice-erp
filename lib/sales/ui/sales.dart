import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../download/sales print.dart';

class SalesPage extends StatefulWidget {
  static const String routeName = '/sale';
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class SalesData {
  final String id;
  final String invoiceNo;
  final String invoiceDate;
  final String customerName;
  final double grandTotal;

  SalesData({
    required this.id,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.customerName,
    required this.grandTotal,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      id: json['id'],
      invoiceNo: json['invoiceno'],
      invoiceDate: json['invoicedate'],
      customerName: json['customername'],
      grandTotal: double.parse(json['grandtotal']),
    );
  }
}

class _SalesPageState extends State<SalesPage> {


  List<SalesData> salesDataList = [];
  bool isLoading = false;
  var BaseURL;

  @override
  void initState() {
    initialize();
    fetchSalesData();
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
    if (baseURL != null) {
      BaseURL = baseURL;
    }
  }

  Future<void> fetchSalesData() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url');
    var fullUrl = BaseURL + '/Api/salesinvoice';

    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        salesDataList =
            jsonData.map((data) => SalesData.fromJson(data)).toList();
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
          'Sales Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial', // Corrected font family name
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 48, 17, 223),
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final sale in salesDataList)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      PrintPage.routeName,
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
                              sale.invoiceNo,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 5),
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
                                      sale.invoiceDate,
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 25),
                                    Text(
                                      '₹${sale.grandTotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
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