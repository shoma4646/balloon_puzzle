// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stageListHash() => r'0dfaf5366af3731ae30dd1bc830fff238e71dfb0';

/// ステージ一覧を提供するプロバイダー
///
/// Copied from [stageList].
@ProviderFor(stageList)
final stageListProvider = AutoDisposeFutureProvider<List<StageData>>.internal(
  stageList,
  name: r'stageListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$stageListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StageListRef = AutoDisposeFutureProviderRef<List<StageData>>;
String _$stageHash() => r'cd9de085fc67a0aafcc4f544f9f404441b785b73';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 特定のステージデータを提供するプロバイダー
///
/// Copied from [stage].
@ProviderFor(stage)
const stageProvider = StageFamily();

/// 特定のステージデータを提供するプロバイダー
///
/// Copied from [stage].
class StageFamily extends Family<AsyncValue<StageData>> {
  /// 特定のステージデータを提供するプロバイダー
  ///
  /// Copied from [stage].
  const StageFamily();

  /// 特定のステージデータを提供するプロバイダー
  ///
  /// Copied from [stage].
  StageProvider call(
    int stageNumber,
  ) {
    return StageProvider(
      stageNumber,
    );
  }

  @override
  StageProvider getProviderOverride(
    covariant StageProvider provider,
  ) {
    return call(
      provider.stageNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stageProvider';
}

/// 特定のステージデータを提供するプロバイダー
///
/// Copied from [stage].
class StageProvider extends AutoDisposeFutureProvider<StageData> {
  /// 特定のステージデータを提供するプロバイダー
  ///
  /// Copied from [stage].
  StageProvider(
    int stageNumber,
  ) : this._internal(
          (ref) => stage(
            ref as StageRef,
            stageNumber,
          ),
          from: stageProvider,
          name: r'stageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stageHash,
          dependencies: StageFamily._dependencies,
          allTransitiveDependencies: StageFamily._allTransitiveDependencies,
          stageNumber: stageNumber,
        );

  StageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.stageNumber,
  }) : super.internal();

  final int stageNumber;

  @override
  Override overrideWith(
    FutureOr<StageData> Function(StageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StageProvider._internal(
        (ref) => create(ref as StageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        stageNumber: stageNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<StageData> createElement() {
    return _StageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StageProvider && other.stageNumber == stageNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, stageNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StageRef on AutoDisposeFutureProviderRef<StageData> {
  /// The parameter `stageNumber` of this provider.
  int get stageNumber;
}

class _StageProviderElement extends AutoDisposeFutureProviderElement<StageData>
    with StageRef {
  _StageProviderElement(super.provider);

  @override
  int get stageNumber => (origin as StageProvider).stageNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
