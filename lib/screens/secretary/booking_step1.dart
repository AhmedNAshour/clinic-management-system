import 'package:clinic/components/forms/secretary_search_clients.dart';
import 'package:clinic/components/lists_cards/clients_list_secretary_booking.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingStep1 extends StatefulWidget {
  static const id = 'bookingStep1';
  @override
  _BookingStep1State createState() => _BookingStep1State();
}

class _BookingStep1State extends State<BookingStep1> {
  var textController = new TextEditingController();
  String search = '';

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
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              height: size.height * 0.1,
              width: double.infinity,
              color: kPrimaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.1),
                  Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'Please select a client',
              style: TextStyle(
                color: kPrimaryTextColor,
                fontSize: size.width * 0.05,
              ),
            ),
            // SizedBox(height: size.height * 0.02),
            SearchClientsForm(
              changeClientNameSearch: changeClientNameSearch,
              changeClientNumberSearch: changeClientNumberSearch,
              clientNameSearch: searchClientName,
              clientNumberSearch: searchClientNumber,
              showSearchButton: 'no',
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: Container(
                child: StreamProvider<List<Client>>.value(
                  value: DatabaseService().clients,
                  initialData: [],
                  child: ClientListSecretaryBooking(
                      searchClientName, searchClientNumber),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
