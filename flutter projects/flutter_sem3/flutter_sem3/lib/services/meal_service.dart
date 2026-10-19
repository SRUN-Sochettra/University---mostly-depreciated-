import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/meal_detail_model.dart';
import '../models/meal_model.dart';

class MealService {
  final _baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  Future<List<Meal>> fetchMeals() async {
    final url = "$_baseUrl/filter.php?c=Seafood";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final model = await compute(mealModelFromJson, response.body);
        return model.meals;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load meals: $e');
    }
  }

  Future<MealElement> get(String id) async {
    final url = "$_baseUrl/lookup.php?i=$id";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final model = await compute(mealDetailModelFromJson, response.body);
        return model.meals[0];
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}
