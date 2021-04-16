import 'package:clinic/components/lists_cards/clients_list.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/manager/addClient.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/forms/admin_search_clients.dart';

class ClientsAdmin extends StatefulWidget {
  static final id = 'ClientsAdmin';
  @override
  _ClientsAdminState createState() => _ClientsAdminState();
}

class _ClientsAdminState extends State<ClientsAdmin> {
  String searchClientName = '';
  String searchClientNumber = '';

  changeClientNameSearch(newClientName) {
    setState(() {
      searchClientName = newClientName;
    });
  }

  changeClientNumberSearch(newClientNumber) {
    setState(() {
      searchClientNumber = newClientNumber;
    });
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.2),
                  Text(
                    'Clients',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: size.width * 0.2),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter insideState) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.02,
                                        right: size.width * 0.02,
                                        bottom: size.height * 0.01),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: size.height * 0.001,
                                          color: kPrimaryLightColor,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              color: kPrimaryTextColor),
                                        ),
                                        SizedBox(width: size.width * 0.28),
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: kPrimaryTextColor,
                                            size: size.width * 0.085,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: SearchClientsFormAdmin(
                                      changeClientNameSearch:
                                          changeClientNameSearch,
                                      changeClientNumberSearch:
                                          changeClientNumberSearch,
                                      clientNameSearch: searchClientName,
                                      clientNumberSearch: searchClientNumber,
                                      showSearchButton: 'yes',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
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
                child: StreamProvider<List<Client>>.value(
                  value: DatabaseService().getClients(
                    clientName: searchClientName,
                    clientNumber: searchClientNumber,
                    status: 1,
                  ),
                  child: ClientList(
                    isSearch: 'yes',
                  ),
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
              CustomBottomSheets()
                  .showCustomBottomSheet(size, AddClient(), context);
            },
            backgroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.userPlus,
              color: kPrimaryColor,
              size: size.width * 0.07,
            ),
          ),
        ),
      ),
    );
  }
}
