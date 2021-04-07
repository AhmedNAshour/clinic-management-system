import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/search_input_field.dart';
import 'package:flutter/material.dart';

class SearchClientsFormAdmin extends StatefulWidget {
  const SearchClientsFormAdmin({
    Key key,
    this.changeClientNumberSearch,
    this.changeClientNameSearch,
    this.clientNameSearch,
    this.clientNumberSearch,
    this.showSearchButton,
  }) : super(key: key);

  final Function changeClientNumberSearch;
  final Function changeClientNameSearch;
  final String clientNameSearch;
  final String clientNumberSearch;
  final String showSearchButton;

  @override
  _SearchClientsFormAdminState createState() => _SearchClientsFormAdminState();
}

class _SearchClientsFormAdminState extends State<SearchClientsFormAdmin> {
  String clientNameSearch;
  String clientNumberSearch;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SearchInputField(
            initialValue: clientNameSearch,
            labelText: 'Client Name',
            iconPath: 'assets/images/client.svg',
            obsecureText: false,
            hintText: 'Client name',
            onChanged: (val) {
              clientNameSearch = val;
            },
          ),
          SearchInputField(
            initialValue: clientNumberSearch,
            labelText: 'Client Number',
            iconPath: 'assets/images/client-num.svg',
            obsecureText: false,
            hintText: 'Client number',
            onChanged: (val) => clientNumberSearch = val,
          ),
          widget.showSearchButton == 'yes'
              ? RoundedButton(
                  text: 'SEARCH',
                  press: () {
                    widget.changeClientNameSearch(clientNameSearch);
                    widget.changeClientNumberSearch(clientNumberSearch);
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
