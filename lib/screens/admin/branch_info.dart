import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
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
                  height: size.width * 0.3,
                  child: GoogleMap(
                    mapType: MapType.terrain,
                    myLocationEnabled: false,
                    zoomGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: selectedPosition,
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: size.width * 0.04,
                  left: size.width * 0.04,
                ),
                child: Column(
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
                    SizedBox(height: size.height * 0.045),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.046,
                          backgroundImage: AssetImage('assets/images/call.png'),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        SvgPicture.asset(
                          'assets/images/edit.svg',
                          color: kPrimaryColor,
                          height: size.height * 0.09,
                          width: size.width * 0.09,
                        ),
                      ],
                    ),
                    InfoCard(
                      title: 'Branch name',
                      body: '${widget.branch.name}',
                    ),
                    InfoCard(
                      title: 'Phone number',
                      body: '${widget.branch.phoneNumber}',
                    ),
                    InfoCard(
                      title: 'Address',
                      body: '${widget.branch.address}',
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
