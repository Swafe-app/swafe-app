import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';

class FillAdressMap extends StatefulWidget {
  final LatLng? latLng;

  const FillAdressMap({super.key, required this.latLng});

  @override
  FillAdressMapState createState() => FillAdressMapState();
}

class FillAdressMapState extends State<FillAdressMap> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adressController = TextEditingController();
  late String address = '';

  @override
  void initState() async {
    super.initState();
    getAddressFromLatLng(widget.latLng!);
    _adressController.text = widget.latLng.toString();
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: widget.latLng!),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=By3OUeKIWraENXWoFzSV',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: widget.latLng!,
                  child: SvgPicture.asset(
                    'assets/images/pinDown.svg',
                    width: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
