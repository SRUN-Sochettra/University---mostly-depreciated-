import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/giveaway.dart';

enum GiveawayCategory { all, games, loot, beta }

extension CategoryName on GiveawayCategory {
  String get label => switch (this) {
    GiveawayCategory.all => 'All',
    GiveawayCategory.games => 'Games',
    GiveawayCategory.loot => 'Loot',
    GiveawayCategory.beta => 'Beta access',
  };
}

class Browse {
  const Browse({this.query = '', this.category = GiveawayCategory.all});
  final String query;
  final GiveawayCategory category;
}

class BrowseController extends Notifier<Browse> {
  @override
  Browse build() => const Browse();
  void search(String query) =>
      state = Browse(query: query, category: state.category);
  void filter(GiveawayCategory category) =>
      state = Browse(query: state.query, category: category);
  void reset() => state = const Browse();
}

final browseProvider = NotifierProvider<BrowseController, Browse>(
  BrowseController.new,
);

List<Giveaway> filtered(List<Giveaway> items, Browse browse) {
  final query = browse.query.trim().toLowerCase();
  return items
      .where((item) {
        final type = item.type.toLowerCase();
        final matches = switch (browse.category) {
          GiveawayCategory.all => true,
          GiveawayCategory.games => type == 'game',
          GiveawayCategory.loot => type.contains('loot'),
          GiveawayCategory.beta => type.contains('beta'),
        };
        return matches &&
            (query.isEmpty ||
                '${item.title} ${item.platforms} ${item.type}'
                    .toLowerCase()
                    .contains(query));
      })
      .toList(growable: false);
}

class NavigationController extends Notifier<int> {
  @override
  int build() => 0;
  void select(int index) {
    if (index == 0 || index == 1) {
      state = index;
    }
  }
}

final navigationProvider = NotifierProvider<NavigationController, int>(
  NavigationController.new,
);
