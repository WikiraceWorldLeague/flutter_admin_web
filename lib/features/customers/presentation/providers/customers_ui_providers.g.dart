// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_ui_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerFiltersNotifierHash() =>
    r'621a517d7e772b9b00ec6e01b5c670c06339de22';

/// 고객 목록 필터 상태 Provider
///
/// Copied from [CustomerFiltersNotifier].
@ProviderFor(CustomerFiltersNotifier)
final customerFiltersNotifierProvider = AutoDisposeNotifierProvider<
  CustomerFiltersNotifier,
  CustomerFilters
>.internal(
  CustomerFiltersNotifier.new,
  name: r'customerFiltersNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerFiltersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerFiltersNotifier = AutoDisposeNotifier<CustomerFilters>;
String _$customerPaginationNotifierHash() =>
    r'8730da54d367c25017f5d08fbb682c0f99d052d7';

/// 고객 목록 페이지네이션 상태 Provider
///
/// Copied from [CustomerPaginationNotifier].
@ProviderFor(CustomerPaginationNotifier)
final customerPaginationNotifierProvider = AutoDisposeNotifierProvider<
  CustomerPaginationNotifier,
  CustomerPaginationState
>.internal(
  CustomerPaginationNotifier.new,
  name: r'customerPaginationNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerPaginationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerPaginationNotifier =
    AutoDisposeNotifier<CustomerPaginationState>;
String _$customerFormNotifierHash() =>
    r'a502561e9163764b771c6fa91b6c04b97396ae01';

/// 고객 폼 상태 Provider
///
/// Copied from [CustomerFormNotifier].
@ProviderFor(CustomerFormNotifier)
final customerFormNotifierProvider =
    AutoDisposeNotifierProvider<CustomerFormNotifier, CustomerInput>.internal(
      CustomerFormNotifier.new,
      name: r'customerFormNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customerFormNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerFormNotifier = AutoDisposeNotifier<CustomerInput>;
String _$selectedCustomerNotifierHash() =>
    r'91e4b72f35e51fd9fecc96c8dc615b6ab6ec224e';

/// 선택된 고객 상태 Provider
///
/// Copied from [SelectedCustomerNotifier].
@ProviderFor(SelectedCustomerNotifier)
final selectedCustomerNotifierProvider =
    AutoDisposeNotifierProvider<SelectedCustomerNotifier, Customer?>.internal(
      SelectedCustomerNotifier.new,
      name: r'selectedCustomerNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedCustomerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCustomerNotifier = AutoDisposeNotifier<Customer?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
