import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test/my_widget.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester to work with.
  testWidgets('MyWidget has a title and message', (tester) async{

    await tester.pumpWidget(const MyWidget(title: 'My Title', message: 'My Message'));

    // Create the text finder
    final titleFinder = find.text('My Title');
    final messageFinder = find.text('My Message');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
