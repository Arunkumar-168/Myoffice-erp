// import 'package:academy/api/constants.dart';
// import 'package:academy/course/util.dart';
// import 'package:academy/online/abc.dart';
// import 'package:flutter/material.dart';
// import '../api/star_display_widget.dart';
// import '../online/course.dart';
// import '../online/custom_text.dart';
//
// class WishlistGrid extends StatelessWidget {
//   final Course? course;
//
//   const WishlistGrid({
//     Key? key,
//     required this.course,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context)
//             .pushNamed(Skills.routeName, arguments: course!.id);
//       },
//       child: SizedBox(
//         width: double.infinity,
//         // height: 400,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           elevation: 0.1,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 1,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: FadeInImage.assetNetwork(
//                     placeholder: 'assets/images/loading_animated.gif',
//                     image: course!.thumbnail.toString(),
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                            SizedBox(
//                             height: 42,
//                             child: CustomText(
//                               text: course!.title!.length < 38
//                                   ? course!.title
//                                   : course!.title!.substring(0, 37),
//                               fontSize: 14,
//                               colors: kTextLightColor,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 2.0),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   child: StarDisplayWidget(
//                                     value: int.tryParse(course!.rating!) ?? 0,
//                                     filledStar: const Icon(
//                                       Icons.star,
//                                       color: kStarColor,
//                                       size: 15,
//                                     ),
//                                     unfilledStar: const Icon(
//                                       Icons.star_border,
//                                       color: kStarColor,
//                                       size: 15,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 40,
//                                   child: Text(
//                                     '( ${course?.number_of_ratings}.0 )',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: CustomText(
//                                     text: '${course?.shareable_link}% Completed',
//                                     fontSize: 12,
//                                     colors: Colors.black54,
//                                   ),
//                                 ),
//                                 CustomText(
//                                   text:
//                                   '${course?.instructor_name}/${course?.instructor_name}',
//                                   fontSize: 12,
//                                   colors: Colors.black54,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 10, left: 15, right: 15),
//                       child: SizedBox(
//                         height: 42,
//                         child: CustomText(
//                           text: course!.title!.length < 38
//                               ? course!.title
//                               : course!.title!.substring(0, 37),
//                           fontSize: 14,
//                           colors: kTextLightColor,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: TextButton.icon(
//                         icon: const Icon(
//                           Icons.highlight_remove,
//                           size: 15,
//                           color: Colors.black38,
//                         ),
//                         label: const Text(
//                           'Remove from wishlist',
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadiusDirectional.circular(20),
//                             // side: const BorderSide(color: kRedColor),
//                           ),
//                         ),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) =>
//                                 buildPopupDialog(context, course!.id),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
