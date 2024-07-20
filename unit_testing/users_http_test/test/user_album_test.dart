import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:users_http_test/user_album.dart';
import 'package:mockito/annotations.dart';

import 'user_album_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('Given an UserAlbum Class, when fetchAlbum() is called then return an JSON IF THE HTTP call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'))).thenAnswer((_) async {
        return http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200);
      });

      final userAlbum = UserAlbum(client: client);

      expect(await userAlbum.fetchAlbum(), isA<Map<String,dynamic>>());
    });

    test('Given an UserAlbum Class, when fetchAlbum() is called, then throws an exception if http call completes with an error', () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'))).thenAnswer((_) async => http.Response('Not Found', 404));

      final userAlbum = UserAlbum(client: client);
      expect(userAlbum.fetchAlbum(), throwsException);
    });
  });
}