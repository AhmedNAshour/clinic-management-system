import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/components/lists_cards/branch_card.dart';
import 'package:clinic/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchesList extends StatefulWidget {
  @override
  _BranchesListState createState() => _BranchesListState();
}

class _BranchesListState extends State<BranchesList> {
  @override
  Widget build(BuildContext context) {
    final branches = Provider.of<List<Branch>>(context) ?? [];
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) {
        return BranchCard(branch: branches[index]);
      },
    );
  }
}
