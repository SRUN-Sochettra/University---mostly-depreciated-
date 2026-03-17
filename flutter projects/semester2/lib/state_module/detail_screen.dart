import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_logic.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int counter = context.watch<CounterLogic>().counter;

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
          padding: const EdgeInsets.all(16),
          child: Text(
            "Flutter is an open-source UI software development kit created by Google. It can be used to develop cross platform applications from a single codebase.",
            style: TextStyle(fontSize: 18 + counter.toDouble()),
          ),
        ),
      ),
    );
  }
}