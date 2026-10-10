import 'package:dimigoin_app_v4/app/pages/home/controller.dart';
import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/user/model.dart';
import 'package:dimigoin_app_v4/app/services/user/repository.dart';
import 'package:dimigoin_app_v4/app/services/user/service.dart';
import 'package:dimigoin_app_v4/app/services/user/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _TestApi extends ApiProvider {}

class _TestAuthService extends GetxController implements AuthService {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestUserRepository extends UserRepository {
  _TestUserRepository() : super(api: Get.find<ApiProvider>());

  final application = UserApply();
  bool fail = false;

  @override
  Future<UserApply> getUserApply() async {
    if (fail) throw StateError('Network unavailable');
    return application;
  }
}

void main() {
  setUp(() {
    Get.put<ApiProvider>(_TestApi());
    Get.put<AuthService>(_TestAuthService());
  });
  tearDown(Get.reset);

  test('application state refresh works without a home controller', () async {
    final repository = _TestUserRepository();
    final service = UserService(repository: repository);
    expect(Get.isRegistered<HomePageController>(), isFalse);

    await service.refreshUserApply();

    expect(service.userApplyState, isA<UserApplySuccess>());
    expect(Get.isRegistered<HomePageController>(), isFalse);
  });

  test(
    'refresh failure is recorded without failing a completed mutation',
    () async {
      final repository = _TestUserRepository()..fail = true;
      final service = UserService(repository: repository);

      await expectLater(service.refreshUserApply(), completes);
      expect(service.userApplyState, isA<UserApplyFailure>());

      repository.fail = false;
      await service.refreshUserApply();
      expect(service.userApplyState, isA<UserApplySuccess>());
    },
  );
}
