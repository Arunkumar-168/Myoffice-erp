import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_office_erp/example.dart';
import 'package:my_office_erp/report/dc.dart';
import 'package:my_office_erp/report/dcpending.dart';
import 'package:my_office_erp/report/expense.dart';
import 'package:my_office_erp/report/inward.dart';
import 'package:my_office_erp/report/inwardpending.dart';
import 'package:my_office_erp/report/party.dart';
import 'package:my_office_erp/report/profoma.dart';
import 'package:my_office_erp/report/purchase.dart';
import 'package:my_office_erp/report/quation.dart';
import 'package:my_office_erp/report/voucher.dart';
import 'package:my_office_erp/sales/ui/sales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app-constant.dart';

class Chart {
  String curMonthSales;
  String curMonthPurchase;
  String curMonthReceivable;
  String curMonthPayable;
  String salesBalance;
  String purchaseBalance;
  String expense;

  Chart({
    required this.curMonthSales,
    required this.curMonthPurchase,
    required this.curMonthReceivable,
    required this.curMonthPayable,
    required this.salesBalance,
    required this.purchaseBalance,
    required this.expense,
  });

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      curMonthSales: json['curMonthSales'] ?? 'N/A',
      // Use a default value if null
      curMonthPurchase: json['curMonthpurchase'] ?? 'N/A',
      curMonthReceivable: json['curMonthreceivable'] ?? 'N/A',
      curMonthPayable: json['curMonthpayable'] ?? 'N/A',
      salesBalance: json['salesBalance'] ?? 'N/A',
      purchaseBalance: json['purchaseBalance'] ?? 'N/A',
      expense: json['expense'] ?? 'N/A',
    );
  }
}

class SlidePage extends StatefulWidget {
  static const routeName = '/skills';

  const SlidePage({Key? key}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  List<Chart> chartList = [];
  List<Company> companyList = []; // Initialize the chartList

  @override
  void initState() {
    chartList = [];
    companyList = [];
    initialize();
    Companydata();
    chart();
    super.initState();
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var baseURL = prefs.getString('url');
    if (baseURL != null) {
      BaseURL = baseURL;
    }
  }

  Future<void> chart() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url')!;
    var fullUrl = BaseURL + '/Api/Chart';
    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // print('Error : $jsonData');
      setState(() {
        chartList = jsonData.map((data) => Chart.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> Companydata() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url')!;
    var fullUrl = BaseURL + '/Api/profile';
    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // print('Error : $jsonData');
      setState(() {
        companyList = jsonData.map((data) => Company.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 91, 67, 230),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'My Office ERP ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'V',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '1.1',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (final sale in companyList)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              sale.companyname,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: const EdgeInsets.only(
                      top: 120.0, right: 13.0, left: 13.0),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0, right: 2.0, left: 2.0),
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SalesPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.bar_chart_outlined,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Sales',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DcPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.watch_later,
                                    color: Colors.deepOrange,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'DC',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const purchasePage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.shopping_cart,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Purchase',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(width: 0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const profomaPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.receipt,
                                    color: Colors.lightGreen,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Proforma',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const expensePage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.money,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Expense',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PendingPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.notification_important,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'DC\nPending',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(width: 0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const quatationPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.document_scanner_sharp,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Quotation',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const voucherPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.receipt,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Voucher',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 11),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const intPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.event_busy,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Inward\nPending',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(width: 0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const inwardPage(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  RoundedBorderWidget(
                                    icon: Icons.request_quote,
                                    color: Colors.brown,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Inward',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              // Or any other suitable parent widget
                              children: [
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PartyPage(),
                                      ),
                                    );
                                  },
                                  child: const Column(
                                    children: [
                                      RoundedBorderWidget(
                                        icon: Icons.account_balance_wallet,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      SizedBox(height: 2),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Party\nStatement',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: chartList.map((chart) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 140,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.pink,
                                Colors.purple,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sales',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Monthly Sale',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.curMonthSales}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.orange,
                                Colors.deepPurpleAccent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Purchases',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Monthly Purchases',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.curMonthPurchase}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.deepPurpleAccent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Received',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Monthly Received',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.curMonthReceivable}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 130,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.deepOrangeAccent,
                                Colors.lightBlue,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Paid',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Monthly Paid',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.curMonthPayable}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 170,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.purple,
                                Colors.deepOrangeAccent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Outstanding Balance',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'All Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.salesBalance}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 170,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.brown,
                                Colors.indigo,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Outstanding Payment',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'All Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.purchaseBalance}',
                                // Accessing chart properties
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.indigo,
                                Colors.pinkAccent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Monthly Expense',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '₹${chart.expense}',
                                // Accessing chart properties
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
                  );
                }).toList(),
              ),
            ),
// Add other widgets here
          ],
        ),
      ),
    );
  }
}

class RoundedBorderWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const RoundedBorderWidget({
    Key? key, // Corrected the key parameter
    required this.icon,
    required this.color,
  }) : super(key: key); // Corrected the super call

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      // Adjusted width to accommodate the icon and border
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Use BoxShape.circle for rounded border
        border: Border.all(
          color: Colors.green,
          width: 1, // Set the width of the border
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(
        icon,
        size: 20,
        color: color, // Change color to red
      ),
    );
  }
}
