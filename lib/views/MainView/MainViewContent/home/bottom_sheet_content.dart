import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/components/typeReport/custom_report.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key, required this.position});

  final LatLng position;

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSelectionMade = false;

  final List<String> _selectedDangerItems = [];
  final List<String> _selectedAnomaliesItems = [];
  LatLng userPosition = const LatLng(0, 0);
  LatLng basePosition = const LatLng(0, 0);
  String adress = "";
  late LatLngBounds bounds;
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    userPosition = widget.position;
    basePosition = widget.position;
    _tabController = TabController(length: 2, vsync: this);
    bounds = LatLngBounds(
        LatLng(widget.position.latitude - 0.00895,
            widget.position.longitude - 0.00895),
        LatLng(widget.position.latitude + 0.00895,
            widget.position.longitude + 0.00895));

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
        point: userPosition,
        builder: (ctx) => const Icon(
          Icons.location_on,
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
            'Votre signalement sera partagé avec toute la communauté. Tout les signalements sont anonymes.',
            style: TextStyle(fontSize: 16.0),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: userPosition,
                bounds: bounds,
                minZoom: 15,
                onMapEvent: (event) {
                  if (event.source.name == "dragEnd") {
                    setState(() {
                    getAddressFromLatLng(userPosition);
                  });
                  }
                },
                onPositionChanged: (position, hasGesture) {
                  if (position.center != null &&
                      bounds.contains(position.center!)) {
                    setState(() {
                      userPosition = position.center!;
                    });
                  } else {
                    setState(() {
                      LatLng closest = LatLng(
                          position.center!.latitude
                              .clamp(bounds.south, bounds.north),
                          position.center!.longitude
                              .clamp(bounds.west, bounds.east));
                      userPosition = closest;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/basic-v2/256/{z}/{x}/{y}@2x.png?key=By3OUeKIWraENXWoFzSV',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers,
                ),
                CircleLayer(circles: [CircleMarker(point: basePosition, radius: 250, color: const Color.fromARGB(139, 204, 155, 1),)],)
              ],
            ),
          ),
          Text(adress),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Danger',
              ),
              Tab(text: 'Anomalies'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.count(
                  crossAxisCount: 3,
                  children:
                      _buildSelectableItems(_selectedDangerItems, "Danger"),
                ),
                GridView.count(
                  crossAxisCount: 3,
                  children: _buildSelectableItems(
                      _selectedAnomaliesItems, "Anomalies"),
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
              const SizedBox(width: 10.0),
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
    final items = [
      ReportingType.vol,
      ReportingType.harcelement,
      ReportingType.agression,
      ReportingType.insecurite,
      ReportingType.violence
    ];
    return items.map((item) {
      final isSelected = selectedItems.contains(item.title);
      return CustomReport(
          reportingType: item,
          onPressed: () => setState(() {
                if (!isSelected) {
                  selectedItems.add(item.title);
                  print("Est il sélectionné ? $isSelected, ${selectedItems.toString()}");
                } else {
                  print("Est il sélectionné ? $isSelected, ${selectedItems
                      .toString()}");
                  selectedItems.remove(item.title);
                }
                  _isSelectionMade = _selectedDangerItems.isNotEmpty ||
                      _selectedAnomaliesItems.isNotEmpty;
              }));
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
          'latitude': userPosition.latitude,
          'longitude': userPosition.longitude,
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
        userPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          adress =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
