import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/domain/repositories/location_repository.dart'; 


/// Location row of the add-story form.
/// When [isLocked] is true (free flavor) the feature is shown but disabled.
class LocationSelector extends StatelessWidget {
  const LocationSelector({
    super.key,
    required this.location,
    required this.isLocked,
    this.onPick,
    this.onClear,
  });

  final GeoPoint? location;
  final bool isLocked;
  final VoidCallback? onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = context.l10n;

    if (isLocked) {
      return Card(
        key: const ValueKey('locked'),
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: false,
          leading: const Icon(Icons.lock_outline),
          title: Text(l10n.locationLockedTitle),
          subtitle: Text(l10n.locationLockedSubtitle),
        ),
      );
    }

    final point = location;
    if (point == null) {
      return OutlinedButton.icon(
        key: const ValueKey('empty'),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        onPressed: onPick,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(l10n.addLocation),
      );
    }

    return Card(
      key: const ValueKey('selected'),
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onPick,
        leading: const Icon(Icons.place),
        title: FutureBuilder<String?>(
          future: context.read<LocationRepository>().getAddress(
            GeoPoint(latitude: point.latitude, longitude: point.longitude),
          ),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Memuat alamat...");
            }
            if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!);
            }
            return Text("${point.latitude}, ${point.longitude}");
          },
        ),

        subtitle: Text(l10n.changeLocation),
        trailing: IconButton(
          tooltip: l10n.removeLocation,
          icon: const Icon(Icons.close),
          onPressed: onClear,
        ),
      ),
    );
  }
}
