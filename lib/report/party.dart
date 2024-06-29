import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  _PartyPageState createState() => _PartyPageState();
}

class state {
  final String date;
  final String customerName;
  final String amt;
  final String invoiceno;
  final String receiptamt;
  final String receiptno;
  final String paymentmode;

  state({
    required this.date,
    required this.customerName,
    required this.amt,
    required this.invoiceno,
    required this.receiptamt,
    required this.receiptno,
    required this.paymentmode,
  });

  factory state.fromJson(Map<String, dynamic> json) {
    return state(
      date: json['date'],
      customerName: json['customername'],
      amt: json['amt'].toString(),
      invoiceno: json['invoiceno'],
      receiptamt: json['receiptamt'],
      receiptno: json['receiptno'],
      paymentmode: json['paymentmode'],
    );
  }
}

class _PartyPageState extends State<PartyPage> {
  List<state> partyList = [];
  var baseUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initialize();
    fetchPartyData();
  }

  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var baseURL = prefs.getString('url');
    print(baseURL);
    if (baseURL != null) {
      baseUrl = baseURL;
    }
  }

  Future<void> fetchPartyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var prefs = await SharedPreferences.getInstance();
      baseUrl = prefs.getString('url');
      var fullUrl = baseUrl + '/Api/party_statement';

      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          partyList = jsonData.map((data) => state.fromJson(data)).toList();
        });
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
        backgroundColor: const Color.fromARGB(255, 91, 67, 230),
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
          'Party Statement Report',
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 91, 67, 230),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final sale in partyList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        height: 150,
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
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Date',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Text(
                                          sale.date, // Insert newline character before payment mode
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Receipt No',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Text(
                                          sale.receiptno, // Insert newline character before payment mode
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Amount',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Text(
                                          '₹${sale.amt}', // Insert newline character before payment mode
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Receipt Amount',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Text(
                                          '₹${sale.receiptamt}', // Insert newline character before payment mode
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Customer Name',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Flexible(
                                          child: Text(
                                            sale.customerName, // Insert newline character before payment mode
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Payment Mode',
                                          style: TextStyle(
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
                                const SizedBox(width: 3), // Add some spacing between the text and '-'
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 1), // Add some spacing between '-' and the payment mode text
                                Expanded(
                                  flex: 15, // Adjust the flex value as needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        Text(
                                          sale.paymentmode, // Insert newline character before payment mode
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
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
