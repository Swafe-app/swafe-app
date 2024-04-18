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
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_bloc.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_event.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/IconButton/icon_button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/marker/custom_grouped_marker.dart';
import 'package:swafe/components/marker/custom_marker.dart';
import 'package:swafe/models/signalement/signalement_model.dart';
import 'package:swafe/models/user/user_model.dart';
import 'package:swafe/views/main/tabs_available/map/bottom_sheet_content.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  double zoom = 18;
  bool isPositionInitialized = false;
  Timer? timer;

  Map<String, SignalementModel> signalementMap = {};
  List<Marker> markersList = [];
  Marker userMarker = Marker(
    width: 37.7,
    height: 37.7,
    point: const LatLng(0, 0),
    child: SizedBox(
      height: 37.7,
      width: 37.7,
      child: SvgPicture.asset(
        'assets/images/userMarker.svg',
        width: 37.7,
        height: 37.7,
      ),
    ),
  );
  LatLng userLocation = const LatLng(0, 0);
  List<SignalementModel>? signalements;
  bool tutorialDone = false;
  final policeButton = GlobalKey(debugLabel: 'callPoliceButton');
  final reportButton = GlobalKey(debugLabel: 'reportButton');
  final reportModel = GlobalKey();
  List<TutorialItem> targets = [];
  late UserModel user;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        userMarker = _buildUserMarker(userLocation);
      });
    });
    user = context.read<AuthBloc>().user!;
    BlocProvider.of<SignalementBloc>(context).add(GetSignalementsEvent());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initTutorial() {
    setState(() {
      markersList = [
        CustomMarker(
          globalKey: reportModel,
          point:
              LatLng(position.latitude - 0.0001, position.longitude + 0.0001),
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
        Tutorial.showTutorial(context, targets, onTutorialComplete: () {
          prefs.setBool('isFirstRun', false);
          setState(() {
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
    const distance = Distance();
    double meters = distance.as(LengthUnit.Meter, point1, point2);
    double kilometers = meters / 1000;
    return kilometers;
  }

  void updateLocationMarker(Position position) {
    if (userLocation.latitude == position.latitude &&
        userLocation.longitude == position.longitude) return;

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      userMarker =
          _buildUserMarker(LatLng(position.latitude, position.longitude));
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
    PermissionStatus status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }
    String cleanedPhoneNumber = "17".replaceAll(RegExp(r'\D'), '');
    String url = "tel:$cleanedPhoneNumber";
    if (await launchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
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
      Map<String, List<SignalementModel>> grid = {};
      double gridSize = 0.0002 * pow(2, 20 - zoom);

      for (var signalement in signalements!) {
        int gridX = (signalement.coordinates.longitude / gridSize).floor();
        int gridY = (signalement.coordinates.latitude / gridSize).floor();
        String gridKey = "$gridX,$gridY";

        if (!grid.containsKey(gridKey)) grid[gridKey] = [];
        grid[gridKey]!.add(signalement);
      }

      for (var entry in grid.entries) {
        var cluster = entry.value;
        double sumLat = 0;
        double sumLon = 0;

        for (var signalement in cluster) {
          sumLat += signalement.coordinates.latitude;
          sumLon += signalement.coordinates.longitude;
        }

        LatLng center =
            LatLng(sumLat / cluster.length, sumLon / cluster.length);
        if (cluster.length > 1) {
          markers.add(CustomGroupedMarker(
            showSignalementDialog: _showSignalementDetails,
            reports: cluster,
            ctx: context,
            point: center,
            numberReports: cluster.length,
            imagePath: convertStringToReportingType(
                    cluster[0].selectedDangerItems.first)
                .pin,
          ));
        } else {
          markers.add(CustomMarker(
            onPressed: () => _showSignalementDetails(cluster[0], false),
            point: center,
            reportingType: convertStringToReportingType(
                cluster[0].selectedDangerItems.first),
          ));
        }
      }
      markersList = markers;
    });
  }

  Marker _buildUserMarker(LatLng userLocation) {
    return Marker(
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
    );
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
    final zoomTween =
        Tween<double>(begin: mapController.camera.zoom, end: destZoom);

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
        _animatedMapMove(userLocation, zoom);
      } else if (signalements!.isNotEmpty) {
        double sumLatitude = 0;
        double sumLongitude = 0;
        signalements?.forEach((value) {
          sumLatitude += value.coordinates.latitude;
          sumLongitude += value.coordinates.longitude;
        });
        double avgLatitude = sumLatitude / signalements!.length;
        double avgLongitude = sumLongitude / signalements!.length;
        _animatedMapMove(
            LatLng(avgLatitude, avgLongitude), mapController.camera.zoom);
      } else {
        _animatedMapMove(const LatLng(48.866667, 2.333333), zoom);
      }
    });
  }

  void _showSignalementDetails(SignalementModel signalement, bool isGrouped) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return BlocListener<SignalementBloc, SignalementState>(
          listener: (context, state) {
            if (state is DeleteSignalementSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 20,
                    left: 20,
                  ),
                  content: const CustomSnackbar(
                    label: 'Votre signalement a bien été supprimé.',
                  ),
                ),
              );
              Navigator.of(context).pop();
              if (isGrouped) Navigator.of(context).pop();
            }
            if (state is CreateSignalementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 20,
                    left: 20,
                  ),
                  content: CustomSnackbar(
                    isError: true,
                    label: state.message,
                  ),
                ),
              );
            }
            if (state is UpVoteSignalementSuccess ||
                state is DownVoteSignalementSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 20,
                    left: 20,
                  ),
                  content: const CustomSnackbar(
                    label: 'Votre signalement a bien été pris en compte.',
                  ),
                ),
              );
              Navigator.of(context).pop();
              if (isGrouped) Navigator.of(context).pop();
            }
            if (state is UpVoteSignalementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 20,
                    left: 20,
                  ),
                  content: CustomSnackbar(
                    isError: true,
                    label: state.message,
                  ),
                ),
              );
            }
            if (state is DownVoteSignalementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 20,
                    left: 20,
                  ),
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    color: MyColors.neutral30,
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  child: DefaultTextStyle(
                                    style: TitleXLargeMedium.copyWith(
                                      color: MyColors.neutral100,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    child: Text(
                                      signalementDangerItemEnumToString(
                                          signalement
                                              .selectedDangerItems.first),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                DefaultTextStyle(
                                  style: TitleXLargeMedium.copyWith(
                                      color: MyColors.neutral100,
                                      fontWeight: FontWeight.w700),
                                  child: Text(
                                    "${calculateDistance(userLocation, LatLng(
                                          signalement.coordinates.latitude,
                                          signalement.coordinates.longitude,
                                        )).toStringAsFixed(1)} Km d'ici",
                                    style: TitleXXLargeMedium.copyWith(
                                        color: MyColors.neutral100,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DefaultTextStyle(
                                  style: TitleXLargeMedium.copyWith(
                                      color: MyColors.neutral100,
                                      fontWeight: FontWeight.w700),
                                  child: Text(
                                    "Il y a ${calculateCreatedTimeString(signalement.createdAt!)}",
                                    style: TitleSmallMedium.copyWith(
                                        color: MyColors.neutral100),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 72,
                              height: 72,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    convertStringToReportingType(
                                      signalement.selectedDangerItems.first,
                                    ).pin,
                                  ),
                                ),
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 3,
                                    color: MyColors.defaultWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 170,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: ShapeDecoration(
                    color: MyColors.neutral100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon 12px by 12px
                      const Icon(
                        size: 32,
                        Icons.thumb_up_alt_outlined,
                        color: MyColors.primary10,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        signalement.upVote.toString(),
                        style: TitleXLargeMedium.copyWith(
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 238,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (signalement.userId == user.uid)
                        Expanded(
                          child: CustomButton(
                            isLoading: context.watch<SignalementBloc>().state
                                is DeleteSignalementLoading,
                            onPressed: () {
                              BlocProvider.of<SignalementBloc>(context).add(
                                  DeleteSignalementEvent(id: signalement.id));
                            },
                            label: "Supprimer",
                          ),
                        )
                      else if (signalement.userVotedList.contains(user.uid))
                        const Expanded(
                          child: CustomButton(
                            isDisabled: true,
                            label: "Signalement déjà voté",
                          ),
                        )
                      else ...[
                        Expanded(
                          child: CustomButton(
                            isLoading: context.watch<SignalementBloc>().state
                                    is DownVoteSignalementLoading ||
                                context.watch<SignalementBloc>().state
                                    is UpVoteSignalementLoading,
                            fillColor: MyColors.neutral100,
                            icon: Icons.thumb_down_alt_outlined,
                            label: "Plus là",
                            onPressed: () {
                              BlocProvider.of<SignalementBloc>(context).add(
                                DownVoteSignalementEvent(
                                    id: signalement.id, userId: user.uid),
                              );
                            },
                            type: ButtonType.outlined,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButton(
                            isLoading: context.watch<SignalementBloc>().state
                                    is DownVoteSignalementLoading ||
                                context.watch<SignalementBloc>().state
                                    is UpVoteSignalementLoading,
                            icon: Icons.thumb_up_alt_outlined,
                            label: "Toujours",
                            onPressed: () {
                              BlocProvider.of<SignalementBloc>(context).add(
                                UpVoteSignalementEvent(
                                    id: signalement.id, userId: user.uid),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  String calculateCreatedTimeString(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return "${difference.inDays} jours";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} heures";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes";
    } else {
      return "${difference.inSeconds} secondes";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignalementBloc, SignalementState>(
      listener: (context, state) {
        if ((state is GetSignalementsSuccess ||
                state is CreateSignalementSuccess ||
                state is DeleteSignalementSuccess) &
            tutorialDone) {
          setState(() {
            signalements =
                BlocProvider.of<SignalementBloc>(context).signalements;
          });
          _buildMarkers(zoom);
        }
        if (state is GetSignalementsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 160,
                right: 20,
                left: 20,
              ),
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
                    minZoom: 10,
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
                      markers: [userMarker] + markersList,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 272,
            right: 12,
            child: isPositionInitialized
                ? CustomIconButton(
                    key: reportButton,
                    onPressed: () => _showBottomSheet(context),
                    type: IconButtonType.image,
                    image: 'assets/images/report_logo.png',
                  )
                : const CircularProgressIndicator(),
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
