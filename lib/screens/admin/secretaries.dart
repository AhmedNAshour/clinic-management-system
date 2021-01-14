import 'package:clinic/components/lists_cards/secretaries_list.dart';
import 'package:clinic/models/secretary.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Secretaries extends StatefulWidget {
  @override
  _SecretariesState createState() => _SecretariesState();
}

class _SecretariesState extends State<Secretaries> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: MultiProvider(
        providers: [
          StreamProvider<List<Secretary>>.value(
              value: DatabaseService().secretaries),
        ],
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
                          'Secretaries',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: SecretaryList(),
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
              Navigator.pushNamed(context, '/addSecretaryScreen');
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
