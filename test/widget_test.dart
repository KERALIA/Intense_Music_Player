import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intense_audio_player/app/app.dart';

void main() {
  testWidgets('Flick Player app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FlickPlayerApp()));

    // Verify that the Songs screen is displayed initially
    expect(find.text('Your Library'), findsOneWidget);
    expect(find.text('Songs'), findsOneWidget);
  });
}
