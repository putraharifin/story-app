import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/core/router/app_router.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/l10n/l10n_extension.dart';
import 'package:story_app/presentation/providers/auth_provider.dart';
import 'package:story_app/presentation/providers/story_list_provider.dart';
import 'package:story_app/presentation/widgets/language_menu_button.dart';
import 'package:story_app/presentation/widgets/message_view.dart';
import 'package:story_app/presentation/widgets/story_card.dart';

class StoryListPage extends StatefulWidget {
  const StoryListPage({super.key});

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openAddStory() async {
    final provider = context.read<StoryListProvider>();
    final added = await context.push<bool>(AppRoutes.addStory);
    if (added != true) return;

    await provider.fetchStories(silent: true);
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = context.watch<StoryListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.storiesTitle),
        actions: [
          const LanguageMenuButton(),
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addStoryTitle,
        onPressed: _openAddStory,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(provider, l10n),
    );
  }

  Widget _buildBody(StoryListProvider provider, AppLocalizations l10n) {
    switch (provider.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return MessageView(
          icon: Icons.error_outline,
          message: provider.message ?? l10n.errorGeneric,
          actionLabel: l10n.retry,
          onAction: provider.fetchStories,
        );
      case ViewState.empty:
        return MessageView(
          icon: Icons.photo_library_outlined,
          message: l10n.emptyStories,
          actionLabel: l10n.refresh,
          onAction: provider.fetchStories,
        );
      case ViewState.success:
        return RefreshIndicator(
          onRefresh: () => provider.fetchStories(silent: true),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
            itemCount: provider.stories.length,
            itemBuilder: (context, index) {
              final story = provider.stories[index];
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: StoryCard(
                    story: story,
                    onTap: () => context.push(AppRoutes.storyDetail(story.id)),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}
