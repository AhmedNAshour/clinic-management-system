import 'package:clinic/components/lists_cards/branch_card.dart';
import 'package:clinic/components/lists_cards/branch_card_client.dart';
import 'package:clinic/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchesListClient extends StatefulWidget {
  @override
  _BranchesListClientState createState() => _BranchesListClientState();
}

class _BranchesListClientState extends State<BranchesListClient> {
  @override
  Widget build(BuildContext context) {
    final branches = Provider.of<List<Branch>>(context) ?? [];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: branches.length,
      itemBuilder: (context, index) {
        return BranchCardClient(branch: branches[index]);
      },
    );
  }
}
