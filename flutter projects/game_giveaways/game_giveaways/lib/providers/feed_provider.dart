import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/giveaway.dart';

final clientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

Future<List<Giveaway>> fetchGiveaways(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://www.gamerpower.com/api/giveaways'))
      .timeout(const Duration(seconds: 20));
  if (response.statusCode == 201) {
    return const [];
  }
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  if (data is! List) {
    throw const FormatException('Expected a giveaway list.');
  }
  return data
      .map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid record.');
        }
        return Giveaway.fromJson(item);
      })
      .toList(growable: false);
}

class Feed {
  const Feed(this.items, {this.refreshing = false, this.failedRefresh = false});
  final List<Giveaway> items;
  final bool refreshing, failedRefresh;
}

class FeedController extends AsyncNotifier<Feed> {
  @override
  Future<Feed> build() async =>
      Feed(await fetchGiveaways(ref.watch(clientProvider)));

  Future<bool> refresh() async {
    final current = state.asData?.value;
    if (current == null || current.refreshing) {
      return false;
    }
    state = AsyncData(Feed(current.items, refreshing: true));
    try {
      final items = await fetchGiveaways(ref.read(clientProvider));
      if (!ref.mounted) {
        return false;
      }
      state = AsyncData(Feed(items));
      return true;
    } catch (_) {
      if (ref.mounted) {
        state = AsyncData(Feed(current.items, failedRefresh: true));
      }
      return false;
    }
  }
}

final feedProvider = AsyncNotifierProvider<FeedController, Feed>(
  FeedController.new,
);
