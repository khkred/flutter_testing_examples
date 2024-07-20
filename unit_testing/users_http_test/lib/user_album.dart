import 'dart:convert';

import 'package:http/http.dart' as http;

class UserAlbum {
  final http.Client client;

  UserAlbum({required this.client});

  Future<Map<String, dynamic>> fetchAlbum() async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
