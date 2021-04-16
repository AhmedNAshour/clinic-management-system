import 'package:clinic/models/branch.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class DisableBranch extends StatefulWidget {
  static const id = 'DisableUser';
  Branch branch;
  DisableBranch(Branch branch) {
    this.branch = branch;
  }

  @override
  _DisableBranchState createState() => _DisableBranchState();
}

class _DisableBranchState extends State<DisableBranch> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.04,
              left: size.width * 0.04,
              bottom: size.height * 0.02,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kPrimaryTextColor,
                      size: size.width * 0.085,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  'Are you sure you want to disable ${widget.branch.name} branch ? This will disable all doctors , managers , and appointments associated with it !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: kPrimaryTextColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Color(0xFFDDF0FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await DatabaseService().updateBranchStatus(
                              id: widget.branch.docID, status: 0);
                          Navigator.pop(context);
                          await NDialog(
                            dialogStyle: DialogStyle(
                              backgroundColor: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Container(
                              height: size.height * 0.5,
                              width: size.width * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.checkCircle,
                                    color: Colors.white,
                                    size: size.height * 0.125,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Text(
                                    'Branch Disabled',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).show(context);
                        },
                        child: Text(
                          'YES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
