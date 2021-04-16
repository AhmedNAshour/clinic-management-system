import 'dart:async';

import 'package:clinic/models/branch.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/admin/branch_info.dart';
import '../../screens/admin/disable_branch.dart';
import '../../screens/admin/edit_branch.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;

class BranchCard extends StatefulWidget {
  const BranchCard({
    Key key,
    @required this.branch,
  }) : super(key: key);

  final Branch branch;

  @override
  _BranchCardState createState() => _BranchCardState();
}

class _BranchCardState extends State<BranchCard> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;
  Completer<GoogleMapController> _controller = Completer();

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(snippet: 'Address'),
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(widget.branch.latitude, widget.branch.longitude),
      zoom: 14.4746,
    );
    return GestureDetector(
      onTap: () {
        CustomBottomSheets().showDynamicCustomBottomSheet(
            size, BranchInfo(widget.branch), context);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.only(right: size.width * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.25,
                  height: size.width * 0.25,
                  child: GoogleMap(
                    mapType: MapType.terrain,
                    myLocationEnabled: false,
                    zoomGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: selectedPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      newGoogleMapContoller = controller;
                      // locatePosition();
                      getMarkers(
                          widget.branch.latitude, widget.branch.longitude);
                    },
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringManipulation.limitLength(
                            '${widget.branch.name}', 25),
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              launch(
                                  "tel://${widget.branch.countryDialCode}${widget.branch.phoneNumber}");
                            },
                            child: Icon(
                              Icons.phone_android_rounded,
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, EditBranch.id, arguments: {
                          'branch': widget.branch,
                        });
                      },
                      child: Icon(
                        Icons.edit_location_rounded,
                        color: kPrimaryColor,
                        size: size.width * 0.075,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.branch.status == 1
                        ? GestureDetector(
                            onTap: () {
                              CustomBottomSheets().showDynamicCustomBottomSheet(
                                  size,
                                  DisableBranch(Branch(
                                    name: widget.branch.name,
                                    docID: widget.branch.docID,
                                    address: widget.branch.address,
                                    phoneNumber: widget.branch.phoneNumber,
                                  )),
                                  context);
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Color(0xFFB5020B),
                              size: size.width * 0.075,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await DatabaseService().updateBranchStatus(
                                  id: widget.branch.docID, status: 1);
                              await NDialog(
                                dialogStyle: DialogStyle(
                                  backgroundColor: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: Container(
                                  height: size.height * 0.5,
                                  width: size.width * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.checkCircle,
                                        color: Colors.white,
                                        size: size.height * 0.125,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.05,
                                      ),
                                      Text(
                                        'Branch Enabled',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).show(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.green,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
