import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/presentation/providers/pick_location_provider.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  static const LatLng _defaultTarget = LatLng(-6.2088, 106.8456);

  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _locateMe() async {
    final provider = context.read<PickLocationProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.locationUnavailable;

    final point = await provider.locateMe();
    if (point == null) {
      if (mounted) messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(point.latitude, point.longitude), 16),
    );
  }

  void _select(LatLng position) {
    context.read<PickLocationProvider>().select(
      GeoPoint(latitude: position.latitude, longitude: position.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = context.watch<PickLocationProvider>();
    final selected = provider.selected;
    final selectedLatLng = selected == null
        ? null
        : LatLng(selected.latitude, selected.longitude);
    final addressText = provider.isAddressLoading
        ? l10n.addressLoading
        : provider.address ?? l10n.addressUnavailable;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pickLocationTitle),
        actions: [
          IconButton(
            tooltip: l10n.myLocation,
            icon: const Icon(Icons.my_location),
            onPressed: _locateMe,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLatLng ?? _defaultTarget,
                zoom: selectedLatLng == null ? 11 : 15,
              ),
              onMapCreated: (controller) {
                _controller = controller;
                if (selected == null) _locateMe();
              },
              onTap: _select,
              markers: {
                if (selectedLatLng != null)
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: selectedLatLng,
                    draggable: true,
                    onDragEnd: _select,
                    infoWindow: InfoWindow(
                      title: l10n.selectedLocation,
                      snippet: addressText,
                    ),
                  ),
              },
              myLocationEnabled: provider.hasLocationAccess,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          SafeArea(
            top: false,
            child: Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      alignment: Alignment.topCenter,
                      child: _AddressInfo(
                        selected: selected,
                        addressText: addressText,
                        isLoading: provider.isAddressLoading,
                        l10n: l10n,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: selected == null
                          ? null
                          : () => context.pop(selected),
                      child: Text(l10n.useThisLocation),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressInfo extends StatelessWidget {
  const _AddressInfo({
    required this.selected,
    required this.addressText,
    required this.isLoading,
    required this.l10n,
  });

  final GeoPoint? selected;
  final String addressText;
  final bool isLoading;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final point = selected;

    if (point == null) {
      return Text(l10n.pickLocationHint, style: theme.textTheme.bodyMedium);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            Expanded(
              child: Text(addressText, style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          point.coordinates,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
