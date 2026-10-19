import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openWebLink(BuildContext context, String value) async {
  try {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw const FormatException('Invalid web link.');
    }
    if (!await launchUrl(uri)) throw Exception('No browser available.');
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this link. Please try again.'),
        ),
      );
    }
  }
}
