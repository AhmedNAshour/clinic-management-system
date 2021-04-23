import 'dart:async';
import 'package:clinic/components/info_card.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/screens/admin/edit_branch.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class BranchInfo extends StatefulWidget {
  static const id = 'BranchInfo';
  Branch branch;
  BranchInfo(Branch branch) {
    this.branch = branch;
  }

  @override
  _BranchInfoState createState() => _BranchInfoState();
}

class _BranchInfoState extends State<BranchInfo> {
  // text field state

  bool loading = false;
  Map branchData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';
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
    branchData = ModalRoute.of(context).settings.arguments;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(widget.branch.latitude, widget.branch.longitude),
      zoom: 14.4746,
    );
    return loading
        ? Loading()
        : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  height: size.width * 0.4,
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
              ),
              FutureBuilder(
                future:
                    DatabaseService(uid: widget.branch.managerID).getManager(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Manager branchManager = snapshot.data;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: size.width * 0.04,
                        left: size.width * 0.04,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: kPrimaryTextColor,
                                size: size.width * 0.085,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.11),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.phone_android_rounded,
                                  color: kPrimaryColor,
                                  size: size.width * 0.075,
                                ),
                                onPressed: () {
                                  launch(
                                      "tel://${widget.branch.countryDialCode}${widget.branch.phoneNumber}");
                                },
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit_location_rounded,
                                  color: kPrimaryColor,
                                  size: size.width * 0.075,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    EditBranch.id,
                                    arguments: {
                                      'branch': widget.branch,
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          InfoCard(
                            title: LocaleKeys.branchName.tr(),
                            body: '${widget.branch.name}',
                          ),
                          InfoCard(
                            title: LocaleKeys.phoneNumber.tr(),
                            body: '${widget.branch.phoneNumber}',
                          ),
                          InfoCard(
                            title: LocaleKeys.address.tr(),
                            body: '${widget.branch.address}',
                          ),
                          InfoCard(
                            title: LocaleKeys.manager.tr(),
                            body:
                                '${branchManager.fName} ${branchManager.lName}',
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ],
          );
  }
}
