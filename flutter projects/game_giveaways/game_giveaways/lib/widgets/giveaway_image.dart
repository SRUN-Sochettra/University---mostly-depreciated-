import 'package:flutter/material.dart';

class GiveawayImage extends StatelessWidget {
  final String url;
  const GiveawayImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    Widget fallback() => ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.sports_esports, size: 40)),
    );
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return fallback();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback(),
      errorBuilder: (context, error, stack) => fallback(),
    );
  }
}
