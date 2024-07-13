import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:users_http_test/user.dart';
import 'package:users_http_test/user_repository.dart';
import 'package:http/http.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;
  // Pre-test function
  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });
  group('User Repository -', () {
    group('getUser Function -', () {
      // given when then
      test(
          'given UserRepository class when getUser function is called and status code is 200 then the returned object should be a User Model',
          () async {
        // Arrange
        when(() => mockHTTPClient
                .get(Uri.parse('https://jsonplaceholder.typicode.com/users/1')))
            .thenAnswer((invocation) async {
          return Response('''
              {
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org"
}
              ''', 200);
        });
        // Act
        final user = await userRepository.getUser();

        // Assert
        expect(user, isA<User>());
      });
      test(
          'given userRepository class when getUser function is called and the status code is not 200 then the function throws an exception',
          () async {
        // Arrange
        when(
          () => mockHTTPClient.get(
            Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
          ),
        ).thenAnswer(
          (invocation) async => Response('', 500),
        );
        // Act
        final user =  userRepository.getUser();

        // Assert
        expect(user, throwsException);
      });
    });
  });
}
