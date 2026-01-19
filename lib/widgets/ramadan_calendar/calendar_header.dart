import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class CalendarHeader extends StatefulWidget {
  final Position? location;

  const CalendarHeader({super.key, this.location});

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  String _locationName = 'Locating...';

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _getAddressFromLatLng(widget.location!);
    }
  }

  @override
  void didUpdateWidget(covariant CalendarHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location && widget.location != null) {
      _getAddressFromLatLng(widget.location!);
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _locationName =
              '${place.administrativeArea ?? place.locality}'; // e.g. Istanbul
        });
      }
    } catch (e) {
      setState(() {
        _locationName = 'Unknown Location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: CustomTheme.primaryColor,
                size: size.width * 0.05,
              ),
              const SizedBox(width: 8),
              Text(
                _locationName,
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ramadan 1447 AH / 2026',
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
