import 'package:clinic/components/lists_cards/branches_list.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'add_branch.dart';

class Branches extends StatefulWidget {
  static final id = 'Branches';

  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  String branchName = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: size.width * 0.04),
              height: size.height * 0.1,
              width: double.infinity,
              color: kPrimaryColor,
              child: Row(
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.25),
                  Text(
                    'Branches',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: Container(
                width: size.width * 0.9,
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<Branch>>.value(
                      value: DatabaseService().branches,
                      initialData: [],
                    ),
                  ],
                  child: BranchesList(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 2),
            borderRadius: BorderRadius.circular(360),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddBranch.id);
              // Navigator.pushNamed(context, '/secretaryAddClientScreen');
            },
            backgroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.plus,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
