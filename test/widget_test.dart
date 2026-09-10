import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_scene_showcase/main.dart';

void main() {
  testWidgets('Showcase app builds', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    expect(find.byType(ShowcaseApp), findsOneWidget);
  });
}
