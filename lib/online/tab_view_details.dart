import 'package:flutter/material.dart';
import '../api/constants.dart';
import 'custom_text.dart';




class TabViewDetails extends StatelessWidget {


  final String? titleText;
  final List<String>? listText;

  const TabViewDetails({
    Key? key,
    required this.titleText,
    required this.listText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: CustomText(
                text: titleText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                colors: kDarkGreyColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (ctx, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      text: listText![index],
                      colors: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Arial black',
                    ),
                  ],
                ),
              );
            },
            itemCount: listText!.length,
          ),
        ),
      ],
    );
  }
}

