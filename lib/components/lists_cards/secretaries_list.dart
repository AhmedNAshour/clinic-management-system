import 'package:clinic/components/lists_cards/secretary_card.dart';
import 'package:clinic/models/secretary.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretaryList extends StatefulWidget {
  @override
  _SecretaryListState createState() => _SecretaryListState();
  String search = '';
  SecretaryList({String isSearch}) {
    this.search = isSearch;
  }
}

class _SecretaryListState extends State<SecretaryList> {
  @override
  Widget build(BuildContext context) {
    final managers = Provider.of<List<Secretary>>(context) ?? [];

    if (widget.search == 'yes') {
      if (managers.isNotEmpty) {
        return ListView.builder(
          itemCount: managers.length,
          itemBuilder: (context, index) {
            return SecretaryCard(manager: managers[index]);
          },
        );
      }
      return NoResults(
        text: 'No Managers Found',
      );
    } else {
      return ListView.builder(
        itemCount: managers.length,
        itemBuilder: (context, index) {
          return SecretaryCard(manager: managers[index]);
        },
      );
    }
  }
}
