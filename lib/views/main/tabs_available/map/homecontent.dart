import 'dart:async';
import 'dart:math';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import '../../../tutorial/tutorialItemcontent.dart';

class HomeContent extends StatefulWidget {
  final GlobalKey navbarKey;

  const HomeContent({super.key, required this.navbarKey});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  final MapController mapController = MapController();
  late Position position;
  double zoom = 18.2;
  bool isPositionInitialized = false;
  List<Marker> markersList = [];
  LatLng userLocation = const LatLng(0, 0);
  List<SignalementModel>? signalements;
  bool tutorialDone = false;
  final policeButton = GlobalKey(debugLabel: 'callPoliceButton');
  final reportButton = GlobalKey(debugLabel: 'reportButton');
  final reportModel = GlobalKey();
  List<TutorialItem> targets = [];

  @override
  void initState() {
    _requestLocationPermission();
    super.initState();
  }

  void initTutorial() {
    setState(() {
      markersList = [
        CustomMarker(
          globalKey: reportModel,
          point: LatLng(position.latitude - 0.001, position.longitude + 0.001),
          reportingType: ReportingType.vol,
        ),
      ];
    });
    targets.addAll({
      TutorialItem(
        globalKey: policeButton,
        borderRadius: const Radius.circular(50),
        child: TutorialItemContent(
            targetKey: policeButton,
            title: "Appel d'urgence à la police",
            content:
                "En cas de dancer, chaque minute compte. Gagnez du temps, en cliquant sur ce bouton, vous pouvez facilement et rapidement appler les forces de l'ordre"),
      ),
      TutorialItem(
        globalKey: reportButton,
        borderRadius: const Radius.circular(50),
        child: TutorialItemContent(
            targetKey: reportButton,
            title: "Signaler un danger",
            content:
                "Pour signaler un danger, cliquez sur ce bouton. Par la suite, vous pourrez spécifier le danger rencontré afin de prévenir la commnauté de celui-ci."),
      ),
      TutorialItem(
        globalKey: reportModel,
        borderRadius: const Radius.circular(50),
        child: TutorialItemContent(
            iscenter: false,
            targetKey: reportModel,
            title: "Connaissez les dangers sur votre route",
            content:
                "En cliquant sur un pin, vous pourrez connaître le type de danger, la position ainsi que le moment où il a été déclaré. Vous pouvez également certifier celui-ci en cliquant sur l’icône like."),
      ),
      TutorialItem(
        globalKey: widget.navbarKey,
        child: TutorialItemContent(
            targetKey: widget.navbarKey,
            iscenter: true,
            title: "Numéros d’urgence",
            content:
                "Découvrez la liste des numéros d’urgence et des lignes d’aides. Vous pouvez les appeler à tout moment en cliquant sur l’icône téléphone. Ces services d’urgence sont ouverts 7j/7 24h/24."),
      ),
    });
  }

  void checkIfFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      initTutorial();
      Future.delayed(const Duration(seconds: 1), () {
        Tutorial.showTutorial(context, targets ,onTutorialComplete: () {
          prefs.setBool('isFirstRun', false);
          setState(() {
            markersList = [];
            tutorialDone = true;
          });
          BlocProvider.of<SignalementBloc>(context).add(GetSignalementsEvent());
        });
      });
    } else {
      BlocProvider.of<SignalementBloc>(context).add(GetSignalementsEvent());
      setState(() {
        tutorialDone = true;
      });
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

  Future<void> _getUserLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        isPositionInitialized = true;
      });
      checkIfFirstRun();
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
            reports: cluster,
            ctx: context,
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _calculateCenter() {
    setState(() {
      if (userLocation.latitude != 0.0 && userLocation.longitude != 0.0) {
        _animatedMapMove(userLocation, this.zoom);
      } else if (signalements!.isNotEmpty) {
        double sumLatitude = 0;
        double sumLongitude = 0;
        signalements?.forEach((value) {
          sumLatitude += value.coordinates.latitude;
          sumLongitude += value.coordinates.longitude;
        });
        double avgLatitude = sumLatitude / signalements!.length;
        double avgLongitude = sumLongitude / signalements!.length;
        _animatedMapMove(LatLng(avgLatitude, avgLongitude), 13);
      } else {
        _animatedMapMove(const LatLng(48.866667, 2.333333), 13);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignalementBloc, SignalementState>(
      listener: (context, state) {
        if ((state is GetSignalementsSuccess ||
            state is CreateSignalementSuccess) & tutorialDone) {
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
                      urlTemplate:
                          'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=${dotenv.env['MAPTILER_API_KEY']}',
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
              key: policeButton,
              onPressed: () => _callPolice(),
              type: IconButtonType.image,
              image: 'assets/images/call_logo.png',
            ),
          ),
          Positioned(
            bottom: 112,
            right: 21,
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
