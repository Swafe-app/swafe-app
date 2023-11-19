import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/components/Button/iconbutton.dart';
import 'package:swafe/components/marker/custom_marker.dart';
import 'package:swafe/firebase/firebase_database_service.dart';
import 'package:swafe/firebase/model/signalement.dart';
import 'package:swafe/views/MainView/MainViewContent/home/bottom_sheet_content.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Map Example'),
        ),
        body: const HomeContent(),
      ),
    ));

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  final dbService = FirebaseDatabaseService();
  final MapController mapController = MapController();
  late Position position;

  Map<String, SignalementModel> signalementMap = {};
  List<Marker> markersList = [];

  Marker userLocationMarker = Marker(
    width: 80.0,
    height: 80.0,
    point: const LatLng(0.0, 0.0),
    builder: (ctx) => const Icon(
      Icons.location_on,
      color: Colors.blue,
      size: 50.0,
    ),
  );

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
    _requestLocationPermission();
  }

  void _getDataFromFirebase() {
    try {
      dbService.databaseReference.child('signalements').onValue.listen((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> rawData =
              event.snapshot.value as Map<dynamic, dynamic>;
          Map<String, SignalementModel> data = {};

          rawData.forEach((key, value) {
            data[key] = SignalementModel(
              latitude: value['coordinates']['latitude'] as double,
              longitude: value['coordinates']['longitude'] as double,
              selectedDangerItems:
                  List<String>.from(value['selectedDangerItems']),
              userId: value['userId'] as String,
            );
          });

          // Mise à jour de la liste signalementMap
          signalementMap = data;

          // Appel à _buildMarkers pour mettre à jour l'interface utilisateur
          _buildMarkers();
        } else {
          if (kDebugMode) {
            print("Aucune donnée Firebase disponible.");
          }
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print(
            "Erreur lors de la récupération des données depuis Firebase : $error");
      }
    }
  }

  void updateLocationMarker(Position position) {
    if (userLocationMarker.point.latitude == position.latitude &&
        userLocationMarker.point.longitude == position.longitude) return;

    setState(() {
      userLocationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(position.latitude, position.longitude),
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 50.0,
        ),
      );
    });

    _calculateCenter();
  }

  Future<void> _requestLocationPermission() async {
    // Check if user authorize location permission access
    final LocationPermission checkPermission =
        await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.always ||
        checkPermission == LocationPermission.whileInUse) {
      return _getUserLocation();
    }

    final LocationPermission requestPermission =
        await Geolocator.requestPermission();

    if (requestPermission == LocationPermission.always ||
        requestPermission == LocationPermission.whileInUse) {
      _getUserLocation();
    } else {
      if (kDebugMode) {
        print("L'utilisateur a refusé l'autorisation de localisation.");
      }
    }
  }

  void _callPolice() async {
    String cleanedPhoneNumber = "17".replaceAll(RegExp(r'\D'), '');
    String url = "tel:$cleanedPhoneNumber";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (kDebugMode) {
        if (kDebugMode) {
          print("Impossible de lancer l'appel vers $cleanedPhoneNumber");
        }
      }
    }
  }

  void _getUserLocation() async {
    try {
        position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      updateLocationMarker(position);
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de l'obtention de la position : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: const LatLng(48.866667, 2.333333),
                  zoom: 9.2,
                  maxZoom: 14.92,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=By3OUeKIWraENXWoFzSV',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: markersList,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * .4,
          right: 0.01,
          child: CustomIconButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            size: 70,
            image: 'assets/images/report_logo.png',
            ),
          ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * .30,
          right: 0.01,
          child: CustomIconButton(
            onPressed: () {
              _callPolice();
            },
            size: 70,
            image: 'assets/images/call_logo.png',
          ),
        ),
      ],
    );
  }


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent(position: LatLng(position.latitude, position.longitude));
      },
    );
  }

  void _buildMarkers() {
    setState(() {
      List<Marker> markers = [];

      signalementMap.forEach((key, value) {
        log(value.selectedDangerItems.first);
        markers.add(
          CustomMarker(reportingType: convertStringToReportingType(value.selectedDangerItems.first), point: LatLng(value.latitude, value.longitude))
        );
      });

      markers.add(userLocationMarker);
      markersList = markers;
    });
  }

  void _calculateCenter() {
    setState(() {
      if (userLocationMarker.point.latitude != 0.0 &&
          userLocationMarker.point.longitude != 0.0) {
        mapController.move(userLocationMarker.point, 13);
      } else if (signalementMap.isNotEmpty) {
        double sumLatitude = 0;
        double sumLongitude = 0;
        signalementMap.forEach((key, value) {
          sumLatitude += value.latitude;
          sumLongitude += value.longitude;
        });
        double avgLatitude = sumLatitude / signalementMap.length;
        double avgLongitude = sumLongitude / signalementMap.length;
        mapController.move(LatLng(avgLatitude, avgLongitude), 13);
      } else {
        mapController.move(const LatLng(48.866667, 2.333333), 13);
      }
    });
  }
}
