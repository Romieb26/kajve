//lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Contenedor de dependencias único de la app. Todo lo anotado con
/// @injectable / @lazySingleton / @LazySingleton(as: ...) en cualquier
/// archivo de lib/ se registra acá automáticamente al correr build_runner
/// (genera injection.config.dart, que NO se edita a mano).
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
