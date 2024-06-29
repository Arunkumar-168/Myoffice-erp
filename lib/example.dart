import 'package:flutter/material.dart';

class Company {
  String companyname;

  Company({
    required this.companyname,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyname: json['companyname'] ?? 'N/A',
    );
  }
}