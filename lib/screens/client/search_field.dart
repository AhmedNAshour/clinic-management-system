import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
    this.branch,
  }) : super(key: key);
  final String branch;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(28)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Find a doctor',
          hintStyle: TextStyle(color: Colors.grey[300]),
          suffixIcon: Icon(
            Icons.search,
            color: kPrimaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
