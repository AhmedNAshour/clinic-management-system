import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/clients_list_secretary_booking.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class BookingStep1 extends StatefulWidget {
  @override
  _BookingStep1State createState() => _BookingStep1State();
}

class _BookingStep1State extends State<BookingStep1> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 53),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AutoSizeText(
                    'Step 1: Choose Patient',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                    minFontSize: 20,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(53), topRight: Radius.circular(53)),
              color: kPrimaryLightColor,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: size.width * 0.5,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Search Clients",
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() => search = val);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: kPrimaryColor,
                            ),
                            enableFeedback: showCancel,
                            onPressed: () {
                              setState(() {
                                search = '';
                                textController.text = '';
                                showCancel = false;
                              });
                            },
                            // DateFormat('dd-MM-yyyy').format(value))
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ClientListSecretaryBooking(search),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
