import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DesignElements with ChangeNotifier {
  Color _kPrimaryColor;
  Color _kPrimaryLightColor;
  Color _kPrimaryTextColor;

  Color get primaryColor => _kPrimaryColor;
  Color get primaryLightColor => _kPrimaryLightColor;
  Color get primaryTextColor => _kPrimaryTextColor;

  Future getPrimaryColor() async {
    DocumentSnapshot s = await FirebaseFirestore.instance
        .collection('constants')
        .doc('kPrimaryColor')
        .get();
    _kPrimaryColor = Color(s.data()['color'].hashCode);
    notifyListeners();
  }

  Future getPrimaryLightColor() async {
    DocumentSnapshot s = await FirebaseFirestore.instance
        .collection('constants')
        .doc('kPrimaryColor')
        .get();
    _kPrimaryLightColor = Color(s.data()['color'].hashCode);
    notifyListeners();
  }

  Future getPrimaryTextColor() async {
    DocumentSnapshot s = await FirebaseFirestore.instance
        .collection('constants')
        .doc('kPrimaryTextColor')
        .get();
    _kPrimaryTextColor = Color(s.data()['color'].hashCode);
    notifyListeners();
  }
}

const kPrimaryColor = Color(0xFF0060AD);
const kPrimaryLightColor = Color(0xFFBEBEBE);
const kPrimaryTextColor = Color(0xFF212121);
