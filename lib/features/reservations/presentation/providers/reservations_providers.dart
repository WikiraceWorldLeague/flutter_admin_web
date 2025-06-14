import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../domain/reservation_models.dart';
import '../../data/reservations_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Repository Provider
final reservationsRepositoryProvider = Provider<ReservationsRepository>((ref) {
  final supabase = Supabase.instance.client;
  return ReservationsRepository(supabase);
});

// 예약 필터 상태 관리
final reservationFiltersProvider = StateProvider<ReservationFilters>((ref) {
  return const ReservationFilters();
});

// 예약 목록 상태 관리
class ReservationsListState {
  final PaginatedReservations paginatedReservations;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;

  const ReservationsListState({
    required this.paginatedReservations,
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
  });

  ReservationsListState copyWith({
    PaginatedReservations? paginatedReservations,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
  }) {
    return ReservationsListState(
      paginatedReservations: paginatedReservations ?? this.paginatedReservations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  List<Reservation> get reservations => paginatedReservations.reservations;
  int get totalCount => paginatedReservations.totalCount;
  bool get hasNextPage => paginatedReservations.hasNextPage;
  int get currentPage => paginatedReservations.page;
}

// 예약 목록 StateNotifier
class ReservationsListNotifier extends StateNotifier<ReservationsListState> {
  final ReservationsRepository _repository;
  final Ref _ref;

  ReservationsListNotifier(this._repository, this._ref)
      : super(ReservationsListState(
          paginatedReservations: PaginatedReservations.empty(),
        ));

  // 예약 목록 로드
  Future<void> loadReservations({
    int page = 1,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final filters = _ref.read(reservationFiltersProvider);
      final result = await _repository.getReservations(
        page: page,
        filters: filters.isNotEmpty ? filters : null,
        orderBy: 'reservation_date',
        ascending: false, // 최신순
      );

      if (isRefresh || page == 1) {
        // 새로고침이거나 첫 페이지인 경우 전체 교체
        state = state.copyWith(
          paginatedReservations: result,
          isLoading: false,
          isRefreshing: false,
          error: null,
        );
      } else {
        // 페이지 추가 로드인 경우 기존 목록에 추가
        final updatedReservations = [
          ...state.reservations,
          ...result.reservations,
        ];
        final updatedPaginated = PaginatedReservations(
          reservations: updatedReservations,
          totalCount: result.totalCount,
          page: result.page,
          pageSize: result.pageSize,
          hasNextPage: result.hasNextPage,
        );
        state = state.copyWith(
          paginatedReservations: updatedPaginated,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  // 다음 페이지 로드
  Future<void> loadNextPage() async {
    if (state.hasNextPage && !state.isLoading) {
      await loadReservations(page: state.currentPage + 1);
    }
  }

  // 새로고침
  Future<void> refresh() async {
    await loadReservations(page: 1, isRefresh: true);
  }

  // 필터 변경 시 자동 새로고침
  void onFiltersChanged() {
    loadReservations(page: 1, isRefresh: true);
  }

  // 예약 상태 변경
  Future<void> updateReservationStatus(String id, ReservationStatus status) async {
    try {
      final updatedReservation = await _repository.updateReservationStatus(id, status);
      
      // 상태에서 해당 예약 업데이트
      final updatedReservations = state.reservations.map((reservation) {
        return reservation.id == id ? updatedReservation : reservation;
      }).toList();

      final updatedPaginated = PaginatedReservations(
        reservations: updatedReservations,
        totalCount: state.totalCount,
        page: state.currentPage,
        pageSize: state.paginatedReservations.pageSize,
        hasNextPage: state.hasNextPage,
      );

      state = state.copyWith(paginatedReservations: updatedPaginated);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 가이드 배정
  Future<void> assignGuide(String reservationId, String guideId) async {
    try {
      final updatedReservation = await _repository.assignGuide(reservationId, guideId);
      
      // 상태에서 해당 예약 업데이트
      final updatedReservations = state.reservations.map((reservation) {
        return reservation.id == reservationId ? updatedReservation : reservation;
      }).toList();

      final updatedPaginated = PaginatedReservations(
        reservations: updatedReservations,
        totalCount: state.totalCount,
        page: state.currentPage,
        pageSize: state.paginatedReservations.pageSize,
        hasNextPage: state.hasNextPage,
      );

      state = state.copyWith(paginatedReservations: updatedPaginated);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// 예약 목록 Provider
final reservationsListProvider = StateNotifierProvider<ReservationsListNotifier, ReservationsListState>((ref) {
  final repository = ref.watch(reservationsRepositoryProvider);
  return ReservationsListNotifier(repository, ref);
});

// 클리닉 목록 Provider
final clinicsProvider = FutureProvider<List<Clinic>>((ref) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return repository.getClinics();
});

// 가이드 목록 Provider
final guidesProvider = FutureProvider<List<ReservationGuide>>((ref) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return repository.getGuides();
});

// 단일 예약 조회 Provider
final reservationProvider = FutureProvider.family<Reservation?, String>((ref, id) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return repository.getReservation(id);
});

// 필터 변경 감지 및 자동 새로고침
final _filtersWatcherProvider = Provider<void>((ref) {
  final filters = ref.watch(reservationFiltersProvider);
  final notifier = ref.read(reservationsListProvider.notifier);
  
  // 필터가 변경되면 자동으로 새로고침
  Future.microtask(() => notifier.onFiltersChanged());
  
  return;
});

// 필터 헬퍼 Provider들
final hasActiveFiltersProvider = Provider<bool>((ref) {
  final filters = ref.watch(reservationFiltersProvider);
  return filters.isNotEmpty;
});

final filterSummaryProvider = Provider<String>((ref) {
  final filters = ref.watch(reservationFiltersProvider);
  
  if (filters.isEmpty) return '전체';
  
  final parts = <String>[];
  
  if (filters.status != null) {
    parts.add(filters.status!.displayName);
  }
  
  if (filters.startDate != null || filters.endDate != null) {
    if (filters.startDate != null && filters.endDate != null) {
      parts.add('${_formatDate(filters.startDate!)} ~ ${_formatDate(filters.endDate!)}');
    } else if (filters.startDate != null) {
      parts.add('${_formatDate(filters.startDate!)} 이후');
    } else {
      parts.add('${_formatDate(filters.endDate!)} 이전');
    }
  }
  
  if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
    parts.add('"${filters.searchQuery}"');
  }
  
  return parts.join(', ');
});

String _formatDate(DateTime date) {
  return '${date.month}/${date.day}';
}

// 예약 통계 Provider
final reservationStatsProvider = Provider<Map<ReservationStatus, int>>((ref) {
  final reservations = ref.watch(reservationsListProvider).reservations;
  
  final stats = <ReservationStatus, int>{};
  for (final status in ReservationStatus.values) {
    stats[status] = 0;
  }
  
  for (final reservation in reservations) {
    stats[reservation.status] = (stats[reservation.status] ?? 0) + 1;
  }
  
  return stats;
});

// 가이드 추천 Provider (필요시 사용)
final recommendedGuidesProvider = FutureProvider.family<List<ReservationGuide>, RecommendationParams>((ref, params) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return repository.getRecommendedGuides(
    reservationDate: params.reservationDate,
    startTime: params.startTime,
    endTime: params.endTime,
    requiredLanguages: params.requiredLanguages,
    requiredSpecialties: params.requiredSpecialties,
    clinicRegion: params.clinicRegion,
  );
});

// 가이드 추천 파라미터 클래스
class RecommendationParams {
  final DateTime reservationDate;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> requiredLanguages;
  final List<String> requiredSpecialties;
  final String? clinicRegion;

  const RecommendationParams({
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.requiredLanguages,
    required this.requiredSpecialties,
    this.clinicRegion,
  });
} 