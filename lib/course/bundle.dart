import 'package:flutter/material.dart';

class nodata extends StatefulWidget {
  @override
  _nodataState createState() => _nodataState();
}

class _nodataState extends State<nodata> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 1), // Added padding to TextField
                // child: TextField(
                //   decoration: InputDecoration(
                //     hintText: 'Wishlist',
                //     hintStyle: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //       fontFamily: 'Arial black',
                //     ),
                //
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
      // bottomNavigationBar: const BottomButtons(),
    ),
    );
  }
}

// class BottomButtons extends StatefulWidget {
//   const BottomButtons({Key? key}) : super(key: key);
//
//   @override
//   _BottomButtonsState createState() => _BottomButtonsState();
// }
//
// class _BottomButtonsState extends State<BottomButtons> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50, // Adjust the height as needed
//       width: double.infinity, // Adjust the width as needed
//       child: Form(
//         key: _formKey,
//         child: Container(
//           // padding:
//           //     const EdgeInsets.symmetric(vertical: 2), // Reduced vertical padding
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SlidePage(),
//                       // accessToken: widget.accessToken
//                     ),
//                   );
//                 },
//                 child: const SizedBox(
//                   height: 50, // Adjust the height as needed
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.home,
//                         color: Color.fromARGB(255, 14, 61, 216),
//                         size: 20, // Reduced icon size
//                       ),
//                       Text(
//                         'Home',
//                         style: TextStyle(
//                           fontSize: 10, // Reduced font size
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 1),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => logoutpage(),
//                         // accessToken: widget.accessToken
//                       ),
//                     );
//                   },
//                   child: const SizedBox(
//                     height: 35,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.school,
//                             color: Color.fromARGB(255, 14, 61, 216), size: 20),
//                         Text(
//                           'My Course',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 1),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => logoutpage(),
//                         // accessToken: widget.accessToken
//                       ),
//                     );
//                   },
//                   child: const SizedBox(
//                     height: 35,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.favorite,
//                             color: Color.fromARGB(255, 14, 61, 216), size: 20),
//                         Text(
//                           'Wishlist',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 1),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => logoutpage(),
//                         // accessToken: widget.accessToken
//                       ),
//                     );
//                   },
//                   child: const SizedBox(
//                     height: 35,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.account_circle,
//                             color: Color.fromARGB(255, 14, 61, 216), size: 20),
//                         Text(
//                           'Account',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
