import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool validLink(String value) {
  final uri = Uri.tryParse(value);
  return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
}

Future<void> openLink(BuildContext context, String value) async {
  try {
    if (!validLink(value)) {
      throw const FormatException('Invalid link.');
    }
    if (!await launchUrl(
      Uri.parse(value),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('No browser available.');
    }
  } catch (_) {
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Could not open the link'),
          content: const Text(
            'No browser could open this page. Check your browser and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
