import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
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
                                text: 'SIGN UP',
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerWithEmailAndPasword(
                                            'ahmed@gmail.com',
                                            '123123',
                                            'Ahmed',
                                            'Ashour',
                                            '01003369055',
                                            'male',
                                            'secretary');
                                    if (result == null) {
                                      setState(() {
                                        error = 'could not sign in';
                                        loading = false;
                                      });
                                    } else {}
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
}
