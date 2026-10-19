import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  static const String _baseUrl = 'https://fakestoreapi.com/users';

  Future<List<UserModel>> getUsers() async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load users. Status code: ${response.statusCode}');
  }
}
