import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';
import 'theme_logic.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    int size = context.watch<CounterLogic>().counter; 
    bool dark = context.watch<ThemeLogic>().dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
         
          IconButton(
            onPressed: () {
              context.read<ThemeLogic>().toggleDark();
            },
            icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
          ),
          
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
        
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DetailScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Flutter is an open-source UI software development kit created by Google. "
          "It can be used to develop cross platform applications from a single "
          "codebase for the web, Fuchsia, Android, iOS, Linux, macOS, and Windows. "
          "First described in 2015, Flutter was released in May 2017.",
          style: TextStyle(
            // fontSize: 18 + size.toDouble(), 
          ),
        ),
      ),
    );
  }
}