import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/firebase/firebase_database_service.dart';
import 'package:swafe/views/MainView/MainViewContent/home/bottom_sheet_content.dart';

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

  List<Map<String, dynamic>> firebaseData = [];
  bool isFirebaseInitialized = false;

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
  void initState() async {
    super.initState();
    _getDataFromFirebase();
    await _requestLocationPermission();
  }

  void _getDataFromFirebase() {
    try {
      dbService.databaseReference.child('signalements').onValue.listen((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;

          // Mise à jour de la liste firebaseData
          firebaseData.clear();
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              firebaseData.add(value);
            }
          });

          // Appel à setState pour mettre à jour l'interface utilisateur
          setState(() {});
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

  void _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
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
    return Column(
      children: <Widget>[
        Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: const LatLng(48.866667, 2.333333),
              zoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          child: const Text('Ouvrir le Bottom Sheet'),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const BottomSheetContent();
      },
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    for (var data in firebaseData) {
      double latitude = data['coordinates']['latitude'];
      double longitude = data['coordinates']['longitude'];

      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(latitude, longitude),
          builder: (ctx) => const Icon(
            Icons.pin_drop,
            color: Colors.red,
            size: 50.0,
          ),
        ),
      );
    }

    markers.add(userLocationMarker);

    return markers;
  }

  void _calculateCenter() {
    setState(() {
      if (userLocationMarker.point.latitude != 0.0 &&
          userLocationMarker.point.longitude != 0.0) {
        mapController.move(userLocationMarker.point, 13);
      } else if (firebaseData.isNotEmpty) {
        double sumLatitude = 0;
        double sumLongitude = 0;

        for (var data in firebaseData) {
          double latitude = data['coordinates']['latitude'];
          double longitude = data['coordinates']['longitude'];

          sumLatitude += latitude;
          sumLongitude += longitude;
        }

        double avgLatitude = sumLatitude / firebaseData.length;
        double avgLongitude = sumLongitude / firebaseData.length;

        mapController.move(LatLng(avgLatitude, avgLongitude), 13);
      } else {
        mapController.move(const LatLng(48.866667, 2.333333), 13);
      }
    });
  }
}
