import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/reset_password.dart';
import 'package:clinic/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseMessaging messaging = FirebaseMessaging();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    configureCallbacks();
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              // resizeToAvoidBottomPadding: false,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/Logo.png'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            RoundedInputField(
                              labelText: 'Email Address',
                              icon: Icons.email,
                              obsecureText: false,
                              hintText: 'Email',
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                            ),
                            RoundedInputField(
                              labelText: 'Password',
                              obsecureText: true,
                              icon: Icons.lock,
                              hintText: 'Password',
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                              validator: (val) => val.length < 6
                                  ? ' Enter a password 6+ chars long '
                                  : null,
                            ),
                            Container(
                              width: size.width * 0.8,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () async {
                                    // await _auth.signOut();
                                    Navigator.pushNamed(
                                        context, ResetPassword.id);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            RoundedButton(
                              text: 'SIGN IN',
                              press: () async {
                                print(email + ' ' + password);

                                if (_formKey.currentState.validate()) {
                                  print(email + ' ' + password);
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'could not sign in';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: size.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Registration Request',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: size.height * 0.025,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void configureCallbacks() {
    messaging.configure(
      onMessage: (message) async {
        print('onMessage: $message');
      },
    );
  }
}
