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
  Future<List<Map<String, dynamic>>>? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _readApiData();
  }

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
      title: const Text("Home Screen"),
      actions: [
        IconButton(
          onPressed: () => context.read<ThemeLogic>().toggleDark(),
          icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
        ),
        IconButton(
          onPressed: () => context.read<CounterLogic>().decrease(),
          icon: const Icon(Icons.remove),
        ),
        IconButton(
          onPressed: () => context.read<CounterLogic>().increase(),
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => DetailScreen())),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _readApiData() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.escuelajs.co/api/v1/products"),
      );
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((x) => x as Map<String, dynamic>).toList();
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _cleanImageUrl(dynamic images) {
    if (images == null || (images is List && images.isEmpty)) {
      return '';
    }

    String raw = '';
    if (images is List) {
      raw = images[0].toString();
    } else {
      raw = images.toString();
    }

    raw = raw.trim();
    if (raw.startsWith('[')) raw = raw.substring(1);
    if (raw.endsWith(']')) raw = raw.substring(0, raw.length - 1);
    raw = raw.replaceAll('"', '').trim();

    return raw;
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = _readApiData();
        });
      },
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureData = _readApiData();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("RETRY"),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _buildGridView(snapshot.data);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>>? items) {
    if (items == null || items.isEmpty) {
      return const Center(child: Icon(Icons.list, size: 48));
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final imageUrl = _cleanImageUrl(item["images"]);

        final price = item['price'] ?? 0;
        final title = item['title'] ?? 'No Title';

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: imageUrl.isEmpty
                      ? Container(
                          width: double.maxFinite,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (_, __) => Container(color: Colors.grey),
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey.shade800),
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "USD $price",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
