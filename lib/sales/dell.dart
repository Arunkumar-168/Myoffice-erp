import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayableData {
  final String id;
  final String vouchertype;
  final String date;
  final String name;
  final String voucheramount;
  final String paymentdetails;

  PayableData(
      {required this.id,
        required this.vouchertype,
        required this.date,
        required this.name,
        required this.voucheramount,
        required this.paymentdetails});

  factory PayableData.fromJson(Map<String, dynamic> json) {
    return PayableData(
      id: json['id'],
      vouchertype: json['vouchertype'],
      date: json['date'],
      name: json['name'],
      voucheramount: (json['voucheramount']),
      paymentdetails: (json['paymentdetails']),
    );
  }
}


class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  _Tab2State createState() => _Tab2State();
}


class _Tab2State extends State<Tab2> {
  List<PayableData> voucherDataList = [];
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
    var fullUrl = BaseURL + '/Api/voucher_details_payable';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        voucherDataList =
            jsonData.map((data) => PayableData.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 91, 67, 230),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: const Text(
      //     'DC Pending',
      //     style: TextStyle(
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       fontFamily: 'Arial white',
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            // Navigate to the PurePage when tapped
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const PurePage(),
            //   ),
            // );
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
                      SizedBox(height: 200),
                      Image.asset(
                        'assets/images/no.png', // Path to your "no data" picture
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Data Available',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}




  //   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             for (final sale in voucherDataList)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Container(
//                   width: double.infinity,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 100, 98, 187),
//                         Color.fromARGB(255, 102, 121, 129),
//                       ],
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(5),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.list,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 3),
//                           Text(
//                             sale.vouchertype,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 1),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.calendar_today,
//                                     color: Colors.white,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     sale.date,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.normal,
//                                       color: Colors.white,
//                                       fontFamily: 'Poppins',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             '₹${sale.voucheramount}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.factory,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             sale.name,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
