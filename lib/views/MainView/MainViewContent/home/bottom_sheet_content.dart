import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSelectionMade = false;

  final List<String> _selectedDangerItems = [];
  final List<String> _selectedAnomaliesItems = [];

  double markerLatitude = 51.509364; // London latitude
  double markerLongitude = -0.128928; // London longitude

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Get the user's current location and set the marker coordinates
    getLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: latlong.LatLng(markerLatitude, markerLongitude),
        builder: (ctx) => const Icon(
          Icons.pin_drop,
          color: Colors.red,
          size: 50.0,
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Spécifier la situation rencontrée',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Votre signalement sera partagé avec toute la communauté. Les signalements sont anonymes.',
            style: TextStyle(fontSize: 16.0),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Danger'),
              Tab(text: 'Anomalies'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children:
                      _buildSelectableItems(_selectedDangerItems, "Danger"),
                ),
                ListView(
                  children: _buildSelectableItems(
                      _selectedAnomaliesItems, "Anomalies"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: latlong.LatLng(markerLatitude, markerLongitude),
                zoom: 9.2,
                onPositionChanged: (position, hasGesture) {
                  if (position.center != null) {
                    setState(() {
                      markerLatitude = position.center!.latitude;
                      markerLongitude = position.center!.longitude;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: _isSelectionMade
                    ? () {
                        _sendDataToFirebase();
                      }
                    : null,
                child: const Text('Valider'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSelectableItems(
      List<String> selectedItems, String tabName) {
    final items = ['Item 1', 'Item 2', 'Item 3'];
    return items.map((item) {
      final isSelected = selectedItems.contains(item);
      return CheckboxListTile(
        title: Text(item),
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value != null) {
              if (value) {
                selectedItems.add(item);
              } else {
                selectedItems.remove(item);
              }
              _isSelectionMade = _selectedDangerItems.isNotEmpty ||
                  _selectedAnomaliesItems.isNotEmpty;
            }
          });
        },
      );
    }).toList();
  }

  void _sendDataToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final selectedData = {
        'userId': user.uid,
        'selectedDangerItems': _selectedDangerItems,
        'selectedAnomaliesItems': _selectedAnomaliesItems,
        'coordinates': {
          'latitude': markerLatitude,
          'longitude': markerLongitude,
        },
      };

      try {
        await databaseReference.child('signalements').push().set(selectedData);
        if (kDebugMode) {
          print("Données envoyées à Firebase avec succès.");
        }
      } catch (error) {
        if (kDebugMode) {
          print("Erreur lors de l'envoi des données à Firebase : $error");
        }
      }
    }
  }

  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        markerLatitude = position.latitude;
        markerLongitude = position.longitude;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }
}
