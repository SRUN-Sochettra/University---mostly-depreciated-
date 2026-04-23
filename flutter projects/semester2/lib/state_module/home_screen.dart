// import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

import 'counter_logic.dart';
import 'detail_screen.dart';
import 'theme_logic.dart';
import 'product_service.dart';
import 'product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showUpIcon = false;
  bool _gridStyle = false;
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels < 500) {
        setState(() {
          _showUpIcon = false;
        });
      } else {
        setState(() {
          _showUpIcon = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
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
            setState(() {
              _gridStyle = !_gridStyle;
            });

          },
          icon: Icon(_gridStyle ? Icons.list : Icons.grid_on),
        ),
        // IconButton(
        //   onPressed: () {
        //     Navigator.of(
        //       context,
        //     ).push(MaterialPageRoute(builder: (context) => DetailScreen()));
        //   },
        //   icon: Icon(Icons.settings),
        // ),
      ],
    );
  }

  late Future<List<ProductModel>> _futureData = ProductService().readApiData();

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = ProductService().readApiData();
          });
        },
        child: FutureBuilder<List<ProductModel>>(
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
                        _futureData = ProductService().readApiData();
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

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  Widget _buildGridView(List<ProductModel>? items) {
    if (items == null) {
      return Center(child: Icon(Icons.list));
    }

    return GridView.builder(
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridStyle ? 2:1,
        childAspectRatio: _gridStyle ? 3/5 : 4/3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => DetailScreen(item)));
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.images[0],
                      placeholder: (_, _) => Container(color: Colors.grey),
                      errorWidget: (_, _, _) =>
                          Container(color: Colors.grey.shade800),
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  child: Text("USD ${item.price}", textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}