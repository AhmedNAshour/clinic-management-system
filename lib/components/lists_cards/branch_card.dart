import 'package:clinic/models/branch.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/admin/branch_info.dart';

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
        CustomBottomSheets()
            .showCustomBottomSheet(size, BranchInfo(widget.branch), context);
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
                              launch("tel://${widget.branch.phoneNumber}");
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
                      onTap: () {},
                      child: Icon(
                        Icons.edit_location_rounded,
                        color: kPrimaryColor,
                        size: size.width * 0.075,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.cancel,
                        color: Color(0xFFB5020B),
                        size: size.width * 0.075,
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
