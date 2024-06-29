import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 91, 67, 230),
          // Remove the leading icon button
          title: const Text(
            'About Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Arial Black',
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 20,
              left: 40,
              height: 600,
              width: 300,
              child: Image.asset(
                'assets/images/red.jpeg',
                fit: BoxFit.cover,
                height: 500,
                width: 300, // Adjust as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
