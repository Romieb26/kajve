//lib/core/di/app_module.dart
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Registra dependencias de librerías externas que no controlamos
/// nosotros (no podemos anotar la clase `Client` de package:http con
/// @lazySingleton porque no es nuestra). Mismo patrón que un @module
/// para Dio/SharedPreferences: un método por dependencia externa.
@module
abstract class AppModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}
