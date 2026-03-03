import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'counter_logic.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DetailScreen()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
          Text("Counter: ${context.watch<CounterLogic>().counter}"),
        ],
      ),
    );
  }
}
