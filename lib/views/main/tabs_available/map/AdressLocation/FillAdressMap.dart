import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/IconButton/icon_button.dart';

import '../../../../../DS/spacing.dart';

class FillAdressMap extends StatefulWidget {
  final LatLng latLng;

  const FillAdressMap({super.key, required this.latLng});

  @override
  FillAdressMapState createState() => FillAdressMapState();
}

class FillAdressMapState extends State<FillAdressMap>
    with SingleTickerProviderStateMixin {
  final TextEditingController _adressController = TextEditingController();
  late String address = '';
  late String country = '';
  late LatLngBounds bounds;
  late LatLng userPosition;
  LatLng? selectedPosition;
  String pin = 'assets/images/pinDown.svg';
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    userPosition = widget.latLng;
    bounds = calculateBounds(widget.latLng, 3);
  }

  LatLngBounds calculateBounds(LatLng center, double radiusInKm) {
    final double latitudeDelta = (radiusInKm / (111.1 * cos(center.latitude)));
    final double longitudeDelta = (radiusInKm / (111.1 * cos(center.latitude)));

    final LatLng southWest = LatLng(
        center.latitude - latitudeDelta, center.longitude - longitudeDelta);
    final LatLng northEast = LatLng(
        center.latitude + latitudeDelta, center.longitude + longitudeDelta);

    return LatLngBounds(southWest, northEast);
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
          country = placemark.isoCountryCode!;
          _adressController.text =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      } else {
        setState(() {
          _adressController.text = 'No address found';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<String> getAdressList(addresses) {
    List<String> adressList = [];
    for (var item in addresses) {
      adressList.add(item.description);
    }
    return adressList;
  }

  bool isWithinCircle(LatLng center, LatLng point, double radius) {
    const distance = Distance();
    return distance(center, point) <= radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCameraFit: CameraFit.insideBounds(bounds: bounds),
                  initialCenter: widget.latLng,
                  initialZoom: 18,
                  onMapReady: () {
                    getAddressFromLatLng(widget.latLng);
                    mapController.move(userPosition, 18);
                  },
                  minZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  onMapEvent: (event) {
                    if (event.source.name == "dragEnd") {
                      setState(() {
                        pin = 'assets/images/pinDown.svg';
                        getAddressFromLatLng(event.camera.center);
                      });
                    }
                  },
                  onPositionChanged: (position, hasGesture) {
                    if (position.center != null) {
                      if (isWithinCircle(
                          widget.latLng, position.center!, 1000)) {
                        setState(() {
                          pin = 'assets/images/pinUp.svg';
                          userPosition = position.center!;
                        });
                      } else {
                        final bearing = const Distance()
                            .bearing(widget.latLng, position.center!);
                        final closestPoint = const Distance()
                            .offset(widget.latLng, 1000, bearing);
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
                        'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=${dotenv.env['MAPTILER_API_KEY']!}',
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
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(widget.latLng.latitude - 0.0005,
                            widget.latLng.longitude),
                        radius: 1000,
                        useRadiusInMeter: true,
                        color: MyColors.secondary40.withOpacity(0.2),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                color: MyColors.defaultWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GooglePlaceAutoCompleteTextField(
                          // widget used to autocomplete the address
                          textEditingController: _adressController,
                          googleAPIKey: dotenv.env['GOOGLE_API_KEY']!,
                          countries: [country],
                          // we give the country code to the widget to only return addresses from this country
                          itemClick: (Prediction prediction) async {
                            LatLng? coords;
                            if (prediction.lat != null &&
                                prediction.lng != null) {
                              //we check if the address has coordinates
                              coords = LatLng(prediction.lat! as double,
                                  prediction.lng! as double);
                            } else {
                              await GeocodingPlatform.instance
                                  .locationFromAddress(prediction.description!)
                                  .then((value) {
                                //if not we get the coordinates from the address using geocoding
                                coords = LatLng(value.first.latitude,
                                    value.first.longitude);
                              });
                            }
                            Distance distance = const Distance();
                            if (distance.as(LengthUnit.Meter, widget.latLng,
                                    coords!) >
                                1000) {
                              //we check if the coordinates are in a 3 kilometers radius from the user's position
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Vous devez choisir une adresse proche de votre position'), //if not we show a snackbar
                                ),
                              );
                            } else {
                              setState(() {
                                _adressController.text =
                                    prediction.description!;
                                selectedPosition = coords!;
                              });
                            }
                          },
                          inputDecoration: InputDecoration(
                            hintText: 'Rechercher une adresse',
                            hintStyle: TitleMediumMedium,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Distance distance = const Distance();
                          if (distance.as(LengthUnit.Meter, widget.latLng,
                                  selectedPosition!) >
                              1000) {
                            //we check if the coordinates are in a 3 kilometers radius from the user's position
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Vous devez choisir une adresse proche de votre position'), //if not we show a snackbar
                              ),
                            );
                          } else {
                            setState(() {
                              mapController.move(
                                  userPosition, mapController.camera.zoom);
                            });
                          }
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.standard),
                  CustomButton(
                      label: "Confirmer la position",
                      type: ButtonType.filled,
                      fillColor: MyColors.secondary40,
                      onPressed: () {
                        if (isWithinCircle(widget.latLng, userPosition, 1000)) {
                          Navigator.pop(context, userPosition);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Le pin est hors de la limite définie sur la carte'),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconButton(
                type: IconButtonType.square,
                icon: Icons.arrow_back_ios_new,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
