import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sem3/models/meal_detail_model.dart';
import 'package:flutter_sem3/models/meal_model.dart';
import 'package:flutter_sem3/services/meal_service.dart';

final mealServiceProvider = Provider<MealService>((ref) {
  return MealService();
});

class MealProvider extends AsyncNotifier<List<Meal>> {
  @override
  FutureOr<List<Meal>> build() {
    final service = ref.read(mealServiceProvider);
    return service.fetchMeals();
  }

  Future<void> refreshMeals() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(mealServiceProvider);
      return service.fetchMeals();
    });
  }
}

final mealNotifierProvider = AsyncNotifierProvider(MealProvider.new);

final mealDetailProvider = FutureProvider.family<MealElement, String>((ref, id){
  final service = ref.watch(mealServiceProvider);
  return service.get(id);
});