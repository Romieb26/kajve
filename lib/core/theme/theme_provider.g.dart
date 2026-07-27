// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeModeControllerHash() =>
    r'4011b9eae7f625c3ac2da6643cf6b1e28f24da63';

/// Controla el modo de tema (claro/oscuro) elegido manualmente por el
/// usuario en el perfil, persistido en el dispositivo. No sigue el
/// tema del sistema operativo.
///
/// Copied from [ThemeModeController].
@ProviderFor(ThemeModeController)
final themeModeControllerProvider =
    AutoDisposeNotifierProvider<ThemeModeController, ThemeMode>.internal(
      ThemeModeController.new,
      name: r'themeModeControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeModeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeModeController = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
