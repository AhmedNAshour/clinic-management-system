import 'package:clinic/components/lists_cards/client_card_secretary_booking.dart';
import 'package:clinic/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListSecretaryBooking extends StatefulWidget {
  @override
  _ClientListSecretaryBookingState createState() =>
      _ClientListSecretaryBookingState();
  List<Client> searchList = <Client>[];
  String clientNameSearch = '';
  String clientNumberSearch = '';
  ClientListSecretaryBooking(
      String clientNameSearch, String clientNumberSearch) {
    this.clientNameSearch = clientNameSearch;
    this.clientNumberSearch = clientNumberSearch;
  }
}

class _ClientListSecretaryBookingState
    extends State<ClientListSecretaryBooking> {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Client>>(context) ?? [];
    setState(() {
      widget.searchList = clients
          .where((element) => (element.fName
                  .toLowerCase()
                  .contains(widget.clientNameSearch.toLowerCase()) &&
              element.phoneNumber.contains(widget.clientNumberSearch)))
          .toList();
      widget.searchList.sort((a, b) {
        var adate = a.fName; //before -> var adate = a.expiry;
        var bdate = b.fName; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });
    if (widget.clientNameSearch == '' && widget.clientNumberSearch == '') {
      return ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ClientCardSecretaryBooking(client: clients[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return ClientCardSecretaryBooking(client: widget.searchList[index]);
        },
      );
    }
  }
}
