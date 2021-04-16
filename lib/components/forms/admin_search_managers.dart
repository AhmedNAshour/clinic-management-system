import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/search_input_field.dart';
import 'package:flutter/material.dart';

class SearchManagersFormAdmin extends StatefulWidget {
  const SearchManagersFormAdmin({
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
  _SearchManagersFormAdminState createState() =>
      _SearchManagersFormAdminState();
}

class _SearchManagersFormAdminState extends State<SearchManagersFormAdmin> {
  String clientNameSearch;
  String clientNumberSearch;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchInputField(
            initialValue: clientNameSearch,
            labelText: 'Manager Name',
            iconPath: 'assets/images/client.svg',
            obsecureText: false,
            hintText: 'Manager name',
            onChanged: (val) {
              clientNameSearch = val;
            },
          ),
          SearchInputField(
            initialValue: clientNumberSearch,
            labelText: 'Manager Number',
            iconPath: 'assets/images/client-num.svg',
            obsecureText: false,
            hintText: 'Manager number',
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
