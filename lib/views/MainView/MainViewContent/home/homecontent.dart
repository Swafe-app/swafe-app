import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/views/MainView/MainViewContent/home/bottom_sheet_content.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> firebaseData = [];
  bool isFirebaseInitialized = false;

  Marker userLocationMarker = Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(0.0, 0.0),
    builder: (ctx) => Container(
      child: Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 50.0,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        isFirebaseInitialized = true;
      });
      _getDataFromFirebase();
      _checkLocationPermission();
    } catch (error) {
      print("Erreur d'initialisation Firebase : $error");
    }
  }

  void _getDataFromFirebase() {
    try {
      databaseReference.child('signalements').onValue.listen((event) {
        if (event.snapshot.value != null) {
          print("Données Firebase récupérées : ${event.snapshot.value}");
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
          print("Aucune donnée Firebase disponible.");
        }
      });
    } catch (error) {
      print(
          "Erreur lors de la récupération des données depuis Firebase : $error");
    }
  }

  void updateLocationMarker(Position position) {
    setState(() {
      userLocationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(position.latitude, position.longitude),
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    });
  }

  void _checkLocationPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getUserLocation();
    } else if (permission == LocationPermission.denied) {
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getUserLocation();
    } else {
      print("L'utilisateur a refusé l'autorisation de localisation.");
    }
  }

  void _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      updateLocationMarker(position);
    } catch (e) {
      print("Erreur lors de l'obtention de la position : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isFirebaseInitialized
            ? Text('Firebase est initialisé avec succès.')
            : Text('Firebase n\'est pas encore initialisé.'),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: _calculateCenter(),
              zoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'], // Ajoutez les sous-domaines
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
          child: Text('Ouvrir le Bottom Sheet'),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent();
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
          builder: (ctx) => Container(
            child: Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 50.0,
            ),
          ),
        ),
      );
    }

    markers.add(userLocationMarker);

    return markers;
  }

  LatLng _calculateCenter() {
    if (firebaseData.isNotEmpty) {
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

      return LatLng(avgLatitude, avgLongitude);
    } else {
      return LatLng(51.509364, -0.128928);
    }
  }
}

void launchUrl(Uri uri) async {
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    print('Could not launch $uri');
  }
}

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Map Example'),
        ),
        body: HomeContent(),
      ),
    ));
