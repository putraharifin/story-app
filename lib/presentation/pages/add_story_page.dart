import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/core/config/app_flavor.dart';
import 'package:story_app/core/router/app_router.dart';
import 'package:story_app/core/utils/validators.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/presentation/providers/add_story_provider.dart';
import 'package:story_app/presentation/widgets/loading_button.dart';
import 'package:story_app/presentation/widgets/location_selector.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final provider = context.read<AddStoryProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final result = await provider.pickImage(source);

    switch (result) {
      case PickResult.tooLarge:
        messenger.showSnackBar(SnackBar(content: Text(l10n.imageTooLarge)));
      case PickResult.failed:
        messenger.showSnackBar(SnackBar(content: Text(l10n.imagePickFailed)));
      case PickResult.picked:
      case PickResult.cancelled:
        break;
    }
  }

  Future<void> _pickLocation() async {
    final provider = context.read<AddStoryProvider>();
    final point = await context.push<GeoPoint>(
      AppRoutes.pickLocation,
      extra: provider.location,
    );
    if (point != null) provider.setLocation(point);
  }

  Future<void> _upload() async {
    final provider = context.read<AddStoryProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    if (!_formKey.currentState!.validate()) return;
    if (provider.image == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.imageRequired)));
      return;
    }
    FocusScope.of(context).unfocus();

    final success = await provider.upload(_descriptionController.text.trim());
    if (!mounted) return;

    if (success) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.uploadSuccess)));
      context.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? l10n.errorGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final provider = context.watch<AddStoryProvider>();
    final isUploading = provider.isUploading;
    final image = provider.image;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addStoryTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: image == null
                                  ? ColoredBox(
                                      key: const ValueKey('placeholder'),
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_outlined,
                                          size: 72,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      image,
                                      key: ValueKey(image.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: isUploading
                              ? null
                              : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: Text(l10n.camera),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: isUploading
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(l10n.gallery),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _descriptionController,
                      enabled: !isUploading,
                      minLines: 5,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) => Validators.description(value, l10n),
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LocationSelector(
                      location: provider.location,
                      isLocked: !AppFlavor.isPaid,
                      onPick: isUploading ? null : _pickLocation,
                      onClear: isUploading
                          ? null
                          : () => provider.setLocation(null),
                    ),
                    const SizedBox(height: 16),
                    LoadingButton(
                      label: l10n.upload,
                      isLoading: isUploading,
                      onPressed: _upload,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
