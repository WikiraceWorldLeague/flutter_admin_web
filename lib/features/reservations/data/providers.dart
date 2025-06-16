import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

import '../../../core/config/supabase_config.dart';
import '../domain/reservation_models.dart';
import 'reservations_repository.dart';

part 'providers.g.dart';

// Supabase 클라이언트 프로바이더 (직접 생성)
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  // 기존 클라이언트가 제대로 초기화되지 않았을 수 있으므로 직접 생성
  final client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);
  log('🔍 Direct Supabase Client Created', name: 'ProvidersRepository');
  return client;
}

// 예약 저장소 프로바이더
@riverpod
ReservationsRepository reservationsRepository(ReservationsRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ReservationsRepository(supabase);
}

// 예약 필터 상태 프로바이더
@riverpod
class ReservationFilterNotifier extends _$ReservationFilterNotifier {
  @override
  ReservationFilters build() => const ReservationFilters();

  void updateFilter(ReservationFilters filter) => state = filter;
  void clearFilter() => state = const ReservationFilters();
}

// 예약 페이지 상태 프로바이더
@riverpod
class ReservationPage extends _$ReservationPage {
  @override
  int build() => 1;

  void setPage(int page) => state = page;
  void nextPage() => state = state + 1;
  void previousPage() => state = state > 1 ? state - 1 : 1;
}

// 페이지 크기 상태 프로바이더
@riverpod
class ReservationPageSize extends _$ReservationPageSize {
  @override
  int build() => 20;

  void setPageSize(int size) => state = size;
}

// 예약 목록 프로바이더
@riverpod
Future<List<Reservation>> reservations(ReservationsRef ref) async {
  // TODO: 실제 예약 목록 조회 구현
  return [];
}

// 예약 통계 프로바이더
@riverpod
Future<ReservationStats> reservationStats(ReservationStatsRef ref) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return await repository.getReservationStats();
}

// 특정 예약 프로바이더
@riverpod
Future<Reservation?> reservation(ReservationRef ref, String id) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return await repository.getReservation(id);
}

// 클리닉 목록 프로바이더
@riverpod
Future<List<Clinic>> clinics(ClinicsRef ref) async {
  final repository = ref.read(reservationsRepositoryProvider);
  return repository.getClinics();
}

// 서비스 타입 목록 프로바이더
@riverpod
List<ServiceTypeEnum> serviceTypes(ServiceTypesRef ref) {
  final repository = ref.read(reservationsRepositoryProvider);
  return repository.getServiceTypes();
}

// 가이드 추천 프로바이더
@riverpod
Future<List<GuideRecommendation>> guideRecommendations(
  GuideRecommendationsRef ref,
  String reservationId,
) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  return await repository.getGuideRecommendations(reservationId);
}

// 예약 생성 상태 프로바이더
@riverpod
class ReservationForm extends _$ReservationForm {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createReservation(CreateReservationRequestNew request) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(reservationsRepositoryProvider);
      await repository.createReservation(request);
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
      // 예약 목록 및 통계 새로고침
      ref.invalidate(filteredReservationsProvider);
      ref.invalidate(reservationStatsProvider);
      ref.invalidate(todayReservationsProvider);
      ref.invalidate(upcomingReservationsProvider);
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
      // 예약 목록 및 통계 새로고침
      ref.invalidate(filteredReservationsProvider);
      ref.invalidate(reservationStatsProvider);
      ref.invalidate(todayReservationsProvider);
      ref.invalidate(upcomingReservationsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 선택된 예약 프로바이더
@riverpod
class SelectedReservation extends _$SelectedReservation {
  @override
  Reservation? build() => null;

  void selectReservation(Reservation? reservation) => state = reservation;
  void clearSelection() => state = null;
}

// 검색어 프로바이더
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clearQuery() => state = '';
}

// 검색 결과 프로바이더
@riverpod
Future<PaginatedReservations> searchResults(SearchResultsRef ref) async {
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
}

// 예약 생성 폼 상태 프로바이더들
@riverpod
class ReservationDate extends _$ReservationDate {
  @override
  DateTime? build() => null;

  void setDate(DateTime? date) => state = date;
  void clearDate() => state = null;
}

@riverpod
class StartTime extends _$StartTime {
  @override
  DateTime? build() => null;

  void setTime(DateTime? time) => state = time;
  void clearTime() => state = null;
}

@riverpod
class ReservationDuration extends _$ReservationDuration {
  @override
  int build() => 180; // 기본 3시간

  void setDuration(int minutes) => state = minutes;
}

@riverpod
class SelectedClinic extends _$SelectedClinic {
  @override
  Clinic? build() => null;

  void selectClinic(Clinic? clinic) => state = clinic;
  void clearSelection() => state = null;
}

@riverpod
class SelectedGuide extends _$SelectedGuide {
  @override
  ReservationGuide? build() => null;

  void selectGuide(ReservationGuide? guide) => state = guide;
  void clearSelection() => state = null;
}

@riverpod
class SelectedServiceTypes extends _$SelectedServiceTypes {
  @override
  List<ServiceTypeEnum> build() => [];

  void setServiceTypes(List<ServiceTypeEnum> types) => state = types;
  void addServiceType(ServiceTypeEnum type) => state = [...state, type];
  void removeServiceType(ServiceTypeEnum type) =>
      state = state.where((t) => t != type).toList();
  void clearSelection() => state = [];
}

@riverpod
class ReservationNotes extends _$ReservationNotes {
  @override
  String build() => '';

  void setNotes(String notes) => state = notes;
  void clearNotes() => state = '';
}

// 고객 정보 프로바이더
@riverpod
class Customers extends _$Customers {
  @override
  List<CustomerRequest> build() => [];

  void setCustomers(List<CustomerRequest> customers) => state = customers;
  void addCustomer(CustomerRequest customer) => state = [...state, customer];
  void removeCustomer(int index) => state = [...state]..removeAt(index);
  void updateCustomer(int index, CustomerRequest customer) =>
      state = [...state]..[index] = customer;
  void clearCustomers() => state = [];
}

// 필터 상태 관리 프로바이더들
@riverpod
class StatusFilter extends _$StatusFilter {
  @override
  ReservationStatus? build() => null;

  void setStatus(ReservationStatus? status) => state = status;
  void clearFilter() => state = null;
}

@riverpod
class ClinicFilter extends _$ClinicFilter {
  @override
  Clinic? build() => null;

  void setClinic(Clinic? clinic) => state = clinic;
  void clearFilter() => state = null;
}

@riverpod
class ServiceTypeFilter extends _$ServiceTypeFilter {
  @override
  ServiceTypeEnum? build() => null;

  void setServiceType(ServiceTypeEnum? type) => state = type;
  void clearFilter() => state = null;
}

@riverpod
class DateFromFilter extends _$DateFromFilter {
  @override
  DateTime? build() => null;

  void setDate(DateTime? date) => state = date;
  void clearFilter() => state = null;
}

@riverpod
class DateToFilter extends _$DateToFilter {
  @override
  DateTime? build() => null;

  void setDate(DateTime? date) => state = date;
  void clearFilter() => state = null;
}

// 통합 필터 생성 프로바이더
@riverpod
ReservationFilters activeFilter(ActiveFilterRef ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final status = ref.watch(statusFilterProvider);
  final clinic = ref.watch(clinicFilterProvider);
  final serviceType = ref.watch(serviceTypeFilterProvider);
  final dateFrom = ref.watch(dateFromFilterProvider);
  final dateTo = ref.watch(dateToFilterProvider);

  return ReservationFilters(
    searchQuery: searchQuery.isEmpty ? null : searchQuery,
    status: status,
    clinicId: clinic?.id,
    guideId: null, // serviceType는 guideId가 아니므로 null로 설정
    startDate: dateFrom,
    endDate: dateTo,
  );
}

// 필터링된 예약 목록 프로바이더
@riverpod
Future<PaginatedReservations> filteredReservations(
  FilteredReservationsRef ref,
) async {
  final repository = ref.watch(reservationsRepositoryProvider);
  final page = ref.watch(reservationPageProvider);
  final pageSize = ref.watch(reservationPageSizeProvider);

  return await repository.getReservations(page: page, pageSize: pageSize);
}

// 오늘 예약 알림 프로바이더
@riverpod
Future<List<Reservation>> todayReservations(TodayReservationsRef ref) async {
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
}

// 30분 전 알림 예약 프로바이더
@riverpod
Future<List<Reservation>> upcomingReservations(
  UpcomingReservationsRef ref,
) async {
  final todayReservations = await ref.watch(todayReservationsProvider.future);
  final now = DateTime.now();
  final thirtyMinutesLater = now.add(const Duration(minutes: 30));

  return todayReservations.where((reservation) {
    final startTime = reservation.startTime;
    return startTime.isAfter(now) && startTime.isBefore(thirtyMinutesLater);
  }).toList();
}

// 예약 생성 프로바이더
@riverpod
Future<Reservation> createReservation(
  CreateReservationRef ref,
  CreateReservationRequestNew request,
) async {
  final repository = ref.read(reservationsRepositoryProvider);
  return repository.createReservation(request);
}
