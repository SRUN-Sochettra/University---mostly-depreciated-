import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import '../widgets/giveaway_image.dart';
import '../widgets/attribution.dart';
import '../utils/open_web_link.dart';

class DetailScreen extends StatelessWidget {
  final Giveaway game;
  const DetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Giveaway details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: GiveawayImage(url: game.image),
            ),
          ),
          const SizedBox(height: 20),
          SelectableText(game.title, style: style.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(game.type)),
              Chip(label: Text(game.status)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Platforms: ${game.platforms}'),
          const SizedBox(height: 8),
          Text('Listed worth: ${game.worth}'),
          const SizedBox(height: 8),
          Text('Ends: ${game.endDate}'),
          const SizedBox(height: 24),
          Text('About this giveaway', style: style.titleLarge),
          const SizedBox(height: 8),
          SelectableText(game.description),
          const SizedBox(height: 24),
          Text('How to claim', style: style.titleLarge),
          const SizedBox(height: 8),
          SelectableText(game.instructions),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: game.url.isEmpty
                ? null
                : () => openWebLink(context, game.url),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open giveaway'),
          ),
          if (game.url.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('This giveaway has no claim link.'),
            ),
          const Attribution(),
        ],
      ),
    );
  }
}
