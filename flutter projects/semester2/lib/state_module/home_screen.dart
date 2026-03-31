import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';
import 'detail_screen.dart';
import 'theme_logic.dart';
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(backgroundColor: Theme.of(context).colorScheme.primary);
  }

  AppBar _buildAppBar() {
    bool dark = context.watch<ThemeLogic>().dark;
    return AppBar(
      title: Text("Home Screen"),
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
          icon: Icon(Icons.remove),
        ),
        IconButton(
          onPressed: () {
            context.read<CounterLogic>().increase();
          },
          icon: Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => DetailScreen()));
          },
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  Future<String> helloworld() {
    return Future.delayed(Duration(seconds: 4), () {
      return "Hello World";
    });
  }

  Future<String> _readRealData() async {
    http.Response response = await http.get(Uri.parse("https://google.com"));
    return response.body;
  }

  late Future<String> _futureData = _readRealData();

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _readRealData();
          });
        },
        child: FutureBuilder(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(snapshot.data!),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
