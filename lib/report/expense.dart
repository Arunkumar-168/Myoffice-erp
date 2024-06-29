import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class expensePage extends StatefulWidget {
  const expensePage({Key? key}) : super(key: key);

  @override
  _expensePageState createState() => _expensePageState();
}

class Expense {
  final String id;
  final String headers;
  final String date;
  final String purpose;
  final String paymentdetails;
  final String name;
  final String overallamount;

  Expense({
    required this.id,
    required this.headers,
    required this.date,
    required this.name,
    required this.overallamount,
    required this.purpose,
    required this.paymentdetails,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      headers: json['headers'],
      date: json['date'],
      name: json['name'],
      purpose: json['purpose'],
      paymentdetails: json['paymentdetails'],
      overallamount: (json['overallamount']),
    );
  }
}

class _expensePageState extends State<expensePage> {
  List<Expense> ExpenseDataList = [];
  bool isLoading = false;
  var BaseURL;

  @override
  void initState() {
    fetchExpenseData();
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

  Future<void> fetchExpenseData() async {
    var prefs = await SharedPreferences.getInstance();
    BaseURL = prefs.getString('url');
    var fullUrl = BaseURL + '/Api/expense_report';

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        ExpenseDataList =
            jsonData.map((data) => Expense.fromJson(data)).toList();
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
          'Expense Report',
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
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor:  Color.fromARGB(255, 91, 67, 230),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Expense Report',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontFamily: 'Arial white',
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10),
//         child: GestureDetector(
//           onTap: () {
//             // Navigate to the pending page when the sale item is tapped
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => const PrintPage(),
//             //   ),
//             // );
//           },
//           child:isLoading
//               ? Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 91, 67, 230)),
//             ),
//           )
//               :  Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               for (final sale in ExpenseDataList)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   // Add vertical spacing between each sale
//                   child: Container(
//                     width: double.infinity,
//                     height: 88,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromARGB(255, 100, 98, 187),
//                           Color.fromARGB(255, 102, 121, 129),
//                         ],
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(5),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.list,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             Text(
//                               sale.headers,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 fontFamily: 'Poppins',
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 1),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       sale.date,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal,
//                                         color: Colors.white,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             // Expanded(
//                             //   child: Padding(
//                             //     padding:
//                             //         const EdgeInsets.symmetric(vertical: 1),
//                             //     child:
//                                 Row(
//                                   children: [
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       '₹${sale.overallamount}',
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.factory,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               sale.name,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 fontFamily: 'Poppins',
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 1),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   sale.paymentdetails,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // Expanded(
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.symmetric(vertical: 1),
//                         //     child:
//                             Row(
//                               children: [
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   sale.purpose,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
