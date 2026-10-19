// To parse this JSON data, do
//
//     final mealModel = mealModelFromJson(jsonString);

import 'dart:convert';

MealModel mealModelFromJson(String str) => MealModel.fromJson(json.decode(str));

String mealModelToJson(MealModel data) => json.encode(data.toJson());

class MealModel {
  List<Meal> meals;

  MealModel({required this.meals});

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
    meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
  };
}

class Meal {
  String strMeal;
  String strMealThumb;
  String idMeal;
  String? strArea;
  String strCountry;

  Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
    required this.strArea,
    required this.strCountry,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    strMeal: json["strMeal"].toString(),
    strMealThumb: json["strMealThumb"].toString(),
    idMeal: json["idMeal"].toString(),
    strArea: json["strArea"]?.toString(),
    strCountry: json["strCountry"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "strMeal": strMeal,
    "strMealThumb": strMealThumb,
    "idMeal": idMeal,
    "strArea": strArea,
    "strCountry": strCountry,
  };
}
