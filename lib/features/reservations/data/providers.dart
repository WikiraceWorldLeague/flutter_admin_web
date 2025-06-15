import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';
import '../domain/reservation_models.dart';
import 'reservations_repository.dart';
import 'reservation_service.dart';

// Supabase 클라이언트 프로바이더 (직접 생성)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  // 기존 클라이언트가 제대로 초기화되지 않았을 수 있으므로 직접 생성
  final client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);
  print('🔍 Direct Supabase Client Created');
  return client;
});

// 예약 저장소 프로바이더
final reservationsRepositoryProvider = Provider<ReservationsRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ReservationsRepository(supabase);
});

// 예약 필터 상태 프로바이더
final reservationFilterProvider = StateProvider<ReservationFilter>((ref) {
  return const ReservationFilter();
});

// 예약 페이지 상태 프로바이더
final reservationPageProvider = StateProvider<int>((ref) => 1);

// 페이지 크기 상태 프로바이더
final reservationPageSizeProvider = StateProvider<int>((ref) => 20);

// 예약 목록 프로바이더
final reservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  // TODO: 실제 예약 목록 조회 구현
  return [];
});

// 예약 통계 프로바이더
final reservationStatsProvider = FutureProvider.autoDispose<ReservationStats>((
  ref,
) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return await repository.getReservationStats();
});

// 특정 예약 프로바이더
final reservationProvider = FutureProvider.autoDispose
    .family<Reservation?, String>((ref, id) async {
      final repository = ref.watch(reservationsRepositoryProvider);
      return await repository.getReservation(id);
    });

// ReservationService 인스턴스 프로바이더
final reservationServiceProvider = Provider<ReservationService>((ref) {
  return ReservationService();
});

// 클리닉 목록 프로바이더
final clinicsProvider = FutureProvider<List<Clinic>>((ref) async {
  final service = ref.read(reservationServiceProvider);
  return service.getClinics();
});

// 서비스 타입 목록 프로바이더 (더 이상 비동기가 아님)
final serviceTypesProvider = Provider<List<ServiceTypeEnum>>((ref) {
  final service = ref.read(reservationServiceProvider);
  return service.getServiceTypes();
});

// 가이드 추천 프로바이더
final guideRecommendationsProvider = FutureProvider.autoDispose
    .family<List<GuideRecommendation>, String>((ref, reservationId) async {
      final repository = ref.watch(reservationsRepositoryProvider);
      return await repository.getGuideRecommendations(reservationId);
    });

// 예약 생성 상태 프로바이더
class ReservationFormNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createReservation(CreateReservationRequestNew request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(reservationServiceProvider);
      await service.createReservation(request);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateStatus(
    String reservationId,
    ReservationStatus status,
  ) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(reservationsRepositoryProvider);
      await repository.updateReservation(reservationId, {
        'status': status.name,
      });
      state = const AsyncValue.data(null);
      // 예약 목록 새로고침
      ref.invalidate(filteredReservationsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> assignGuide(String reservationId, String guideId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(reservationsRepositoryProvider);
      await repository.updateReservation(reservationId, {
        'guide_id': guideId,
        'status': 'assigned',
      });
      state = const AsyncValue.data(null);
      // 예약 목록 새로고침
      ref.invalidate(filteredReservationsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final reservationFormProvider =
    NotifierProvider<ReservationFormNotifier, AsyncValue<void>>(() {
      return ReservationFormNotifier();
    });

// 선택된 예약 프로바이더 (가이드 할당 모달용)
final selectedReservationProvider = StateProvider<Reservation?>((ref) => null);

// 검색어 프로바이더
final searchQueryProvider = StateProvider<String>((ref) => '');

// 검색 결과 프로바이더
final searchResultsProvider = FutureProvider.autoDispose<PaginatedReservations>(
  (ref) async {
    final repository = ref.watch(reservationsRepositoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    if (searchQuery.isEmpty) {
      return const PaginatedReservations(
        reservations: [],
        totalCount: 0,
        page: 1,
        pageSize: 20,
        hasNextPage: false,
      );
    }

    // 임시로 기본 조회만 수행 (검색 기능은 나중에 구현)
    return await repository.getReservations(page: 1, pageSize: 10);
  },
);

// 예약 생성 폼 상태 프로바이더들
final reservationDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final durationProvider = StateProvider<int>((ref) => 180); // 기본 3시간
final selectedClinicProvider = StateProvider<Clinic?>((ref) => null);
final selectedGuideProvider = StateProvider<ReservationGuide?>((ref) => null);
final selectedServiceTypesProvider = StateProvider<List<ServiceTypeEnum>>(
  (ref) => [],
);
final reservationNotesProvider = StateProvider<String>((ref) => '');

// 고객 정보 프로바이더들
final customersProvider = StateProvider<List<CustomerRequest>>((ref) => []);

// 필터 상태 관리 프로바이더들
final statusFilterProvider = StateProvider<ReservationStatus?>((ref) => null);
final clinicFilterProvider = StateProvider<Clinic?>((ref) => null);
final serviceTypeFilterProvider = StateProvider<ServiceTypeEnum?>(
  (ref) => null,
);
final dateFromFilterProvider = StateProvider<DateTime?>((ref) => null);
final dateToFilterProvider = StateProvider<DateTime?>((ref) => null);

// 통합 필터 생성 프로바이더
final activeFilterProvider = Provider<ReservationFilter>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final status = ref.watch(statusFilterProvider);
  final clinic = ref.watch(clinicFilterProvider);
  final serviceType = ref.watch(serviceTypeFilterProvider);
  final dateFrom = ref.watch(dateFromFilterProvider);
  final dateTo = ref.watch(dateToFilterProvider);

  return ReservationFilter(
    searchQuery: searchQuery.isEmpty ? null : searchQuery,
    status: status,
    clinicId: clinic?.id,
    guideId: null, // serviceType는 guideId가 아니므로 null로 설정
    startDate: dateFrom,
    endDate: dateTo,
  );
});

// 필터링된 예약 목록 프로바이더
final filteredReservationsProvider =
    FutureProvider.autoDispose<PaginatedReservations>((ref) async {
      final repository = ref.watch(reservationsRepositoryProvider);
      final page = ref.watch(reservationPageProvider);
      final pageSize = ref.watch(reservationPageSizeProvider);

      return await repository.getReservations(page: page, pageSize: pageSize);
    });

// 오늘 예약 알림 프로바이더
final todayReservationsProvider = FutureProvider.autoDispose<List<Reservation>>(
  (ref) async {
    final repository = ref.watch(reservationsRepositoryProvider);

    // 임시로 모든 예약을 가져온 후 필터링
    final result = await repository.getReservations(page: 1, pageSize: 100);

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return result.reservations.where((reservation) {
      final reservationDate = reservation.reservationDate;
      return reservationDate.isAfter(todayStart) &&
          reservationDate.isBefore(todayEnd);
    }).toList();
  },
);

// 30분 전 알림 예약 프로바이더
final upcomingReservationsProvider =
    FutureProvider.autoDispose<List<Reservation>>((ref) async {
      final todayReservations = await ref.watch(
        todayReservationsProvider.future,
      );
      final now = DateTime.now();
      final thirtyMinutesLater = now.add(const Duration(minutes: 30));

      return todayReservations.where((reservation) {
        final startTime = reservation.startTime;
        return startTime.isAfter(now) && startTime.isBefore(thirtyMinutesLater);
      }).toList();
    });

// 예약 생성 프로바이더
final createReservationProvider =
    FutureProvider.family<String, CreateReservationRequestNew>((
      ref,
      request,
    ) async {
      final service = ref.read(reservationServiceProvider);
      return service.createReservation(request);
    });
