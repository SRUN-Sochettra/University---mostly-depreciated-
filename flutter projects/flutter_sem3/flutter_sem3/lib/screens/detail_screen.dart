import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sem3/models/meal_detail_model.dart';
import 'package:flutter_sem3/providers/meal_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final detailAsync = ref.watch(mealDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text("Detail Screen")),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mealDetailProvider);
        },
        child: Center(
          child: detailAsync.when(
            data: (item) {
              return _buildListView(item);
            },
            error: (e, s) {
              debugPrint("Error: ${e.toString()}");
              debugPrint("TrackTrace: ${s.toString()}");
              return Text("Error: ${e.toString()}");
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView(MealElement item) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: .circular(8),
              child: CachedNetworkImage(
                imageUrl: item.strMealThumb,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.title),
            title: Text(item.strMeal),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(item.strInstructions),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.category),
            title: Text(item.strCategory),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text(item.strCountry),
          ),
        ),
      ],
    );
  }
}
