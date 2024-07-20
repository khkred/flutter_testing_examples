import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:users_http_test/user.dart';

class UserRepository {
  final http.Client client;

  UserRepository(this.client);

  Future<User> getUser() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return User.fromJson(responseBody);
    }
    throw Exception('Some Error Occurred');
  }


}
