import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/components/lists_cards/branches_list.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Branches extends StatefulWidget {
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
      child: StreamProvider<List<Branch>>.value(
        value: DatabaseService().branches,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: size.height * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SvgPicture.asset(
                  'assets/images/clients.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(53),
                        topRight: Radius.circular(53)),
                    color: kPrimaryLightColor,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 40,
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: kPrimaryLightColor,
                                ),
                                Text(
                                  'BACK',
                                  style: TextStyle(
                                      color: kPrimaryLightColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Branches',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: BranchesList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.5,
                      child: DraggableScrollableSheet(
                          initialChildSize: 1.0,
                          maxChildSize: 1.0,
                          minChildSize: 0.25,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Add Branch',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          RoundedInputField(
                                            icon: Icons.info,
                                            obsecureText: false,
                                            hintText: 'Branch Name',
                                            onChanged: (val) {
                                              setState(() => branchName = val);
                                            },
                                            validator: (val) => val.isEmpty
                                                ? 'Enter a name'
                                                : null,
                                          ),
                                          RoundedButton(
                                            text: 'Add',
                                            press: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                await DatabaseService()
                                                    .addBranch(
                                                        branchName: branchName);
                                              }
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            error,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  },
                  isScrollControlled: true);
            },
            child: Icon(
              Icons.add,
            ),
            backgroundColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
