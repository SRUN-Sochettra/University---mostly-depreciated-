// import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'counter_logic.dart';
import 'detail_screen.dart';
import 'theme_logic.dart';
import 'gridstyle_logic.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'Product_service.dart';
import 'product_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {

  bool _showUpIcon = false;
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
      // drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  // Widget _buildDrawer() {
  //   return Drawer(backgroundColor: Theme.of(context).colorScheme.primary);
  // }

  Widget _buildSkeletonizer() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double screenWidth = MediaQuery.of(context).size.width;

    return Skeletonizer(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1000 ? (screenWidth - 1000) / 2 : 8,
          vertical: 8,
        ),
        // controller: _scroller,
        // physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridStyle ? (isLandscape ? 4 : 2) : 1,
          childAspectRatio: _gridStyle ? 3 / 5 : 3 / 3,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "asd asd asd sd asd sad asd",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  child: Text("asdasd sa d", textAlign: TextAlign.right),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _gridStyle = true;
  final _searchCtrl = TextEditingController();
  AppBar _buildAppBar() {
    bool dark = context.watch<ThemLogic>().dark;
    _gridStyle = context.watch<GridStyleLogic>().gridStyle;
    return AppBar(
      title: TextField(
        controller: _searchCtrl,
        style:TextStyle(
          color: Colors.white,
        ),
       
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search products...",
          hintStyle:TextStyle(
            color: Colors.white60,
          ),
          ),
          onSubmitted: (text){
            setState(() {
              _futureData = ProductService().search(_searchCtrl.text.trim());
            });
          },
      ),
    );
  }

  late Future<List<ProductModel>> _futureData = ProductService().search(_searchCtrl.text.trim());

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = ProductService().search(_searchCtrl.text.trim()); 
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
                        _futureData = ProductService().search(_searchCtrl.text.trim());
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
              return _buildSkeletonizer();
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
    final ScrollController _scroller = ScrollController();

  Widget _buildGridView(List<ProductModel>? items) {
    if (items == null) {
      return Center(child: Icon(Icons.list));
    }
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1000 ? (screenWidth - 1000) / 2 : 8,
        vertical: 8,
      ),
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridStyle ? (isLandscape ? 4 : 2) : 1,
        childAspectRatio: _gridStyle ? 3 / 5 : 3 / 3,
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
