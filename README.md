# flutter_testing_examples
Flutter Testing Examples

You can find the article here [Unit Testing Article](https://harishkunchala.com/unit-testing-in-flutter-with-examples)


### What is a Unit Test?
A unit test is a test that verifies the behavior of an isolated piece of code. It can be used to test a single function, method or class.

Let's start with the basic Counter app we get as the default app in Flutter.

## Basic Counter App:
### Actual Code:
Initially separate the counter code from the UI code. So we just put it in a file named `counter.dart`:
```dart
class Counter {  
  int _counter = 0;  
  
  int get count => _counter;  
  
  void incrementCount() {  
    _counter += 1;  
  }  
}
```
### Testing:
Now we can write a unit test for this in a file named `counter_test.dart`. ==As for the name convention it always must end in `_test.dart` with the start being any name.==

In order to test. We'll always have to import ` 'package:flutter_test/flutter_test.dart';`

So we can call a `test(description,body)` function inside our `main()`. 

#### `test(description, body)`:

**Description:**
The standard convention when describing a test class is:

==GIVEN WHEN THEN==

For example in the current scenario we want to check if the count value is 0 when the counter class is instantiated.

So we'll write: *Given counter class when it is instantiated then the value of the count should be 0.*

**Body**:
In here we are going to do three things:
==ARRANGE ACT ASSERT==

ARRANGE: We will declare an object of the class

ACT: We will get the value of the count

ASSERT: We will check if the value is 0

#### Testing Code:

##### Count Test:
And here's the final `counter_test.dart`:
```dart
import 'package:basic_counter/counter.dart';  
import 'package:flutter_test/flutter_test.dart';  
void main() {  
  // given when then  
  test('Given counter class when it is instantiated then value of the count should be 0', (){  
    // Arrange  
    final Counter counter = Counter();  
    // Act  
    final val = counter.count;  
    // Assert  
    expect(val, 0);  
  });  
}
```

We can test the code using the following command:
```bash
flutter test
```

##### `incrementCount()` test
We can also test the `incrementCount()`: using the following code:
```dart
 // given when then  
  test('Given counter class when incrementCount() is called then the value of the count should be 1',(){  
    // Arrange  
    final Counter counter = Counter();  
    // Act  
    counter.incrementCount();  
    final val = counter.count;  
  
    // Assert  
    expect(val, 1);  
  });  
}
```

##### Grouping Tests
Since both of the test are for `Counter` we can group them together like this:
```dart
// Given When Then  
group('Counter Class - ', () {  
  // Arrange  
  final Counter counter = Counter();  
  test(  
      'Given counter class when it is instantiated then value of the count should be 0',  
      () {  
  
    // Act  
    final val = counter.count;  
    // Assert  
    expect(val, 0);  
  });  
  
  // given when then  
  test(  
      'Given counter class when incrementCount() is called then the value of the count should be 1',  
      () {  
    // Act  
    counter.incrementCount();  
    final val = counter.count;  
  
    // Assert  
    expect(val, 1);  
  });  
});
```

### Pre-test and Post-test:
Imagine if we added another function to `Counter` called `decrementCounter()`:
```dart
void decrementCounter() {
	_counter--;
}
```

Now we'll have to again add another test:
```dart
test(  
    'Given counter class when decrementCount() is called then the value of the count should be -1',  
    () {  
  
  counter.decrementCount();  
  final val = counter.count;  
  
  expect(val, -1);  
});
```

The problem is that this test will fail because in the [[#incrementCount() test]] we've increased the value to 1. So now val will be 0. 
This is why Flutter provides us with pre-test and post-test functions.

#### Pre-test Functions:
There are two pretest functions:
- `setUp()`
- `setUpAll()`

##### `setUp()`:
This function will run before every test. So let's say we have 3 tests:

Then it'll be 
setUp --> test --> setUp --> test --> setUp --> test

So in order to solve the above problem of running multiple tests with the same instance of the Counter() we can declare it like this:
```dart
late Counter counter;
	setUp((){
	counter = Counter();
});
```
##### `setUpAll()`:
This function will run only once.

So it'll be:
setUpAll --> test --> test --> test

#### Post-test Functions:
There are two post-test functions:
- `tearDown()`
- `tearDownAll()`
##### `tearDown()`:
The function will run after every test.

test -> tearDown -> test -> tearDown
##### `tearDownAll()`:
The function will only run once after all the tests are done.
test -> test -> test -> tearDownAll


## HTTP User App:

Imagine we have define a basic `User` Model:
```dart
class User {  
  int id;  
  String name;  
  String username;  
  String email;  
  String phone;
  }
```

#### getUser(): 
Now we can define a `UserRepository` class where we can get the user from network from jsonPlaceholder:
```dart
class UserRepository {  
  Future<User> getUser() async {  
    final response = await http.get(  
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),  
    );  
  
    if (response.statusCode == 200) {  
      final responseBody = jsonDecode(response.body);  
      return User.fromJson(responseBody);  
    }  
    throw Exception('Some Error Occurred');  
  }  
}
```

### Testing:
We have multiple testing scenarios
#### Test if it returns an object of the type isUser
```dart
void main() {  
  late UserRepository userRepository;  
  // Pre-test function  
  setUp(() {  
    userRepository = UserRepository();  
  });  
  group('User Repository -', () {  
    group('getUser Function -', () {  
      test(  
          'given UserRepository class when getUser function is called and status code is 200 then the returned object should be a User Model',  
          () async {  
        // Act  
        final user = await userRepository.getUser();  
  
        // Assert  
        expect(user, isA<User>());  
      });  
    });  
  });  
}
```

==If we see line 16. The way we check if it is an object is by using `isA<User>()` function.
This checks if it's an object of that type.==
#### Test if it returns an Exception  when the status code is not 200
```dart
test(  
    'given userRepository class when getUser function is called and the status code is not 200 then the function throws an exception',  
    () async {  
  // Act  
  final user = await userRepository.getUser();  
  
  // Assert  
  expect(user, throwsException);  
});
```

==So as we can see in line 8. We can check for an exception using `throwsException`==

But the problems is when we run the test it is obviously going to fail because the status code is going to be 200. So how do we test the exception test block ?

That's why we are going to use external plugins such as Mockito and Mocktail.

Now if we look at [[#getUser()]] We see that it is dependent on `http` package.

==So whenever there is an external dependency we need to get control over them so that we can test them out properly. This is basically dependency injection.==

#### Dependency Injection for Testing:
Since our main dependency is http. Let's put in the constructor so that we can inject it from anywhere so we are going to change the `UserRepository` to this
```dart
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
```
Since we are calling a constructor, we can switch the http client to a mock client if we want for testing purposes. A mock client allows us to modify its behavior.

For now we will be using the Mocktail from pub.dev as we can pass in a mock client. 

We are going to add Mocktail to the dev dependency
```bash
flutter pub add -d mocktail
```

#### Why do we need Mocktail or any mock class ?
Imagine if we wanted to create a `MockHTTPClient` of `Client` from HTTP. We get the following:

<img src = "https://i.postimg.cc/vH25Sd5f/Screenshot-2024-07-12-at-7-09-17-PM.png"/>
The problem is that we'll have to implement 10 missing overrides just to create the client which obviously is an extremely heavy task. 

This is where Mocktail comes into play. So we can write the following code:
```dart
class MockHTTPClient extends Mock implements Client {}
```
and it doesn't cause any errors.

#### Using Mocktail inside the test function.
We have to use the `when()` to declare the expected output for the `mockHTTPClient`

##### StatusCode 200 test:
```dart
test(  
          'given UserRepository class when getUser function is called and status code is 200 then the returned object should be a User Model',  
          () async {  
        // Arrange  
        when(() => mockHTTPClient  
                .get(Uri.parse('https://jsonplaceholder.typicode.com/users/1')))  
            .thenAnswer((invocation) async {  
          return Response('''  
              {  "id": 1,  "name": "Leanne Graham",  "username": "Bret",  "email": "Sincere@april.biz",  "phone": "1-770-736-8031 x56442",  "website": "hildegard.org"}  
              ''', 200);  
        });  
        // Act  
        final user = await userRepository.getUser();  
  
        // Assert  
        expect(user, isA<User>());  
      });
```

##### Throw Exception test:
```dart
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
```

As you can see here i just changed the status code and this resulted in a exception which satisfies our test case.

So this basically covers Unit Testing