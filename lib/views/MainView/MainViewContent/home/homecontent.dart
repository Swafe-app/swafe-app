import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/components/IconButton/icon_button.dart';
import 'package:swafe/components/marker/custom_grouped_marker.dart';
import 'package:swafe/components/marker/custom_marker.dart';
import 'package:swafe/firebase/firebase_database_service.dart';
import 'package:swafe/firebase/model/signalement.dart';
import 'package:swafe/views/MainView/MainViewContent/home/bottom_sheet_content.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  final dbService = FirebaseDatabaseService();
  final MapController mapController = MapController();
  late Position position;
  double zoom = 9.2;

  Map<String, SignalementModel> signalementMap = {};
  List<Marker> markersList = [];

  LatLng userLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
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
          _buildMarkers(zoom);
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

  double calculateDistance(LatLng point1, LatLng point2) {
    return const Distance().as(LengthUnit.Kilometer, point1, point2);
  }

  void updateLocationMarker(Position position) {
    if (userLocation.latitude == position.latitude &&
        userLocation.longitude == position.longitude) return;

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
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
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _getDataFromFirebase();
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
                  onMapEvent: (event) {
                    if (event.source == MapEventSource.multiFingerEnd) {
                      _buildMarkers(event.camera.zoom);
                    }
                  },
                  initialCenter: const LatLng(48.866667, 2.333333),
                  initialZoom: zoom,
                  maxZoom: 20,
                  interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=By3OUeKIWraENXWoFzSV',
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
          bottom: 272,
          right: 12,
          child: CustomIconButton(
            onPressed: () => _showBottomSheet(context),
            type: IconButtonType.image,
            image: 'assets/images/report_logo.png',
          ),
        ),
        Positioned(
          bottom: 196,
          right: 12,
          child: CustomIconButton(
            onPressed: () => _callPolice(),
            type: IconButtonType.image,
            image: 'assets/images/call_logo.png',
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: MyColors.neutral100,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: BottomSheetContent(
              position: LatLng(position.latitude, position.longitude)),
        );
      },
    );
  }

  Map<String, SignalementModel> getNonNearbySignalements(Position userPosition,
      Map<String, SignalementModel> signalementMap, double maxDistanceInKm) {
    Map<String, SignalementModel> nonNearbySignalements = {};

    signalementMap.forEach((key, value) {
      double distance = calculateDistance(
          LatLng(userPosition.latitude, userPosition.longitude),
          LatLng(value.latitude, value.longitude));
      if (distance > maxDistanceInKm) {
        nonNearbySignalements[key] = value;
      }
    });

    return nonNearbySignalements;
  }

  void _buildMarkers(double zoom) {
    setState(() {
      List<Marker> markers = [];
      List<List<SignalementModel>> clusters = [];
      double radius = 1700 /
          (pow(2, zoom) / 2); // Adjust the radius based on the zoom level

      // Create clusters
      for (var signalement in signalementMap.values) {
        bool added = false;
        for (var cluster in clusters) {
          for (var signalementInCluster in cluster) {
            if (calculateDistance(
                    LatLng(signalement.latitude, signalement.longitude),
                    LatLng(signalementInCluster.latitude,
                        signalementInCluster.longitude)) <=
                radius) {
              cluster.add(signalement);
              added = true;
              break;
            }
          }
        }
        if (!added) {
          clusters.add([signalement]);
        }
      }

      // Create markers
      for (var cluster in clusters) {
        double sumLatitude = 0;
        double sumLongitude = 0;
        for (var signalement in cluster) {
          sumLatitude += signalement.latitude;
          sumLongitude += signalement.longitude;
        }
        double avgLatitude = sumLatitude / cluster.length;
        double avgLongitude = sumLongitude / cluster.length;

        if (cluster.length > 1) {
          markers.add(CustomGroupedMarker(
            point: LatLng(avgLatitude, avgLongitude),
            numberReports: cluster.length,
            imagePath: convertStringToReportingType(
                    cluster[0].selectedDangerItems.first)
                .pin,
          ));
        } else {
          markers.add(CustomMarker(
            point: LatLng(avgLatitude, avgLongitude),
            reportingType: convertStringToReportingType(
                cluster[0].selectedDangerItems.first),
          ));
        }
      }

      markers.add(
        Marker(
          width: 37.7,
          height: 37.7,
          point: userLocation,
          child: SizedBox(
            height: 37.7,
            width: 37.7,
            child: SvgPicture.asset(
              'assets/images/userMarker.svg',
              width: 37.7,
              height: 37.7,
            ),
          ),
        ),
      );
      markersList = markers;
    });
  }

  void _calculateCenter() {
    setState(() {
      if (userLocation.latitude != 0.0 && userLocation.longitude != 0.0) {
        mapController.move(userLocation, 13);
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
