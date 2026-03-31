import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';

class DetailScreen extends StatefulWidget {
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    int cnt = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Screen"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().decrease();
            },
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().increase();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Text(
          "The Material 3 Design Kit provides a comprehensive introduction to the design system, with styles and components to help you get started.",
          // style: TextStyle(fontSize: 18 + cnt.toDouble()),
        ),
      ),
    );
  }
}
