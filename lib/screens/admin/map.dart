import 'dart:async';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:ndialog/ndialog.dart';
import '../shared/constants.dart';
import 'add_branchManager.dart';
import 'package:easy_localization/easy_localization.dart';

class MapSelect extends StatefulWidget {
  static const id = 'MapSelect';
  @override
  _MapSelectState createState() => _MapSelectState();
}

class _MapSelectState extends State<MapSelect> {
  double latitude;
  double longitude;
  String error = '';
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;
  CountryCode countryCode;

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

  void locatePosition() async {
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = p;
    LatLng latlatPosition = LatLng(p.latitude, p.longitude);
    CameraPosition camera =
        new CameraPosition(target: latlatPosition, zoom: 14);
    newGoogleMapContoller.animateCamera(CameraUpdate.newCameraPosition(camera));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    Map branchData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    countryCode = branchData['countryCode'];
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: size.width * 0.04),
                    height: size.height * 0.1,
                    width: double.infinity,
                    color: kPrimaryColor,
                    child: Row(
                      children: [
                        BackButton(
                          color: Colors.white,
                        ),
                        SizedBox(width: size.width * 0.15),
                        Text(
                          LocaleKeys.locationOnMap.tr(),
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GoogleMap(
                        mapType: MapType.terrain,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          newGoogleMapContoller = controller;
                          locatePosition();
                        },
                        markers: Set<Marker>.of(markers.values),
                        onTap: (tapped) async {
                          markers.clear();
                          final coordinated = new geoco.Coordinates(
                            tapped.latitude,
                            tapped.longitude,
                          );
                          var address = await Geocoder.local
                              .findAddressesFromCoordinates(coordinated);
                          var firstAddress = address.first;
                          getMarkers(tapped.latitude, tapped.longitude);
                          latitude = tapped.latitude;
                          longitude = tapped.longitude;
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RawMaterialButton(
          onPressed: () async {
            if (latitude != null && longitude != null) {
              CustomBottomSheets().showCustomBottomSheet(
                  size,
                  AddBranchManager(
                    branch: Branch(
                      name: branchData['name'],
                      address: branchData['address'],
                      countryCode: countryCode.code,
                      countryDialCode: countryCode.dialCode,
                      phoneNumber: branchData['phoneNumber'],
                      longitude: longitude,
                      latitude: latitude,
                    ),
                  ),
                  context);
            } else {
              setState(() {
                error = LocaleKeys.pleaseSelectALocation.tr();
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.5,
              color: kPrimaryColor,
              child: Center(
                child: Text(
                  LocaleKeys.addManager.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
