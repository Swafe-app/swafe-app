import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/reporting_type.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_bloc.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_event.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/typeReport/custom_report.dart';
import 'package:swafe/models/signalement/signalement_model.dart';
import 'package:swafe/views/main/tabs_available/map/AdressLocation/FillAdressMap.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent(
      {super.key, required this.position, this.userPosition});

  final LatLng position;
  final LatLng? userPosition;

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSelectionMade = false;
  final List<ReportingType> selectedDangerItems = [];
  final List<ReportingType> selectedAnomaliesItems = [];
  late LatLng userPosition;
  LatLng basePosition = const LatLng(0, 0);
  String pin = 'assets/images/pinDown.svg';
  String? address;
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    userPosition = widget.userPosition ?? widget.position;
    basePosition = widget.position;
    _tabController = TabController(length: 2, vsync: this);
  }

  //Vérifie si le signalement est dans le cercle
  bool isWithinCircle(LatLng center, LatLng point, double radius) {
    const distance = Distance();
    return distance(center, point) <= radius;
  }

  SignalementDangerItemsEnum reportingTypeToEnum(ReportingType type) {
    switch (type) {
      case ReportingType.autre:
        return SignalementDangerItemsEnum.autre;
      case ReportingType.vol:
        return SignalementDangerItemsEnum.vol;
      case ReportingType.harcelement:
        return SignalementDangerItemsEnum.harcelement;
      case ReportingType.agressionSexuelle:
        return SignalementDangerItemsEnum.agressionSexuelle;
      case ReportingType.violence:
        return SignalementDangerItemsEnum.agressionPhysique;
      case ReportingType.insecurite:
        return SignalementDangerItemsEnum.jeMeFaisSuivre;
      case ReportingType.violenceVerbale:
        return SignalementDangerItemsEnum.agressionVerbale;
      case ReportingType.incendie:
        return SignalementDangerItemsEnum.incendie;
      case ReportingType.meteo:
        return SignalementDangerItemsEnum.meteo;
      case ReportingType.travaux:
        return SignalementDangerItemsEnum.travaux;
      case ReportingType.inondation:
        return SignalementDangerItemsEnum.inondation;
      case ReportingType.obstacle:
        return SignalementDangerItemsEnum.obstacleSurLaChaussee;
      case ReportingType.accessibilite:
        return SignalementDangerItemsEnum.manqueAccessibilite;
      case ReportingType.voiture:
        return SignalementDangerItemsEnum.voiture;
      case ReportingType.feuPieton:
        return SignalementDangerItemsEnum.feuDePietonDysfonctionnel;
      case ReportingType.eclairage:
        return SignalementDangerItemsEnum.mauvaisEclairage;
      case ReportingType.chaussee:
        return SignalementDangerItemsEnum.trouSurLaChaussee;
      default:
        return SignalementDangerItemsEnum.autre;
    }
  }

  void sendReport() {
    if (isSelectionMade) {
      final List<SignalementDangerItemsEnum> selectedItems = [];

      for (var item in selectedDangerItems) {
        selectedItems.add(reportingTypeToEnum(item));
      }
      for (var item in selectedAnomaliesItems) {
        selectedItems.add(reportingTypeToEnum(item));
      }

      BlocProvider.of<SignalementBloc>(context).add(
        CreateSignalementEvent(
          coordinates: SignalementCoordinates(
            latitude: userPosition.latitude,
            longitude: userPosition.longitude,
          ),
          selectedDangerItems: selectedItems,
        ),
      );
    }
  }

  //Obtention de l'adresse à partir de la latitude et de la longitude
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

  //Création des signalements sélectionnables
  List<Widget> _buildSelectableItems(
      List<ReportingType> selectedItems, String tabName) {
    late List<ReportingType> items;
    if (tabName == "Danger") {
      items = [
        ReportingType.vol,
        ReportingType.harcelement,
        ReportingType.agressionSexuelle,
        ReportingType.violence,
        ReportingType.incendie,
        ReportingType.insecurite,
        ReportingType.violenceVerbale,
        ReportingType.meteo,
      ];
    } else {
      items = [
        ReportingType.eclairage,
        ReportingType.chaussee,
        ReportingType.inondation,
        ReportingType.travaux,
        ReportingType.obstacle,
        ReportingType.accessibilite,
        ReportingType.voiture,
        ReportingType.feuPieton,
      ];
    }

    return items.map((item) {
      final isSelected = selectedItems.contains(item);
      return CustomReport(
          reportingType: item,
          onPressed: () => setState(() {
                if (!isSelected) {
                  selectedItems.add(item);
                } else {
                  selectedItems.remove(item);
                }
                isSelectionMade = selectedDangerItems.isNotEmpty ||
                    selectedAnomaliesItems.isNotEmpty;
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
    return BlocListener<SignalementBloc, SignalementState>(
      listener: (context, state) {
        if (state is CreateSignalementSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                label: 'Votre signalement a bien été envoyé',
              ),
            ),
          );
          Navigator.of(context).pop();
        }
        if (state is CreateSignalementError) {
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
      child: Container(
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
              style: TitleLargeMedium,
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              'Votre signalement sera partagé avec toute la communauté. Tout les signalements sont anonymes.',
              style: BodyLargeMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 145,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: LatLng(
                          userPosition.latitude - 0.0003,
                          userPosition.longitude,
                        ),
                        minZoom: 15,
                        initialZoom: 16,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all &
                              ~InteractiveFlag.rotate &
                              ~InteractiveFlag.drag,
                        ),
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
                              mapController.move(closestPoint, position.zoom!);
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
                              'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 50.0,
                              height: 50.0,
                              point: userPosition,
                              child: SvgPicture.asset(
                                pin,
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FillAdressMap(latLng: widget.position)),
                              );
                              if (result != null) {
                                setState(() {
                                  userPosition = result;
                                  mapController.move(userPosition, 18);
                                });
                              }
                            },
                            label: 'Modifier la position',
                            type: ButtonType.filled,
                            mainAxisSize: MainAxisSize.min,
                            textColor: MyColors.secondary40,
                            fillColor: MyColors.defaultWhite,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (address != null && address!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Text(
                  address!,
                  style: BodyLargeMedium,
                ),
              ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              indicatorColor: MyColors.secondary40,
              labelColor: MyColors.primary10,
              unselectedLabelColor: MyColors.neutral40,
              labelStyle: BodyLargeRegular,
              onTap: (value) => setState(() {
                selectedAnomaliesItems.clear();
                selectedDangerItems.clear();
                isSelectionMade = false;
              }),
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
                        _buildSelectableItems(selectedDangerItems, "Danger"),
                  ),
                  GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: _buildSelectableItems(
                        selectedAnomaliesItems, "Anomalies"),
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
                  isDisabled: isSelectionMade ? false : true,
                  isLoading: context.watch<SignalementBloc>().state
                      is CreateSignalementLoading,
                  onPressed: () => sendReport(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
