import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/presentation/providers/story_detail_provider.dart';
import 'package:story_app/presentation/widgets/message_view.dart';

class StoryDetailPage extends StatelessWidget {
  const StoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = context.watch<StoryDetailProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyDetailTitle)),
      body: _buildBody(context, provider, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    StoryDetailProvider provider,
    AppLocalizations l10n,
  ) {
    final story = provider.story;

    switch (provider.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
      case ViewState.empty:
        return MessageView(
          icon: Icons.error_outline,
          message: provider.message ?? l10n.errorGeneric,
          actionLabel: l10n.retry,
          onAction: provider.retry,
        );
      case ViewState.success:
        if (story == null) return const SizedBox.shrink();
        return _StoryDetailContent(story: story);
    }
  }
}

class _StoryDetailContent extends StatelessWidget {
  const _StoryDetailContent({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMMd(locale).add_Hm().format(
          story.createdAt.toLocal(),
        );

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: CachedNetworkImage(
                  imageUrl: story.photoUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(story.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 16),
                    Text(story.description, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
