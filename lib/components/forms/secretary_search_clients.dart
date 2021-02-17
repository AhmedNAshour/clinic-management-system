import 'package:clinic/components/forms/search_input_field.dart';
import 'package:flutter/material.dart';

class SearchClientsForm extends StatefulWidget {
  const SearchClientsForm({
    Key key,
    this.changeClientNumberSearch,
    this.changeClientNameSearch,
    this.clientNameSearch,
    this.clientNumberSearch,
  }) : super(key: key);

  final Function changeClientNumberSearch;
  final Function changeClientNameSearch;
  final String clientNameSearch;
  final String clientNumberSearch;

  @override
  _SearchClientsFormState createState() => _SearchClientsFormState();
}

class _SearchClientsFormState extends State<SearchClientsForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SearchInputField(
            initialValue: widget.clientNameSearch,
            labelText: 'Client Name',
            iconPath: 'assets/images/client.svg',
            obsecureText: false,
            hintText: 'Client name',
            onChanged: (val) {
              widget.changeClientNameSearch(val);
            },
          ),
          SearchInputField(
            initialValue: widget.clientNumberSearch,
            labelText: 'Client Number',
            iconPath: 'assets/images/client-num.svg',
            obsecureText: false,
            hintText: 'Client number',
            onChanged: (val) {
              widget.changeClientNumberSearch(val);
            },
          ),
          // RoundedButton(
          //   text: 'SEARCH',
          //   press: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
