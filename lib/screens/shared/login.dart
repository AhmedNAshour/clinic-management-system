import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/screens/shared/loading.dart';
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
              body: Container(
                color: kPrimaryLightColor,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 53),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 53, vertical: 40),
                      width: double.infinity,
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(53),
                            topRight: Radius.circular(53)),
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RoundedInputField(
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
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
