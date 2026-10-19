import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sem3/models/meal_model.dart';
import 'package:flutter_sem3/providers/meal_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  ConsumerState<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels >= 500) {
        setState(() {
          _showButton = true;
        });
      } else {
        setState(() {
          _showButton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meal Menu")),
      body: _buildBody(),
      floatingActionButton: _showButton ? _buildFloating() : null,
    );
  }

  Widget _buildBody() {
    final mealAsync = ref.watch(mealNotifierProvider);

    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(mealNotifierProvider.notifier).refreshMeals();
        },
        child: mealAsync.when(
          data: (items) {
            return _buildGridView(items);
          },
          error: (e, s) {
            debugPrint("Error: ${e.toString()}");
            debugPrint("TrackTrace: ${s.toString()}");
            return Text("Error: ${e.toString()}");
          },
          loading: () {
            return _buildSkeleton();
          },
        ),
      ),
    );
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_upward),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      child: GridView.builder(
        itemCount: 40,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: .circular(8),
                      child: Container(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "asdsadasd sadassa",
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  final _scroller = ScrollController();

  Widget _buildGridView(List<Meal> items) {
    if (items.isEmpty) {
      return const Text("No items");
    }

    return GridView.builder(
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItem(item);
      },
    );
  }

  Widget _buildItem(Meal item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: item.idMeal);
      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: .circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.strMealThumb,
                    fit: .cover,
                    width: double.maxFinite,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.strMeal, maxLines: 1, overflow: .ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
