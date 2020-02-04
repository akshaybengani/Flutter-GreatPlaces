import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/database/location_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function _selectPlace;
  LocationInput(this._selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      print(locData.latitude);
      print(locData.longitude);
      _showPreview(locData.latitude, locData.longitude);
      widget._selectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      print(error.toString());
      return;
    }
  }

  Future<void> _selectOnMap() async {
    try {
      final locData = await Location().getLocation();
      final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MapScreen(
            inititalLocation: PlaceLocation(
                latitude: locData.latitude, longitude: locData.longitude),
            isSelecting: true,
          ),
        ),
      );
      if (selectedLocation == null) {
        return;
      }
      print(selectedLocation.latitude);
      print(selectedLocation.longitude);
      //final address = LocationHelper.getPlaceAddress(selectedLocation.latitude, selectedLocation.longitude);
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget._selectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    } catch (error) {
      print(error.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          height: 170,
          child: _previewImageUrl == null
              ? Text('No Location Chosen', textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          width: double.infinity,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
                onPressed: _getCurrentUserLocation,
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.location_on),
                label: Text('Current Location')),
            FlatButton.icon(
                onPressed: _selectOnMap,
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.map),
                label: Text('Select on Map'))
          ],
        )
      ],
    );
  }
}
