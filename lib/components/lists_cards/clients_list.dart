import 'package:clinic/components/lists_cards/client_card.dart';
import 'package:clinic/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
  List<Client> searchList = <Client>[];
  String search = '';
  ClientList(String search) {
    this.search = search;
  }
}

class _ClientListState extends State<ClientList> {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Client>>(context) ?? [];
    setState(() {
      //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
      // widget.searchList = clients
      //     .where((element) => (element.fName
      //             .toLowerCase()
      //             .contains(widget.search.toLowerCase()) ||
      //         element.lName
      //             .toLowerCase()
      //             .contains(widget.search.toLowerCase()) ||
      //         element.phoneNumber.contains(widget.search)))
      //     .toList();
      // widget.searchList.sort((a, b) {
      //   var adate = a.fName; //before -> var adate = a.expiry;
      //   var bdate = b.fName; //before -> var bdate = b.expiry;
      //   return adate.compareTo(
      //       bdate); //to get the order other way just switch `adate & bdate`
      // });
    });
    if (widget.search == '') {
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
          return ClientCard(client: widget.searchList[index]);
        },
      );
    }
  }
}
