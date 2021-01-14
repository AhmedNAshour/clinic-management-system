import 'package:clinic/components/lists_cards/secretary_card.dart';
import 'package:clinic/models/secretary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretaryList extends StatefulWidget {
  @override
  _SecretaryListState createState() => _SecretaryListState();
}

class _SecretaryListState extends State<SecretaryList> {
  @override
  Widget build(BuildContext context) {
    final secretaries = Provider.of<List<Secretary>>(context) ?? [];
    return ListView.builder(
      itemCount: secretaries.length,
      itemBuilder: (context, index) {
        return SecretaryCard(secretary: secretaries[index]);
      },
    );
  }
}
