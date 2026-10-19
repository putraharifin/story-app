import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/presentation/providers/locale_provider.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.translate),
      tooltip: context.l10n.language,
      initialValue: provider.locale,
      onSelected: provider.setLocale,
      itemBuilder: (context) => const [
        PopupMenuItem<Locale>(value: Locale('en'), child: Text('English')),
        PopupMenuItem<Locale>(
          value: Locale('id'),
          child: Text('Bahasa Indonesia'),
        ),
      ],
    );
  }
}
