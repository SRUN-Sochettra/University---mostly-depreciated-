import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import '../screens/detail_screen.dart';
import 'artwork.dart';

class GiveawayCard extends StatelessWidget {
  const GiveawayCard({super.key, required this.game});
  final Giveaway game;
  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    return Material(
      color: colours.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colours.outlineVariant),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => DetailScreen(game: game)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Artwork(url: game.thumbnail),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasValue(game.type)) ...[
                      Text(
                        game.type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colours.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                    Text(
                      game.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(height: 1.25),
                    ),
                    const SizedBox(height: 6),
                    if (hasValue(game.platforms))
                      Text(
                        game.platforms,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colours.onSurfaceVariant,
                        ),
                      ),
                    const Spacer(),
                    Text(
                      'Free',
                      style: TextStyle(
                        color: colours.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
