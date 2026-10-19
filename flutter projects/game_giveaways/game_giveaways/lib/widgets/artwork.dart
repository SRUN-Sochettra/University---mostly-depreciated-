import 'package:flutter/material.dart';

class Artwork extends StatelessWidget {
  const Artwork({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    Widget fallback() => ColoredBox(
      color: colours.surfaceContainerHighest,
      child: Center(
        child: Text(
          'Artwork unavailable',
          style: TextStyle(color: colours.onSurfaceVariant, fontSize: 12),
        ),
      ),
    );
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return fallback();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) => frame != null || sync
          ? child
          : ColoredBox(color: colours.surfaceContainerHighest),
      errorBuilder: (_, _, _) => fallback(),
    );
  }
}
