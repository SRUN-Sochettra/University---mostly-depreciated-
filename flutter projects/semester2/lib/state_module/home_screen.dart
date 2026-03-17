import 'package:flutter/material.dart';
import 'package:semester2/state_module/theme_logic.dart';
import 'detail_screen.dart';
import 'counter_logic.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    int size = context.watch<CounterLogic>().counter;
    bool dark = context.watch<ThemeLogic>().dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  context.read<ThemeLogic>().toggleDark();
                },
                icon: Icon(dark ? Icons.dark_mode : Icons.light_mode),
              ),
              IconButton(
                onPressed: (){
                  context.read<CounterLogic>().increase();
                },
                icon: Icon(Icons.remove)
              ),
              IconButton(
                onPressed: (){
                  context.read<CounterLogic>().increase();
                },
                icon: Icon(Icons.add)
              )
            ],
          ),
          IconButton(
            onPressed: (){
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const DetailScreen()));
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Text(
          "Flutter is an open-source UI software development kit created by Google. It can be used to develop cross platform applications from a single codebase.",
          style: TextStyle(fontSize: 18 + size.toDouble()),
        ),
      ),
    );
      
  }
}
