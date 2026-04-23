import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';

class ProductService {
  Future<List<ProductModel>> readApiData() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://api.escuelajs.co/api/v1/products"),
      );
      if (response.statusCode == 200) {
        return compute(productModelFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}