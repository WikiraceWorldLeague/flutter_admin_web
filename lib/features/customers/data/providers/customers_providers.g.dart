// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customersListHash() => r'284ed5785cc7b0a4dd723544d14998a04bb978c3';

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

/// 고객 목록 조회 Provider
///
/// Copied from [customersList].
@ProviderFor(customersList)
const customersListProvider = CustomersListFamily();

/// 고객 목록 조회 Provider
///
/// Copied from [customersList].
class CustomersListFamily extends Family<AsyncValue<List<Customer>>> {
  /// 고객 목록 조회 Provider
  ///
  /// Copied from [customersList].
  const CustomersListFamily();

  /// 고객 목록 조회 Provider
  ///
  /// Copied from [customersList].
  CustomersListProvider call({
    CustomerFilters? filters,
    int? limit,
    int? offset,
  }) {
    return CustomersListProvider(
      filters: filters,
      limit: limit,
      offset: offset,
    );
  }

  @override
  CustomersListProvider getProviderOverride(
    covariant CustomersListProvider provider,
  ) {
    return call(
      filters: provider.filters,
      limit: provider.limit,
      offset: provider.offset,
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
  String? get name => r'customersListProvider';
}

/// 고객 목록 조회 Provider
///
/// Copied from [customersList].
class CustomersListProvider extends AutoDisposeFutureProvider<List<Customer>> {
  /// 고객 목록 조회 Provider
  ///
  /// Copied from [customersList].
  CustomersListProvider({CustomerFilters? filters, int? limit, int? offset})
    : this._internal(
        (ref) => customersList(
          ref as CustomersListRef,
          filters: filters,
          limit: limit,
          offset: offset,
        ),
        from: customersListProvider,
        name: r'customersListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$customersListHash,
        dependencies: CustomersListFamily._dependencies,
        allTransitiveDependencies:
            CustomersListFamily._allTransitiveDependencies,
        filters: filters,
        limit: limit,
        offset: offset,
      );

  CustomersListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filters,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final CustomerFilters? filters;
  final int? limit;
  final int? offset;

  @override
  Override overrideWith(
    FutureOr<List<Customer>> Function(CustomersListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersListProvider._internal(
        (ref) => create(ref as CustomersListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filters: filters,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Customer>> createElement() {
    return _CustomersListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersListProvider &&
        other.filters == filters &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersListRef on AutoDisposeFutureProviderRef<List<Customer>> {
  /// The parameter `filters` of this provider.
  CustomerFilters? get filters;

  /// The parameter `limit` of this provider.
  int? get limit;

  /// The parameter `offset` of this provider.
  int? get offset;
}

class _CustomersListProviderElement
    extends AutoDisposeFutureProviderElement<List<Customer>>
    with CustomersListRef {
  _CustomersListProviderElement(super.provider);

  @override
  CustomerFilters? get filters => (origin as CustomersListProvider).filters;
  @override
  int? get limit => (origin as CustomersListProvider).limit;
  @override
  int? get offset => (origin as CustomersListProvider).offset;
}

String _$customerDetailHash() => r'59ade8db5a017bac39eb269fbc63c987500e56ab';

/// 고객 상세 조회 Provider
///
/// Copied from [customerDetail].
@ProviderFor(customerDetail)
const customerDetailProvider = CustomerDetailFamily();

/// 고객 상세 조회 Provider
///
/// Copied from [customerDetail].
class CustomerDetailFamily extends Family<AsyncValue<Customer?>> {
  /// 고객 상세 조회 Provider
  ///
  /// Copied from [customerDetail].
  const CustomerDetailFamily();

  /// 고객 상세 조회 Provider
  ///
  /// Copied from [customerDetail].
  CustomerDetailProvider call(String id) {
    return CustomerDetailProvider(id);
  }

  @override
  CustomerDetailProvider getProviderOverride(
    covariant CustomerDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerDetailProvider';
}

/// 고객 상세 조회 Provider
///
/// Copied from [customerDetail].
class CustomerDetailProvider extends AutoDisposeFutureProvider<Customer?> {
  /// 고객 상세 조회 Provider
  ///
  /// Copied from [customerDetail].
  CustomerDetailProvider(String id)
    : this._internal(
        (ref) => customerDetail(ref as CustomerDetailRef, id),
        from: customerDetailProvider,
        name: r'customerDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$customerDetailHash,
        dependencies: CustomerDetailFamily._dependencies,
        allTransitiveDependencies:
            CustomerDetailFamily._allTransitiveDependencies,
        id: id,
      );

  CustomerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Customer?> Function(CustomerDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerDetailProvider._internal(
        (ref) => create(ref as CustomerDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Customer?> createElement() {
    return _CustomerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerDetailRef on AutoDisposeFutureProviderRef<Customer?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CustomerDetailProviderElement
    extends AutoDisposeFutureProviderElement<Customer?>
    with CustomerDetailRef {
  _CustomerDetailProviderElement(super.provider);

  @override
  String get id => (origin as CustomerDetailProvider).id;
}

String _$customersSearchHash() => r'781ea966813c2c7b5d424a65ebebf80526a3833e';

/// 고객 검색 Provider
///
/// Copied from [customersSearch].
@ProviderFor(customersSearch)
const customersSearchProvider = CustomersSearchFamily();

/// 고객 검색 Provider
///
/// Copied from [customersSearch].
class CustomersSearchFamily extends Family<AsyncValue<List<Customer>>> {
  /// 고객 검색 Provider
  ///
  /// Copied from [customersSearch].
  const CustomersSearchFamily();

  /// 고객 검색 Provider
  ///
  /// Copied from [customersSearch].
  CustomersSearchProvider call(String query) {
    return CustomersSearchProvider(query);
  }

  @override
  CustomersSearchProvider getProviderOverride(
    covariant CustomersSearchProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customersSearchProvider';
}

/// 고객 검색 Provider
///
/// Copied from [customersSearch].
class CustomersSearchProvider
    extends AutoDisposeFutureProvider<List<Customer>> {
  /// 고객 검색 Provider
  ///
  /// Copied from [customersSearch].
  CustomersSearchProvider(String query)
    : this._internal(
        (ref) => customersSearch(ref as CustomersSearchRef, query),
        from: customersSearchProvider,
        name: r'customersSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$customersSearchHash,
        dependencies: CustomersSearchFamily._dependencies,
        allTransitiveDependencies:
            CustomersSearchFamily._allTransitiveDependencies,
        query: query,
      );

  CustomersSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Customer>> Function(CustomersSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersSearchProvider._internal(
        (ref) => create(ref as CustomersSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Customer>> createElement() {
    return _CustomersSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersSearchRef on AutoDisposeFutureProviderRef<List<Customer>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _CustomersSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Customer>>
    with CustomersSearchRef {
  _CustomersSearchProviderElement(super.provider);

  @override
  String get query => (origin as CustomersSearchProvider).query;
}

String _$customerStatsHash() => r'2d6baca8e2ae0dd457ba7b9ea642e121cedf6e12';

/// 고객 통계 Provider
///
/// Copied from [customerStats].
@ProviderFor(customerStats)
final customerStatsProvider = AutoDisposeFutureProvider<CustomerStats>.internal(
  customerStats,
  name: r'customerStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomerStatsRef = AutoDisposeFutureProviderRef<CustomerStats>;
String _$customerCreatorHash() => r'4d99f488f3056cc7c2664af86042045bfd114e47';

/// 고객 생성 Provider
///
/// Copied from [CustomerCreator].
@ProviderFor(CustomerCreator)
final customerCreatorProvider =
    AutoDisposeAsyncNotifierProvider<CustomerCreator, void>.internal(
      CustomerCreator.new,
      name: r'customerCreatorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customerCreatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerCreator = AutoDisposeAsyncNotifier<void>;
String _$customerUpdaterHash() => r'1d3651e605dce8a74919880880031e64c3c98edb';

/// 고객 수정 Provider
///
/// Copied from [CustomerUpdater].
@ProviderFor(CustomerUpdater)
final customerUpdaterProvider =
    AutoDisposeAsyncNotifierProvider<CustomerUpdater, void>.internal(
      CustomerUpdater.new,
      name: r'customerUpdaterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customerUpdaterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerUpdater = AutoDisposeAsyncNotifier<void>;
String _$customerDeleterHash() => r'b9ea23a45f3e33d629c43736b72760688da3008a';

/// 고객 삭제 Provider
///
/// Copied from [CustomerDeleter].
@ProviderFor(CustomerDeleter)
final customerDeleterProvider =
    AutoDisposeAsyncNotifierProvider<CustomerDeleter, void>.internal(
      CustomerDeleter.new,
      name: r'customerDeleterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customerDeleterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerDeleter = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
