import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cnt = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().decrease();
            },
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().increase();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "The Material 3 Design Kit provides a comprehensive introduction to the design system, with styles and components to help you get started.",
            style: TextStyle(fontSize: 18 + cnt.toDouble()),
          ),
        ),
      ),
    );
  }
}
