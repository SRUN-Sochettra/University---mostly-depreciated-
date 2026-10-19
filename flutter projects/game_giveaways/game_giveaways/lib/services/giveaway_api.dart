import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/giveaway.dart';

Future<List<Giveaway>> fetchGiveaways(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://www.gamerpower.com/api/giveaways'))
      .timeout(const Duration(seconds: 20));
  if (response.statusCode == 201) return const [];
  if (response.statusCode != 200) {
    throw Exception('Giveaway service returned HTTP ${response.statusCode}.');
  }
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  if (data is! List) {
    throw const FormatException('Expected a list of giveaways.');
  }
  return data
      .map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid giveaway entry.');
        }
        return Giveaway.fromJson(item);
      })
      .toList(growable: false);
}
