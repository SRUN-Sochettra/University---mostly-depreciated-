import 'package:flutter/material.dart';

import '../utils/open_web_link.dart';

class Attribution extends StatelessWidget {
  const Attribution({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: TextButton(
        onPressed: () => openWebLink(context, 'https://www.gamerpower.com'),
        child: const Text('Giveaway data by GamerPower.com'),
      ),
    ),
  );
}
