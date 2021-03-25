import 'package:clinic/components/lists_cards/client_card.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
  String search = '';
  ClientList({String isSearch}) {
    this.search = isSearch;
  }
}

class _ClientListState extends State<ClientList> {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Client>>(context) ?? [];

    if (widget.search == 'yes') {
      if (clients.isNotEmpty) {
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            return ClientCard(client: clients[index]);
          },
        );
      }
      return NoResults(
        text: 'No Clients Found',
      );
    } else {
      return ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ClientCard(client: clients[index]);
        },
      );
    }
  }
}
