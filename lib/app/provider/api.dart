import 'api_interface.dart';
import 'middlewares/log.dart';
import 'middlewares/jwt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProdApiProvider extends ApiProvider {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  ProdApiProvider() {
    dio.options.baseUrl = baseUrl;

    print('✅ API baseUrl loaded: $baseUrl');

    middlewares.add(LogMiddleware());
    middlewares.add(JWTMiddleware());
  }
}