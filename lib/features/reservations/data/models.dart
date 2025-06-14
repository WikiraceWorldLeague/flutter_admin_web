import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

// 예약 상태 enum
enum ReservationStatus {
  @JsonValue('pending_assignment')
  pendingAssignment('할당 대기'),
  @JsonValue('assigned')
  assigned('할당 완료'),
  @JsonValue('in_progress')
  inProgress('진행 중'),
  @JsonValue('completed')
  completed('완료'),
  @JsonValue('cancelled')
  cancelled('취소');

  const ReservationStatus(this.displayName);
  final String displayName;
}

// 예약 모델
@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String reservationNumber,
    required DateTime reservationDate,
    required DateTime startTime,
    required int durationMinutes,
    required String clinicId,
    required ReservationStatus status,
    String? guideId,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    
    // Relations
    Clinic? clinic,
    Guide? guide,
    @Default([]) List<Customer> customers,
    @Default([]) List<ServiceType> serviceTypes,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
}

// 고객 모델
@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    required String phoneNumber,
    required String nationality,
    String? email,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

// 병원 모델
@freezed
class Clinic with _$Clinic {
  const factory Clinic({
    required String id,
    required String name,
    required String region,
    String? address,
    String? phoneNumber,
    String? description,
    required DateTime createdAt,
    @Default([]) List<Specialty> specialties,
  }) = _Clinic;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}

// 가이드 모델
@freezed
class Guide with _$Guide {
  const factory Guide({
    required String id,
    required String koreanName,
    required String englishName,
    required String nationality,
    required String gender,
    required int experienceYears,
    String? phoneNumber,
    String? email,
    String? notes,
    required DateTime createdAt,
    @Default([]) List<Language> languages,
    @Default([]) List<Specialty> specialties,
  }) = _Guide;

  factory Guide.fromJson(Map<String, dynamic> json) => _$GuideFromJson(json);
}

// 서비스 타입 모델
@freezed
class ServiceType with _$ServiceType {
  const factory ServiceType({
    required String id,
    required String name,
    String? description,
    required int defaultDurationMinutes,
    required DateTime createdAt,
  }) = _ServiceType;

  factory ServiceType.fromJson(Map<String, dynamic> json) => _$ServiceTypeFromJson(json);
}

// 전문 분야 모델
@freezed
class Specialty with _$Specialty {
  const factory Specialty({
    required String id,
    required String name,
    String? description,
    required DateTime createdAt,
  }) = _Specialty;

  factory Specialty.fromJson(Map<String, dynamic> json) => _$SpecialtyFromJson(json);
}

// 언어 모델
@freezed
class Language with _$Language {
  const factory Language({
    required String id,
    required String name,
    required String code,
    required DateTime createdAt,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}

// 예약 필터 모델
@freezed
class ReservationFilter with _$ReservationFilter {
  const factory ReservationFilter({
    String? searchQuery,
    ReservationStatus? status,
    String? clinicId,
    String? serviceTypeId,
    String? guideId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) = _ReservationFilter;

  factory ReservationFilter.fromJson(Map<String, dynamic> json) => _$ReservationFilterFromJson(json);
}

// 페이지네이션 모델
@freezed
class PaginatedReservations with _$PaginatedReservations {
  const factory PaginatedReservations({
    required List<Reservation> reservations,
    required int totalCount,
    required int page,
    required int pageSize,
    required bool hasNextPage,
  }) = _PaginatedReservations;

  factory PaginatedReservations.fromJson(Map<String, dynamic> json) => _$PaginatedReservationsFromJson(json);
}

// 예약 통계 모델
@freezed
class ReservationStats with _$ReservationStats {
  const factory ReservationStats({
    required int pendingAssignment,
    required int assigned,
    required int inProgress,
    required int completed,
    required int cancelled,
    required int total,
  }) = _ReservationStats;

  factory ReservationStats.fromJson(Map<String, dynamic> json) => _$ReservationStatsFromJson(json);
}

// 예약 생성 요청 모델
@freezed
class CreateReservationRequest with _$CreateReservationRequest {
  const factory CreateReservationRequest({
    required DateTime reservationDate,
    required DateTime startTime,
    required int durationMinutes,
    required String clinicId,
    String? guideId,
    String? notes,
    required List<CustomerRequest> customers,
    required List<String> serviceTypeIds,
  }) = _CreateReservationRequest;

  factory CreateReservationRequest.fromJson(Map<String, dynamic> json) => _$CreateReservationRequestFromJson(json);
}

// 고객 생성 요청 모델
@freezed
class CustomerRequest with _$CustomerRequest {
  const factory CustomerRequest({
    required String name,
    required String phoneNumber,
    required String nationality,
    String? email,
    String? notes,
  }) = _CustomerRequest;

  factory CustomerRequest.fromJson(Map<String, dynamic> json) => _$CustomerRequestFromJson(json);
}

// 가이드 추천 모델
@freezed
class GuideRecommendation with _$GuideRecommendation {
  const factory GuideRecommendation({
    required Guide guide,
    required bool isAvailable,
    required bool hasMatchingLanguage,
    required bool hasMatchingSpecialty,
    required int matchScore,
    String? unavailabilityReason,
  }) = _GuideRecommendation;

  factory GuideRecommendation.fromJson(Map<String, dynamic> json) => _$GuideRecommendationFromJson(json);
} 