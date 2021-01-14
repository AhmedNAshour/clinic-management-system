// import 'package:clinic/models/branch.dart';
// import 'package:clinic/screens/shared/constants.dart';
// import 'package:flutter/material.dart';

// class BranchButton extends StatelessWidget {
//   const BranchButton({
//     Key key,
//     this.branch,
//   }) : super(key: key);
//   final Branch branch;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       margin: EdgeInsets.only(left: 20),
//       height: size.width * 0.2,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: FlatButton(
//           onPressed: () {},
//           color: Colors.white,
//           child: Text(
//             branch.name,
//             style: TextStyle(
//                 color: kPrimaryColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         ),
//       ),
//     );
//   }
// }
