import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_bloc.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_event.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_state.dart';
import 'package:swafe/components/IconButton/icon_button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/marker/custom_grouped_marker.dart';
import 'package:swafe/components/marker/custom_marker.dart';
import 'package:swafe/models/signalement/signalement_model.dart';
import 'package:swafe/views/main/tabs_available/map/bottom_sheet_content.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  final MapController mapController = MapController();
  late Position position;
  double zoom = 9.2;
  bool isPositionInitialized = false;

  Map<String, SignalementModel> signalementMap = {};
  List<Marker> markersList = [];
  LatLng userLocation = const LatLng(0, 0);
  List<SignalementModel>? signalements;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    BlocProvider.of<SignalementBloc>(context).add(GetSignalementsEvent());
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
    Uri url = Uri.parse("tel:17");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> requestPhonePermission() async {
    PermissionStatus status = await Permission.phone.status;

    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.phone.request();
      if (!newStatus.isGranted) {
        if (kDebugMode) {
          print('Phone permission was denied');
        }
      }
    }
  }

  void _getUserLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        isPositionInitialized = true;
      });
      updateLocationMarker(position);
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de l'obtention de la position : $e");
      }
    }
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
            position: LatLng(position.latitude, position.longitude),
          ),
        );
      },
    );
  }

  void _buildMarkers(double zoom) {
    setState(() {
      List<Marker> markers = [];
      List<List<SignalementModel>> clusters = [];
      double radius = 800 / (pow(2, zoom) / 2);

      // Create clusters
      for (var signalement in signalements!) {
        bool added = false;
        for (var cluster in clusters) {
          for (var signalementInCluster in cluster) {
            if (calculateDistance(
                LatLng(
                  signalement.coordinates.latitude,
                  signalement.coordinates.longitude,
                ),
                LatLng(
                  signalementInCluster.coordinates.latitude,
                  signalementInCluster.coordinates.longitude,
                )) <=
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
          sumLatitude += signalement.coordinates.latitude;
          sumLongitude += signalement.coordinates.longitude;
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
      } else if (signalements!.isNotEmpty) {
        double sumLatitude = 0;
        double sumLongitude = 0;
        signalements?.forEach((value) {
          sumLatitude += value.coordinates.latitude;
          sumLongitude += value.coordinates.longitude;
        });
        double avgLatitude = sumLatitude / signalements!.length;
        double avgLongitude = sumLongitude / signalements!.length;
        mapController.move(LatLng(avgLatitude, avgLongitude), 13);
      } else {
        mapController.move(const LatLng(48.866667, 2.333333), 13);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignalementBloc, SignalementState>(
      listener: (context, state) {
        if (state is GetSignalementsSuccess || state is CreateSignalementSuccess) {
          setState(() {
            signalements =
                BlocProvider.of<SignalementBloc>(context).signalements;
          });
          _buildMarkers(zoom);
        }
        if (state is GetSignalementsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: state.message,
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
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
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=${dotenv.env['MAPTILER_API_KEY']}',
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
            child: isPositionInitialized ?
            CustomIconButton(
              onPressed: () => _showBottomSheet(context),
              type: IconButtonType.image,
              image: 'assets/images/report_logo.png',
            ) : const CircularProgressIndicator(),
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
          Positioned(
            bottom: 112,
            left: 12,
            child: CustomIconButton(
              type: IconButtonType.square,
              size: IconButtonSize.L,
              iconColor: MyColors.secondary40,
              icon: Icons.near_me_outlined,
              onPressed: () {
                _calculateCenter();
              },
            ),
          ),
        ],
      ),
    );
  }
}
