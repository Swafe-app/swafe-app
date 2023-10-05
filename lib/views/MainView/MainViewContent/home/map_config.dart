import 'package:dartleaf/dartleaf.dart' as leaflet;
import 'package:flutter_map/flutter_map.dart' as flutter;

class MapConfig {
  static final options = leaflet.MapOptions(
    center: leaflet.LatLng(51.509364, -0.128928),
    zoom: 9.2,
  );

  static final layers = <flutter.TileLayer>[
    flutter.TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: const ['a', 'b', 'c'],
    ),
    // Vous pouvez ajouter d'autres couches de carte ou marqueurs ici
  ];
}
