import 'package:clinic/components/lists_cards/clients_list.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientsSearchresults extends StatefulWidget {
  static const id = 'ClientsSearchResults';
  @override
  _ClientsSearchresultsState createState() => _ClientsSearchresultsState();
}

class _ClientsSearchresultsState extends State<ClientsSearchresults> {
  Map searchData = {};
  int numAppointmentsFound;

  updateNumAppointmentsFound(numAppointmentsFound) {
    setState(() {
      this.numAppointmentsFound = numAppointmentsFound;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);
    searchData = ModalRoute.of(context).settings.arguments;

    // searchData =

    return FutureBuilder(
      future: DatabaseService(uid: user.uid).getSecretaryBranch(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String secretaryBranch = snapshot.data;
          return SafeArea(
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    height: size.height * 0.1,
                    width: double.infinity,
                    color: kPrimaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(
                          color: Colors.white,
                        ),
                        SizedBox(width: size.width * 0.17),
                        Text(
                          'Search Results',
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  numAppointmentsFound != null
                      ? Container(
                          child:
                              Text('($numAppointmentsFound) Results found for'),
                        )
                      : Container(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        width: size.width * 0.9,
                        child: StreamProvider.value(
                            value: DatabaseService().getClientsBySearch(
                              searchData['clientName'],
                              searchData['clientNumber'],
                              1,
                            ),
                            initialData: [],
                            child: ClientList(
                              isSearch: 'yes',
                              // isSearch: 'yes',
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
