import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/l10n/l10n_extension.dart';

/// Map with a single marker. Tapping the marker shows the geocoded address
/// in its info window; the same address is also shown below the map.
class StoryLocationMap extends StatelessWidget {
  const StoryLocationMap({
    super.key,
    required this.markerId,
    required this.title,
    required this.location,
    required this.address,
    required this.isAddressLoading,
  });

  final String markerId;
  final String title;
  final GeoPoint location;
  final String? address;
  final bool isAddressLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final position = LatLng(location.latitude, location.longitude);
    final addressText = isAddressLoading
        ? l10n.addressLoading
        : address ?? l10n.addressUnavailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.storyLocation, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 240,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId(markerId),
                  position: position,
                  infoWindow: InfoWindow(title: title, snippet: addressText),
                ),
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  EagerGestureRecognizer.new,
                ),
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          child: Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: isAddressLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.place_outlined),
              title: Text(addressText),
              subtitle: Text(location.coordinates),
            ),
          ),
        ),
      ],
    );
  }
}
