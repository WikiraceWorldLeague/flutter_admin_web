import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/data/repositories/customers_repository.dart';

part 'customers_providers.g.dart';

/// 고객 목록 조회 Provider
@riverpod
Future<List<Customer>> customersList(
  CustomersListRef ref, {
  CustomerFilters? filters,
  int? limit,
  int? offset,
}) async {
  final repository = ref.read(customersRepositoryProvider);
  return repository.getCustomers(
    filters: filters,
    limit: limit,
    offset: offset,
  );
}

/// 고객 상세 조회 Provider
@riverpod
Future<Customer?> customerDetail(CustomerDetailRef ref, String id) async {
  final repository = ref.read(customersRepositoryProvider);
  return repository.getCustomerById(id);
}

/// 고객 검색 Provider
@riverpod
Future<List<Customer>> customersSearch(
  CustomersSearchRef ref,
  String query,
) async {
  if (query.isEmpty) return [];

  final repository = ref.read(customersRepositoryProvider);
  return repository.searchCustomers(query);
}

/// 고객 통계 Provider
@riverpod
Future<CustomerStats> customerStats(CustomerStatsRef ref) async {
  final repository = ref.read(customersRepositoryProvider);
  return repository.getCustomerStats();
}

/// 고객 생성 Provider
@riverpod
class CustomerCreator extends _$CustomerCreator {
  @override
  FutureOr<void> build() => null;

  /// 고객 생성
  Future<Customer> createCustomer(CustomerInput input) async {
    final repository = ref.read(customersRepositoryProvider);
    final customer = await repository.createCustomer(input);

    // 관련 providers 무효화
    ref.invalidate(customersListProvider);
    ref.invalidate(customerStatsProvider);

    return customer;
  }
}

/// 고객 수정 Provider
@riverpod
class CustomerUpdater extends _$CustomerUpdater {
  @override
  FutureOr<void> build() => null;

  /// 고객 정보 수정
  Future<Customer> updateCustomer(String id, CustomerInput input) async {
    final repository = ref.read(customersRepositoryProvider);
    final customer = await repository.updateCustomer(id, input);

    // 관련 providers 무효화
    ref.invalidate(customersListProvider);
    ref.invalidate(customerDetailProvider(id));
    ref.invalidate(customerStatsProvider);

    return customer;
  }
}

/// 고객 삭제 Provider
@riverpod
class CustomerDeleter extends _$CustomerDeleter {
  @override
  FutureOr<void> build() => null;

  /// 고객 삭제
  Future<void> deleteCustomer(String id) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(customersRepositoryProvider);
      await repository.deleteCustomer(id);

      // 관련 providers 무효화
      ref.invalidate(customersListProvider);
      ref.invalidate(customerDetailProvider(id));
      ref.invalidate(customerStatsProvider);

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
