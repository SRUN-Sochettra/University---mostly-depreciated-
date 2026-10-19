import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import '../widgets/artwork.dart';
import '../widgets/open_link.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.game});
  final Giveaway game;
  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    final canOpen = validLink(game.url);
    return Scaffold(
      appBar: AppBar(title: const Text('Giveaway details')),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: canOpen ? () => openLink(context, game.url) : null,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Get giveaway'),
                ),
              ),
              if (!canOpen)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'A claim link is not available for this giveaway.',
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Artwork(url: game.image),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                game.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Free to claim',
                style: TextStyle(
                  color: colours.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              if (hasValue(game.worth))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Original value: ${game.worth}',
                    style: TextStyle(color: colours.onSurfaceVariant),
                  ),
                ),
              if (hasValue(game.type) || hasValue(game.platforms)) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (hasValue(game.type)) _Tag(game.type),
                    if (hasValue(game.platforms)) _Tag(game.platforms),
                  ],
                ),
              ],
              if (hasValue(game.endDate)) ...[
                const SizedBox(height: 20),
                Text(
                  'Ends: ${game.endDate}',
                  style: TextStyle(color: colours.onSurfaceVariant),
                ),
              ],
              if (hasValue(game.description))
                _Section('About this giveaway', game.description),
              if (hasValue(game.instructions))
                _Section('How to claim', game.instructions),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      openLink(context, 'https://www.gamerpower.com'),
                  child: const Text('Source: GamerPower'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colours.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colours.onSecondaryContainer,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.content);
  final String title, content;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        SelectableText(content, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
