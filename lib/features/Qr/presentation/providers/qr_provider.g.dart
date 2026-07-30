
part of 'qr_provider.dart';



String _$qrControllerHash() => r'1dd27aa07b2a022d19d514331d9f9ec9832a021f';

/// See also [QrController].
@ProviderFor(QrController)
final qrControllerProvider =
    AutoDisposeNotifierProvider<QrController, QrState>.internal(
      QrController.new,
      name: r'qrControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$qrControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QrController = AutoDisposeNotifier<QrState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
