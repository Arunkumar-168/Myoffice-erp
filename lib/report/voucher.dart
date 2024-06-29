import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/sales/dell.dart';
import 'package:my_office_erp/sales/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class voucherPage extends StatefulWidget {
  const voucherPage({Key? key}) : super(key: key);

  @override
  _voucherPageState createState() => _voucherPageState();
}

class voucherData {
  final String id;
  final String vouchertype;
  final String date;
  final String name;
  final String voucheramount;
  final String paymentdetails;

  voucherData(
      {required this.id,
      required this.vouchertype,
      required this.date,
      required this.name,
      required this.voucheramount,
      required this.paymentdetails});

  factory voucherData.fromJson(Map<String, dynamic> json) {
    return voucherData(
      id: json['id'],
      vouchertype: json['vouchertype'],
      date: json['date'],
      name: json['name'],
      voucheramount: (json['voucheramount']),
      paymentdetails: (json['paymentdetails']),
    );
  }
}

class _voucherPageState extends State<voucherPage> {
  List<voucherData> voucherDataList = [];
  bool isLoading = false;
  var BaseURL;
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
    var fullUrl = BaseURL + '/Api/voucher_report';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        voucherDataList =
            jsonData.map((data) => voucherData.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 2,
    child:Scaffold(
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
          'Voucher Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial white',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // Set the preferred size of the bottom widget
          child: Container(
            color: Colors.white, // Set the background color of the entire TabBar
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white, // Set the color of the indicator (for Tab 1)
              ),
              labelColor: Colors.black, // Color of the selected tab label
              unselectedLabelColor: Colors.grey, // Color of the unselected tab labels
              tabs: [
                Tab(text: 'RECEIVABLE'),
                Tab(text: 'PAYABLE'),
              ],
              // Wrap the TabBar with a SizedBox to set width and height
              // Adjust width and height values as needed
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero, // Remove any padding around the indicator
            ),
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () {
            // Navigate to the pending page when the sale item is tapped
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const PrintPage(),
            //   ),
            // );
          },
          child:isLoading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 91, 67, 230)),
            ),
          )
              :
            const TabBarView(
              children: [
                Tab1(),
                Tab2(),
              ],
            ),
        ),

    ),
    );
  }
}

