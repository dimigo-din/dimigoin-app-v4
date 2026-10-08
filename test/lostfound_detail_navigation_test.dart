import 'package:dimigoin_app_v4/app/core/theme/inapp/light.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/controller.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/detail/controller.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/detail/page.dart';
import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/model.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/repository.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class _TestApi extends ApiProvider {}

class _TestAuth extends GetxController implements AuthService {
  @override
  PersonalInformation? get user => null;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestRepository extends LostfoundRepository {
  final requestedIds = <String>[];

  @override
  Future<List<LostfoundReport>> getReports({
    int page = 1,
    LostfoundStatus? status,
    bool? mine,
  }) async => [];

  @override
  Future<LostfoundReport> getReport(String id) async {
    requestedIds.add(id);
    return LostfoundReport(
      id: id,
      status: LostfoundStatus.lost,
      isConcluded: false,
      objectName: 'Test item',
      lastSeenPlace: 'Classroom',
      body: 'Test description',
      createdAt: '2026-10-09T00:00:00Z',
      userId: 'owner',
    );
  }
}

void main() {
  late _TestRepository repository;

  setUpAll(() => initializeDateFormatting('ko_KR'));

  setUp(() {
    Get.put<ApiProvider>(_TestApi());
    Get.put<AuthService>(_TestAuth());
    repository = _TestRepository();
  });
  tearDown(Get.reset);

  Widget app(String initialRoute, {String reportId = 'report-123'}) {
    return GetMaterialApp(
      theme: lightThemeData,
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: Routes.LOSTFOUND,
          binding: BindingsBuilder(() {
            Get.put(
              LostfoundPageController(
                lostfoundService: LostfoundService(repository: repository),
              ),
            );
          }),
          page: () => Scaffold(
            body: TextButton(
              onPressed: () =>
                  Get.find<LostfoundPageController>().openReport(reportId),
              child: const Text('Open report'),
            ),
          ),
        ),
        GetPage(
          name: Routes.LOSTFOUND_DETAIL,
          binding: BindingsBuilder(() {
            Get.lazyPut(
              () => LostfoundDetailPageController(
                lostfoundService: LostfoundService(repository: repository),
              ),
            );
          }),
          page: () => const LostfoundDetailPage(),
        ),
      ],
    );
  }

  testWidgets('direct URL loads the report without navigation arguments', (
    tester,
  ) async {
    await tester.pumpWidget(app('${Routes.LOSTFOUND_DETAIL}?id=report-123'));
    await tester.pumpAndSettle();

    expect(Get.arguments, isNull);
    expect(repository.requestedIds, ['report-123']);
    expect(find.text('Test item'), findsOneWidget);
  });

  testWidgets('opening from the list preserves an encoded ID in the URL', (
    tester,
  ) async {
    const id = 'report +&/?한글';
    await tester.pumpWidget(app(Routes.LOSTFOUND, reportId: id));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open report'));
    await tester.pumpAndSettle();

    expect(Uri.parse(Get.currentRoute).queryParameters['id'], id);
    expect(Get.arguments, isNull);
    expect(repository.requestedIds, [id]);
    expect(find.text('Test item'), findsOneWidget);
  });

  testWidgets('legacy navigation arguments remain supported', (tester) async {
    await tester.pumpWidget(app(Routes.LOSTFOUND));
    await tester.pumpAndSettle();
    Get.toNamed(Routes.LOSTFOUND_DETAIL, arguments: {'id': 'legacy-report'});
    await tester.pumpAndSettle();

    expect(repository.requestedIds, ['legacy-report']);
    expect(find.text('Test item'), findsOneWidget);
  });

  testWidgets('missing ID shows an error without requesting an empty ID', (
    tester,
  ) async {
    await tester.pumpWidget(app(Routes.LOSTFOUND_DETAIL));
    await tester.pumpAndSettle();

    expect(repository.requestedIds, isEmpty);
    expect(find.text('제보를 찾을 수 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
