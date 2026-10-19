import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import 'giveaway_card.dart';

class CatalogueGrid extends StatelessWidget {
  const CatalogueGrid({super.key, this.items, this.loading = false});
  final List<Giveaway>? items;
  final bool loading;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      final minWidth = scale > 1.3 ? 280.0 : 164.0;
      final columns = ((constraints.maxWidth + 14) / (minWidth + 14))
          .floor()
          .clamp(1, 4)
          .toInt();
      final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
      return GridView.builder(
        key: const PageStorageKey('giveaway-grid'),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: loading ? 6 : items!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          mainAxisExtent: width * 9 / 16 + 182 * scale,
        ),
        itemBuilder: (context, index) =>
            loading ? const _SkeletonCard() : GiveawayCard(game: items![index]),
      );
    },
  );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();
  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    Widget bar(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colours.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
    return Semantics(
      label: 'Loading giveaway',
      child: ExcludeSemantics(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colours.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colours.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ColoredBox(color: colours.surfaceContainerHighest),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bar(48, 10),
                    const SizedBox(height: 12),
                    bar(double.infinity, 14),
                    const SizedBox(height: 8),
                    bar(90, 14),
                    const SizedBox(height: 12),
                    bar(65, 10),
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
