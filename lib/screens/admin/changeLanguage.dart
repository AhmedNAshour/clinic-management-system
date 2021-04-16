import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class ChangeLanguage extends StatefulWidget {
  static const id = 'DisableUser';
  String lang;
  ChangeLanguage({String lang}) {
    this.lang = lang;
  }
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String value = 'en';
  List<S2Choice<String>> types = [
    S2Choice<String>(value: 'en', title: 'English'),
    S2Choice<String>(value: 'ar', title: 'عربي'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.lang;
  }

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
                SmartSelect<String>.single(
                  title: 'Language',
                  value: value,
                  choiceItems: types,
                  onChange: (state) => setState(() {
                    value = state.value;
                    print(value);
                  }),
                  modalType: S2ModalType.popupDialog,
                  choiceType: S2ChoiceType.chips,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                RoundedButton(
                  press: () async {
                    await DatabaseService(uid: user.uid).updateUserLang(value);
                    Navigator.pop(context);
                  },
                  text: 'CONFIRM',
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          );
  }
}
