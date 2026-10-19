import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/giveaway.dart';
import '../services/giveaway_api.dart';

final clientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final giveawaysProvider = FutureProvider<List<Giveaway>>((ref) {
  return fetchGiveaways(ref.watch(clientProvider));
});
