import 'package:clinic/models/branch.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({
    Key key,
    @required this.branch,
  }) : super(key: key);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 10),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${branch.name}',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
