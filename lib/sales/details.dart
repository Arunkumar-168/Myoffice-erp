import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherData {
  final String id;
  final String voucherid;
  final String vouchertype;
  final String customername;
  final String paidamount;
  final String paymentmode;

  VoucherData({
    required this.id,
    required this.voucherid,
    required this.vouchertype,
    required this.customername,
    required this.paidamount,
    required this.paymentmode,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) {
    return VoucherData(
      id: json['id'] ?? '',
      voucherid: json['voucherid'] ?? '',
      vouchertype: json['vouchertype'] ?? '',
      customername: json['customername'] ?? '',
      paidamount: json['paidamount']?.toString() ?? '0',
      paymentmode: json['paymentmode'] ?? '',
    );
  }
}

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  List<VoucherData> voucherDataList = [];
  bool isLoading = false;
  String? baseURL;

  @override
  void initState() {
    super.initState();
    initialize().then((_) {
      fetchVoucherData();
    });
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var url = prefs.getString('url');
    setState(() {
      baseURL = url;
    });
  }

  Future<void> fetchVoucherData() async {
    if (baseURL == null || baseURL!.isEmpty) {
      print('Base URL is not set');
      return;
    }

    var fullUrl = '$baseURL/Api/voucher_details_receivable';

    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });

    try {
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          voucherDataList =
              jsonData.map((data) => VoucherData.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false; // After fetching data, set isLoading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 91, 67, 230)),
        ),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final sale in voucherDataList)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 80,
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
                              sale.voucherid,
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
                                padding: const EdgeInsets.symmetric(vertical: 1),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      sale.paymentmode,
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
                            Text(
                              '₹${sale.paidamount}',
                              style: const TextStyle(
                                fontSize: 12,
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
                              Icons.factory,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              sale.customername,
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
    );
  }
}
