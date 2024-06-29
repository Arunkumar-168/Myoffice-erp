// import 'package:flutter/material.dart';
// import 'package:my_office_erp/sales/salesService.dart';
// import 'package:my_office_erp/sales/ui/sales.dart';
//
// import '../home/slide.dart';
//
// class SalesController {
//   var Salesservice = salesService();
//
//   Future<dynamic> Sales(url, context) async {
//     var response = await Salesservice.Sales(url);
//
//     // "result": "Success",
//     // "id": "2",
//     // "invoiceno": "INV/23-24/-002",
//     // "invoicedate": "2023-07-28",
//     // "customername": "SMK INDUSTRIES",
//     // "grandtotal": "4130.00"
//
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = json.decode(response.body);
//       setState(() {
//         salesDataList =
//             jsonData.map((data) => SalesData.fromJson(data)).toList();
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
