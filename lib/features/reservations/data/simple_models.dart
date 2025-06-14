// 예약 상태 enum
enum ReservationStatus {
  pendingAssignment('할당 대기'),
  assigned('할당 완료'),
  inProgress('진행 중'),
  completed('완료'),
  cancelled('취소');

  const ReservationStatus(this.displayName);
  final String displayName;
  
  // 데이터베이스 상태값과 매핑
  String get dbValue {
    switch (this) {
      case ReservationStatus.pendingAssignment:
        return 'pending_assignment';
      case ReservationStatus.assigned:
        return 'assigned';
      case ReservationStatus.inProgress:
        return 'in_progress';
      case ReservationStatus.completed:
        return 'completed';
      case ReservationStatus.cancelled:
        return 'cancelled';
    }
  }
  
  // 데이터베이스 값으로부터 enum 생성
  static ReservationStatus fromDbValue(String dbValue) {
    switch (dbValue) {
      case 'pending_assignment':
        return ReservationStatus.pendingAssignment;
      case 'assigned':
        return ReservationStatus.assigned;
      case 'in_progress':
        return ReservationStatus.inProgress;
      case 'completed':
        return ReservationStatus.completed;
      case 'cancelled':
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.pendingAssignment;
    }
  }
}

// 예약 모델
class Reservation {
  final String id;
  final String reservationNumber;
  final DateTime reservationDate;
  final DateTime startTime;
  final int durationMinutes;
  final String clinicId;
  final ReservationStatus status;
  final String? guideId;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Relations
  final Clinic? clinic;
  final Guide? guide;
  final List<Customer> customers;
  final List<ServiceType> serviceTypes;

  const Reservation({
    required this.id,
    required this.reservationNumber,
    required this.reservationDate,
    required this.startTime,
    required this.durationMinutes,
    required this.clinicId,
    required this.status,
    this.guideId,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.clinic,
    this.guide,
    this.customers = const [],
    this.serviceTypes = const [],
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      reservationNumber: json['reservation_number'] as String,
      reservationDate: DateTime.parse(json['reservation_date'] as String),
      startTime: DateTime.parse(json['start_time'] as String),
      durationMinutes: json['duration_minutes'] as int? ?? 180,
      clinicId: json['clinic_id'] as String,
      status: ReservationStatus.fromDbValue(json['status'] as String),
      guideId: json['guide_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null,
      guide: json['guide'] != null ? Guide.fromJson(json['guide']) : null,
      customers: json['customer'] != null 
        ? [Customer.fromJson(json['customer'])] // 단일 고객을 리스트로 변환
        : [],
      serviceTypes: json['reservation_service_types'] != null 
        ? (json['reservation_service_types'] as List)
            .map((rst) => ServiceType.fromJson(rst['service_type']))
            .toList()
        : [],
    );
  }
}

// 고객 모델
class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final String nationality;
  final String? email;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.nationality,
    this.email,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      nationality: json['nationality'] as String,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

// 병원 모델
class Clinic {
  final String id;
  final String name;
  final String region;
  final String? address;
  final String? phoneNumber;
  final String? description;
  final DateTime createdAt;
  final List<Specialty> specialties;

  const Clinic({
    required this.id,
    required this.name,
    required this.region,
    this.address,
    this.phoneNumber,
    this.description,
    required this.createdAt,
    this.specialties = const [],
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as String,
      name: json['name'] as String,
      region: json['region'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      specialties: json['specialties'] != null 
        ? (json['specialties'] as List).map((s) => Specialty.fromJson(s)).toList()
        : [],
    );
  }
}

// 가이드 모델
class Guide {
  final String id;
  final String koreanName;
  final String englishName;
  final String nationality;
  final String gender;
  final int experienceYears;
  final String? phoneNumber;
  final String? email;
  final String? notes;
  final DateTime createdAt;
  final List<Language> languages;
  final List<Specialty> specialties;

  const Guide({
    required this.id,
    required this.koreanName,
    required this.englishName,
    required this.nationality,
    required this.gender,
    required this.experienceYears,
    this.phoneNumber,
    this.email,
    this.notes,
    required this.createdAt,
    this.languages = const [],
    this.specialties = const [],
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] as String,
      koreanName: json['korean_name'] as String,
      englishName: json['english_name'] as String,
      nationality: json['nationality'] as String,
      gender: json['gender'] as String,
      experienceYears: json['experience_years'] as int,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      languages: json['languages'] != null 
        ? (json['languages'] as List).map((l) => Language.fromJson(l)).toList()
        : [],
      specialties: json['specialties'] != null 
        ? (json['specialties'] as List).map((s) => Specialty.fromJson(s)).toList()
        : [],
    );
  }
}

// 서비스 타입 모델
class ServiceType {
  final String id;
  final String name;
  final String? description;
  final int defaultDurationMinutes;
  final DateTime createdAt;

  const ServiceType({
    required this.id,
    required this.name,
    this.description,
    required this.defaultDurationMinutes,
    required this.createdAt,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      defaultDurationMinutes: json['default_duration_minutes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// 전문 분야 모델
class Specialty {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const Specialty({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// 언어 모델
class Language {
  final String id;
  final String name;
  final String code;
  final DateTime createdAt;

  const Language({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// 예약 필터 모델
class ReservationFilter {
  final String? searchQuery;
  final ReservationStatus? status;
  final String? clinicId;
  final String? serviceTypeId;
  final String? guideId;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const ReservationFilter({
    this.searchQuery,
    this.status,
    this.clinicId,
    this.serviceTypeId,
    this.guideId,
    this.dateFrom,
    this.dateTo,
  });
}

// 페이지네이션 모델
class PaginatedReservations {
  final List<Reservation> reservations;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  const PaginatedReservations({
    required this.reservations,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });
}

// 예약 통계 모델
class ReservationStats {
  final int pendingAssignment;
  final int assigned;
  final int inProgress;
  final int completed;
  final int cancelled;
  final int total;

  const ReservationStats({
    required this.pendingAssignment,
    required this.assigned,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
    required this.total,
  });
}

// 예약 생성 요청 모델
class CreateReservationRequest {
  final DateTime reservationDate;
  final DateTime startTime;
  final int durationMinutes;
  final String clinicId;
  final String? guideId;
  final String? notes;
  final List<CustomerRequest> customers;
  final List<String> serviceTypeIds;

  const CreateReservationRequest({
    required this.reservationDate,
    required this.startTime,
    required this.durationMinutes,
    required this.clinicId,
    this.guideId,
    this.notes,
    required this.customers,
    required this.serviceTypeIds,
  });
}

// 고객 생성 요청 모델
class CustomerRequest {
  final String name;
  final String phoneNumber;
  final String nationality;
  final String? email;
  final String? notes;

  const CustomerRequest({
    required this.name,
    required this.phoneNumber,
    required this.nationality,
    this.email,
    this.notes,
  });
}

// 가이드 추천 모델
class GuideRecommendation {
  final Guide guide;
  final bool isAvailable;
  final bool hasMatchingLanguage;
  final bool hasMatchingSpecialty;
  final int matchScore;
  final String? unavailabilityReason;

  const GuideRecommendation({
    required this.guide,
    required this.isAvailable,
    required this.hasMatchingLanguage,
    required this.hasMatchingSpecialty,
    required this.matchScore,
    this.unavailabilityReason,
  });
} 