import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_logic.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int counter = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(title: Text("Detail Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FilledButton(
              onPressed: () {
                context.read<CounterLogic>().decrease();
              },
              child: Text("Decrease"),
            ),
            FilledButton(
              onPressed: () {
                context.read<CounterLogic>().increase();
              },
              child: Text("Increase"),
            ),
            Text("Counter: $counter"),
          ],
        ),
      ),
    );
  }
}
