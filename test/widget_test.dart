import 'package:dimigoin_app_v4/app/core/theme/inapp/light.dart';
import 'package:dimigoin_app_v4/app/pages/test/binding.dart';
import 'package:dimigoin_app_v4/app/pages/test/page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Test route page renders route links', (tester) async {
    TestPageBinding().dependencies();

    await tester.pumpWidget(
      GetMaterialApp(theme: lightThemeData, home: const TestPage()),
    );

    expect(find.text('/stay'), findsOneWidget);
    expect(find.text('/repair'), findsOneWidget);
  });
}
