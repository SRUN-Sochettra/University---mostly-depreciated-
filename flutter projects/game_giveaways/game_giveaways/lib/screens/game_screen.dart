import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/feed_provider.dart';
import '../providers/browse_provider.dart';
import '../widgets/catalogue_grid.dart';
import '../widgets/result_toast.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final _search = TextEditingController();
  final _toast = ResultToast();
  @override
  void dispose() {
    _search.dispose();
    _toast.clear();
    super.dispose();
  }

  Future<void> _refresh() async {
    final current = ref.read(feedProvider).asData?.value;
    if (current == null || current.refreshing) {
      return;
    }
    final success = await ref.read(feedProvider.notifier).refresh();
    if (mounted && success && ref.read(navigationProvider) == 0) {
      _toast.show(context, 'Giveaways refreshed');
    }
  }

  void _reset() {
    _search.clear();
    ref.read(browseProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(navigationProvider, (_, next) {
      if (next != 0) _toast.clear();
    });
    final feed = ref.watch(feedProvider);
    final browse = ref.watch(browseProvider);
    final current = feed.asData?.value;
    final refreshing = current?.refreshing ?? false;
    final colours = Theme.of(context).colorScheme;
    final visible = current == null ? null : filtered(current.items, browse);
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            Text(
                              'LootDrop',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: current == null || refreshing
                                  ? null
                                  : _refresh,
                              icon: refreshing
                                  ? const SizedBox.square(
                                      dimension: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        semanticsLabel: 'Refreshing giveaways',
                                      ),
                                    )
                                  : const Icon(Icons.refresh_rounded, size: 20),
                              label: Text(
                                refreshing ? 'Refreshing' : 'Refresh',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _search,
                        onChanged: ref.read(browseProvider.notifier).search,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          labelText: 'Search giveaways',
                          hintText: 'Title or platform',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: browse.query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _search.clear();
                                    ref
                                        .read(browseProvider.notifier)
                                        .search('');
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height:
                            52 +
                            (MediaQuery.textScalerOf(context).scale(14) - 14) *
                                2,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: GiveawayCategory.values.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = GiveawayCategory.values[index];
                            return Center(
                              child: FilterChip(
                                label: Text(category.label),
                                selected: browse.category == category,
                                onSelected: (_) => ref
                                    .read(browseProvider.notifier)
                                    .filter(category),
                              ),
                            );
                          },
                        ),
                      ),
                      if (visible != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 14),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(
                              '${visible.length} ${visible.length == 1 ? 'giveaway' : 'giveaways'}'
                              '${browse.query.trim().isEmpty ? '' : ' matching your search'}',
                              style: TextStyle(
                                color: colours.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 12),
                      if (current?.failedRefresh ?? false)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Could not refresh. Showing previous results.',
                                  style: TextStyle(color: colours.error),
                                ),
                              ),
                              TextButton(
                                onPressed: _refresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: feed.when(
                loading: () => const CatalogueGrid(loading: true),
                error: (_, _) => _Message(
                  title: 'Giveaways could not be loaded',
                  message: 'Check your connection and try again.',
                  action: 'Try again',
                  onAction: () => ref.invalidate(feedProvider),
                ),
                data: (data) => RefreshIndicator(
                  onRefresh: _refresh,
                  child: visible!.isEmpty
                      ? _Message(
                          title: data.items.isEmpty
                              ? 'No giveaways right now'
                              : 'No matches found',
                          message: data.items.isEmpty
                              ? 'Pull down to check again.'
                              : 'Try another search or clear your filters.',
                          action: data.items.isEmpty
                              ? null
                              : 'Clear search and filters',
                          onAction: _reset,
                        )
                      : CatalogueGrid(items: visible),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.message,
    this.action,
    this.onAction,
  });
  final String title, message;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(vertical: 48),
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      Text(message, textAlign: TextAlign.center),
      if (action != null)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: OutlinedButton(onPressed: onAction, child: Text(action!)),
          ),
        ),
    ],
  );
}
