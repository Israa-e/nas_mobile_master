import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  GoogleMapController? _controller;
  LatLng _selectedLocation = LatLng(31.951569, 35.923963); // Default location

  final String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    }
  ]
  ''';

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller!.setMapStyle(_mapStyle); // Apply custom style
  }

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng(_selectedLocation); // Get the initial address
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address =
              "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        address = "تعذر تحديد العنوان";
      });
    }
  }

  String address = "جاري تحديد العنوان..."; // Placeholder for the address

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الموقع'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Return the selected location to the previous screen
              Navigator.pop(context, _selectedLocation);
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,

        initialCameraPosition: CameraPosition(
          target: _selectedLocation, // ← إحداثيات المكان
          zoom: 14.0,
        ),
        mapType: MapType.normal,
        markers: {
          Marker(
            markerId: MarkerId("location"),
            position: _selectedLocation,
            infoWindow: InfoWindow(title: "موقعي"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() {
                _selectedLocation = newPosition; // Update the selected location
              });
              _getAddressFromLatLng(newPosition); // Get the new address
            }, // Change to the desired color
          ),
        },
        onTap: (LatLng position) {
          setState(() {
            _selectedLocation = position; // Update the marker position on tap
          });
          _getAddressFromLatLng(position); // Get the new address
        },
      ),
    );
  }
}
