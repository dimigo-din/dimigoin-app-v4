import 'package:dimigoin_app_v4/app/core/theme/inapp/light.dart';
import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  Widget app({String initialRoute = Routes.LAUNDRY, VoidCallback? onBack}) {
    return GetMaterialApp(
      theme: lightThemeData,
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: Routes.MAIN,
          page: () => const Scaffold(body: Text('Main')),
        ),
        GetPage(
          name: Routes.LAUNDRY,
          page: () => Scaffold(
            appBar: DFAppBar(title: 'Laundry', onBackPressed: onBack),
            body: const Text('Laundry page'),
          ),
        ),
      ],
    );
  }

  testWidgets('back from a directly opened page navigates to main', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(Get.key.currentState!.canPop(), isFalse);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Main'), findsOneWidget);
    expect(Get.currentRoute, Routes.MAIN);
    expect(Get.key.currentState!.canPop(), isFalse);
  });

  testWidgets('back pops an existing route instead of resetting the stack', (
    tester,
  ) async {
    await tester.pumpWidget(app(initialRoute: Routes.MAIN));
    await tester.pumpAndSettle();
    Get.toNamed(Routes.LAUNDRY);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Main'), findsOneWidget);
    expect(Get.currentRoute, Routes.MAIN);
  });

  testWidgets('explicit back callbacks take precedence', (tester) async {
    var calls = 0;
    await tester.pumpWidget(app(onBack: () => calls++));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(calls, 1);
    expect(Get.currentRoute, Routes.LAUNDRY);
  });

  testWidgets('a route that vetoes popping does not navigate to main', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: lightThemeData,
        home: const PopScope(
          canPop: false,
          child: Scaffold(appBar: DFAppBar(title: 'Protected')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Protected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
