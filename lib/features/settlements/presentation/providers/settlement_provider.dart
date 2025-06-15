import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/settlement_service.dart';
import '../../domain/models/settlement_item.dart';

// Settlement service provider
final settlementServiceProvider = Provider<SettlementService>((ref) {
  return SettlementService();
});

// Settlement filters state
class SettlementFilters {
  final String? guideId;
  final SettlementStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const SettlementFilters({
    this.guideId,
    this.status,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  SettlementFilters copyWith({
    String? guideId,
    SettlementStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return SettlementFilters(
      guideId: guideId ?? this.guideId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Settlement filters provider
final settlementFiltersProvider = StateProvider<SettlementFilters>((ref) {
  return const SettlementFilters();
});

// Settlement items provider
final settlementItemsProvider = FutureProvider<List<SettlementItem>>((
  ref,
) async {
  final service = ref.read(settlementServiceProvider);
  final filters = ref.watch(settlementFiltersProvider);

  try {
    return await service.getSettlementItems(
      guideId: filters.guideId,
      status: filters.status,
      startDate: filters.startDate,
      endDate: filters.endDate,
    );
  } catch (e) {
    // Return empty list if there's an error (for now)
    return [];
  }
});

// Settlement summary provider
final settlementSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final service = ref.read(settlementServiceProvider);
  final filters = ref.watch(settlementFiltersProvider);

  return service.getSettlementSummary(
    startDate: filters.startDate,
    endDate: filters.endDate,
  );
});

// Guides for filter provider
final guidesForFilterProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final service = ref.read(settlementServiceProvider);
  return service.getGuidesForFilter();
});

// Settlement actions provider
final settlementActionsProvider = Provider<SettlementActions>((ref) {
  return SettlementActions(ref);
});

class SettlementActions {
  final Ref _ref;

  SettlementActions(this._ref);

  Future<void> updateSettlementStatus(
    String settlementId,
    SettlementStatus status, {
    String? notes,
  }) async {
    final service = _ref.read(settlementServiceProvider);
    await service.updateSettlementStatus(settlementId, status, notes: notes);

    // Refresh data
    _ref.invalidate(settlementItemsProvider);
    _ref.invalidate(settlementSummaryProvider);
  }

  Future<void> bulkUpdateSettlementStatus(
    List<String> settlementIds,
    SettlementStatus status, {
    String? notes,
  }) async {
    final service = _ref.read(settlementServiceProvider);
    await service.bulkUpdateSettlementStatus(
      settlementIds,
      status,
      notes: notes,
    );

    // Refresh data
    _ref.invalidate(settlementItemsProvider);
    _ref.invalidate(settlementSummaryProvider);
  }

  void updateFilters(SettlementFilters filters) {
    _ref.read(settlementFiltersProvider.notifier).state = filters;
  }

  void clearFilters() {
    _ref.read(settlementFiltersProvider.notifier).state =
        const SettlementFilters();
  }
}
