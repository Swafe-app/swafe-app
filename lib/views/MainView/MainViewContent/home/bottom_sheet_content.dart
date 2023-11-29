import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
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
  String pin = 'assets/images/pinDown.svg';
  String? address;
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

  bool isWithinCircle(LatLng center, LatLng point, double radius) {
    const distance = Distance();
    return distance(center, point) <= radius;
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
        getAddressFromLatLng(userPosition);
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
          address =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Widget> _buildSelectableItems(
      List<String> selectedItems, String tabName) {
    late List<ReportingType> items;
    if(tabName == "Danger") {
      items = [
        ReportingType.autre,
        ReportingType.vol,
        ReportingType.harcelement,
        ReportingType.agressionSexuelle,
        ReportingType.incendie,
        ReportingType.violenceVerbale,
        ReportingType.insecurite,
        ReportingType.violence,
        ReportingType.harcelement,
        ReportingType.conduite,
        ReportingType.ivresse,
        ReportingType.obstacle,
      ];
    } else{
      items = [
        ReportingType.autre,
        ReportingType.travaux,
        ReportingType.accessibilite,
        ReportingType.eclairage,
        ReportingType.voiture,
        ReportingType.inondation,
        ReportingType.chaussee,
        ReportingType.feuPieton,
      ];
    }

    return items.map((item) {
      final isSelected = selectedItems.contains(item.title);
      return CustomReport(
          reportingType: item,
          onPressed: () => setState(() {
                if (!isSelected) {
                  selectedItems.add(item.title);
                  print(
                      "Est il sélectionné ? $isSelected, ${selectedItems.toString()}");
                } else {
                  print(
                      "Est il sélectionné ? $isSelected, ${selectedItems.toString()}");
                  selectedItems.remove(item.title);
                }
                _isSelectionMade = _selectedDangerItems.isNotEmpty ||
                    _selectedAnomaliesItems.isNotEmpty;
              }));
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 8,
            decoration: BoxDecoration(
              color: MyColors.neutral70,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Spécifier la situation rencontrée',
            style: typographyList
                .firstWhere((typo) => typo.name == "Title Large Medium")
                .style
                .copyWith(color: MyColors.primary10),
          ),
          const SizedBox(height: 8),
          Text(
            textAlign: TextAlign.center,
            'Votre signalement sera partagé avec toute la communauté. Tout les signalements sont anonymes.',
            style: typographyList
                .firstWhere((typo) => typo.name == "Body Large Medium")
                .style
                .copyWith(color: MyColors.primary10),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 145,
              child: FlutterMap(
                options: MapOptions(
                  center: userPosition,
                  bounds: bounds,
                  minZoom: 15,
                  onMapEvent: (event) {
                    if (event.source.name == "dragEnd") {
                      setState(() {
                        pin = 'assets/images/pinDown.svg';
                        getAddressFromLatLng(userPosition);
                      });
                    }
                  },
                  onPositionChanged: (position, hasGesture) {
                    if (position.center != null) {
                      if (isWithinCircle(
                          basePosition, position.center!, 1000)) {
                        setState(() {
                          pin = 'assets/images/pinUp.svg';
                          userPosition = position.center!;
                        });
                      } else {
                        final bearing = const Distance()
                            .bearing(basePosition, position.center!);
                        final closestPoint = const Distance()
                            .offset(basePosition, 1000, bearing);
                        setState(() {
                          pin = 'assets/images/pinUp.svg';
                          userPosition = closestPoint;
                        });
                      }
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
                    markers: [
                      Marker(
                        width: 50.0,
                        height: 50.0,
                        point: userPosition,
                        builder: (ctx) => SvgPicture.asset(
                          pin,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: basePosition,
                        radius: 300,
                        color: MyColors.secondary40.withOpacity(0.2),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (address != null && address!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Text(address!,
                  style: typographyList
                      .firstWhere((typo) => typo.name == "Body Large Medium")
                      .style
                      .copyWith(color: MyColors.primary10)),
            ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: MyColors.secondary40,
            labelColor: MyColors.primary10,
            unselectedLabelColor: MyColors.neutral40,
            labelStyle: typographyList
                .firstWhere((typo) => typo.name == "Body Large Regular")
                .style,
            tabs: const [
              Tab(
                text: 'Dangers',
              ),
              Tab(
                text: 'Anomalies',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children:
                      _buildSelectableItems(_selectedDangerItems, "Danger"),
                ),
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _buildSelectableItems(
                      _selectedAnomaliesItems, "Anomalies"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                type: ButtonType.outlined,
                label: 'Annuler',
                mainAxisSize: MainAxisSize.max,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 20),
              CustomButton(
                label: 'Envoyer',
                mainAxisSize: MainAxisSize.max,
                isDisabled: _isSelectionMade ? false : true,
                onPressed:
                _isSelectionMade ? () => _sendDataToFirebase() : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
