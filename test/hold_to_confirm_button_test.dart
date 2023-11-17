import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hold_to_confirm_button/hold_to_confirm_button.dart';

void main() {
  testWidgets('test a widget', (tester) async {
    // Create the widget.
    await tester.pumpWidget(HoldToConfirmButton(
      text: 'Public',
      holdingText: 'Sure?',
      onCompleted: () {},
    ));

    final textPublic = find.text('Public');
    final textSure = find.text('Sure?');
    final findButton = find.byType(HoldToConfirmButton);

    // #1. Verify button is built.
    expect(findButton, findsOneWidget);

    // #2. Verify the default text is "Public".
    expect(textPublic, findsOneWidget);
    expect(textSure, findsNothing);
    expect(find.byIcon(Icons.done), findsNothing);

    // Long press the button for 0.5 seconds.
    await tester.longPress(findButton);
    await tester.pumpAndSettle();

    // #3. Verify the text is "Sure?".
    expect(textPublic, findsNothing);
    expect(textSure, findsOneWidget);
    expect(find.byIcon(Icons.done), findsNothing);

    // Long press the button more than 2 seconds.
    final Offset centerLocation = tester.getCenter(findButton);
    final TestGesture gesture = await tester.startGesture(centerLocation);
    await tester.pumpAndSettle();
    await gesture.up(timeStamp: const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // #4. Verify has the icon is "Icons.done".
    expect(textPublic, findsNothing);
    expect(textSure, findsNothing);
    expect(find.byIcon(Icons.done), findsOneWidget);
  });
}
