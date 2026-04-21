import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'counter_logic.dart';
import 'detail_screen.dart';
import 'theme_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sum(int a, int b) {
    return a + b;
  }

  Future<int> add(int a, int b) {
    return Future.value(a + b);
  }

  @override
  Widget build(BuildContext context) {
    add(20, 30).then((value) {
      debugPrint("value = $value");
    });

    int s = sum(10, 20);
    debugPrint("s = $s");

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

  Future<String> _readFakeData() {
    return Future.delayed(Duration(seconds: 2), () {
      return "Some Fake Data";
    });
  }

  // Future<String> _readRealData() async {
  //   try {
  //     http.Response response = await http.get(
  //       Uri.parse("https://api.escuelajs.co/api/v1/products"),
  //     );
  //     if(response.statusCode == 200){
  //       return response.body;
  //     }else{
  //       throw Exception("Error status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  Future<List<Map<String, dynamic>>> _readApiData() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://api.escuelajs.co/api/v1/products"),
      );
      if (response.statusCode == 200) {
        String res = response.body;

        List list = jsonDecode(res);
        List<Map<String, dynamic>> jsonList = list
            .map((x) => x as Map<String, dynamic>)
            .toList();
        return jsonList;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  late Future<List<Map<String, dynamic>>> _futureData = _readApiData();

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _readApiData();
          });
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _futureData = _readApiData();
                      });
                    },
                    child: Text("RETRY"),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildGridView(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>>? items) {
    if (items == null) {
      return Center(child: Icon(Icons.list));
    }

    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item["images"][0],
                    placeholder: (_, _) => Container(color: Colors.grey,),
                    errorWidget: (_, _, _) => Container(color: Colors.grey.shade800,),
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${item['title']}"),
              ),
            ],
          ),
        );
      },
    );
  }
}
