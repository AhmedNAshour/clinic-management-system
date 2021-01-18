import 'package:clinic/components/lists_cards/client_card.dart';
import 'package:clinic/components/lists_cards/client_card_admin.dart';
import 'package:clinic/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListAdmin extends StatefulWidget {
  @override
  _ClientListAdminState createState() => _ClientListAdminState();
  List<Client> searchList = <Client>[];
  String search = '';
  ClientListAdmin(String search) {
    this.search = search;
  }
}

class _ClientListAdminState extends State<ClientListAdmin> {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Client>>(context) ?? [];
    setState(() {
      //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
      widget.searchList = clients
          .where((element) => (element.fName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.lName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.phoneNumber.contains(widget.search)))
          .toList();
      widget.searchList.sort((a, b) {
        var adate = a.fName; //before -> var adate = a.expiry;
        var bdate = b.fName; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });
    if (widget.search == null) {
      return ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ClientCard(client: clients[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return ClientCardAdmin(client: widget.searchList[index]);
        },
      );
    }
  }
}
