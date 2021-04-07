import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/text_field_container.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndialog/ndialog.dart';
import 'constants.dart';

class ResetPassword extends StatefulWidget {
  static const id = 'ResetPassword';
  final Function toggleView;
  ResetPassword({this.toggleView});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    // configureCallbacks();
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              // resizeToAvoidBottomPadding: false,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          SizedBox(
                            width: size.width * 0.08,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.04),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  color: kPrimaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.15,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/images/ResetPassword.svg'),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFieldContainer(
                                  child: TextFormField(
                                    obscureText: false,
                                    validator: (val) =>
                                        val.isEmpty ? 'Invalid Email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle: TextStyle(
                                        color: kPrimaryColor,
                                      ),
                                      icon: SvgPicture.asset(
                                          'assets/images/email.svg'),
                                      hintText: 'Email',
                                      focusColor: kPrimaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                RoundedButton(
                                  text: 'Reset Password',
                                  press: () async {
                                    if (_formKey.currentState.validate()) {
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: email);
                                        await NDialog(
                                          dialogStyle: DialogStyle(
                                            backgroundColor: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          content: Container(
                                            height: size.height * 0.5,
                                            width: size.width * 0.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/check2.svg',
                                                    fit: BoxFit.none,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.05,
                                                ),
                                                Text(
                                                  'Password Sent',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.04,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  'Please check your email and reset your password',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.025,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.04,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // Navigator.popUntil(context,
                                                        //     (route) => false);
                                                      },
                                                      child: Container(
                                                        child: Center(
                                                          child: Text(
                                                            'SIGN IN',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  size.height *
                                                                      0.025,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 20,
                                                          horizontal: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).show(context);
                                        error = '';
                                      } catch (e) {
                                        AwesomeDialog(
                                          context: context,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Invalid Email',
                                          desc: 'Please provide a valid email',
                                        )..show();
                                      }
                                    }
                                  },
                                ),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  // void configureCallbacks() {
  //   messaging.configure(
  //     onMessage: (message) async {
  //       print('onMessage: $message');
  //     },
  //   );
  // }
}
