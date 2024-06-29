import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  static const routeName = '/contact';

  const ContactPage({Key? key}) : super(key: key);

  void _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace '1234567890' with your actual phone number
    _launchPhoneDialer('8608701222');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 91, 67, 230),
        title: const Text(
          'MYOFFICE ERP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial Black',
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchPhoneDialer('8608701222'); // Replace with your phone number
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 91, 67, 230),
            // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Call Us',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial Black',
            ),
          ),
        ),
      ),
    );
  }
}
