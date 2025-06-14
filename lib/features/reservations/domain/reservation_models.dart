// 언어 모델
class Language {
  final String code;
  final String name;

  const Language({
    required this.code,
    required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}

// 전문분야 모델
class Specialty {
  final String id;
  final String name;

  const Specialty({
    required this.id,
    required this.name,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// 예약 상태 enum
enum ReservationStatus {
  pendingAssignment('배정 대기'),
  assigned('배정됨'),
  inProgress('진행중'),
  completed('완료'),
  cancelled('취소');

  const ReservationStatus(this.displayName);
  final String displayName;

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

  static ReservationStatus fromDbValue(String dbValue) {
    switch (dbValue) {
      case 'pending_assignment':
      case 'pending': // 호환성
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

// 예약 상태별 색상 정의 (beige 테마와 조화)
class ReservationStatusColors {
  static const Map<ReservationStatus, int> colors = {
    ReservationStatus.pendingAssignment: 0xFFC0C0C0,     // soft gray
    ReservationStatus.assigned: 0xFFB2C7D9,    // warm blue gray
    ReservationStatus.inProgress: 0xFFF3D6A4,  // soft amber
    ReservationStatus.completed: 0xFFA7C8A1,   // sage green
    ReservationStatus.cancelled: 0xFFE5B5B5,   // dusty rose
  };

  static int getColor(ReservationStatus status) {
    return colors[status] ?? 0xFFC0C0C0;
  }
}

// 고객 정보 모델
class Customer {
  final String id;
  final String name;
  final String nationality;
  final String? phoneNumber;
  final String? email;
  final String? notes;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.nationality,
    this.phoneNumber,
    this.email,
    this.notes,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      nationality: json['nationality'] as String? ?? '',
      phoneNumber: json['phone'] as String?,
      email: json['email'] as String?,
      notes: json['customer_note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nationality': nationality,
      'phone_number': phoneNumber,
      'email': email,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? nationality,
    String? phoneNumber,
    String? email,
    String? notes,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// 클리닉 정보 모델 (간단화)
class Clinic {
  final String id;
  final String name;
  final String? address;
  final String? region;
  final String? phone;

  const Clinic({
    required this.id,
    required this.name,
    this.address,
    this.region,
    this.phone,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as String,
      name: json['clinic_name'] as String,
      address: json['address'] as String?,
      region: json['region'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic_name': name,
      'address': address,
      'region': region,
      'phone': phone,
    };
  }

  @override
  String toString() => name;
}

// 가이드 정보 모델 (간단화)
class ReservationGuide {
  final String id;
  final String nickname;
  final String? phoneNumber;
  final String? email;

  const ReservationGuide({
    required this.id,
    required this.nickname,
    this.phoneNumber,
    this.email,
  });

  // koreanName getter 추가 (호환성)
  String get koreanName => nickname;
  
  // languages getter 추가 (호환성)
  List<Language> get languages => [];
  
  // specialties getter 추가 (호환성)
  List<Specialty> get specialties => [];

  factory ReservationGuide.fromJson(Map<String, dynamic> json) {
    return ReservationGuide(
      id: json['id'] as String,
      nickname: json['nickname'] as String? ?? json['korean_name'] as String? ?? '',
      phoneNumber: json['phone'] as String? ?? json['phone_number'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'phone': phoneNumber,
      'email': email,
    };
  }

  @override
  String toString() => nickname;
}

// 서비스 타입 모델
class ServiceType {
  final String id;
  final String name;
  final String? description;
  final int defaultDurationMinutes;

  const ServiceType({
    required this.id,
    required this.name,
    this.description,
    required this.defaultDurationMinutes,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      defaultDurationMinutes: json['default_duration_minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'default_duration_minutes': defaultDurationMinutes,
    };
  }

  @override
  String toString() => name;
}

// 예약 모델
class Reservation {
  final String id;
  final String reservationNumber;
  final DateTime reservationDate;
  final DateTime startTime;
  final DateTime endTime;
  final ReservationStatus status;
  final Clinic clinic;
  final List<Customer> customers;
  final List<ServiceType> serviceTypes;
  final ReservationGuide? assignedGuide;
  final double? totalAmount;
  final double? guideCommission;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reservation({
    required this.id,
    required this.reservationNumber,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.clinic,
    required this.customers,
    required this.serviceTypes,
    this.assignedGuide,
    this.totalAmount,
    this.guideCommission,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // 날짜와 시간 파싱 처리
    final reservationDate = DateTime.parse(json['reservation_date'] as String);
    final startTimeStr = json['start_time'] as String;
    final endTimeStr = json['end_time'] as String?;
    
    // 시간 문자열을 DateTime으로 변환
    final startTime = DateTime.parse('${reservationDate.toIso8601String().split('T')[0]}T$startTimeStr');
    final endTime = endTimeStr != null 
        ? DateTime.parse('${reservationDate.toIso8601String().split('T')[0]}T$endTimeStr')
        : startTime.add(const Duration(hours: 3)); // 기본 3시간

    // customers 처리 - 직접 배열이거나 단일 객체일 수 있음
    List<Customer> customersList = [];
    final customersData = json['customers'];
    if (customersData != null) {
      if (customersData is List) {
        customersList = customersData
            .map((c) => Customer.fromJson(c as Map<String, dynamic>))
            .toList();
      } else if (customersData is Map<String, dynamic>) {
        customersList = [Customer.fromJson(customersData)];
      }
    }

    // service_types 처리 - reservation_services를 통해 접근
    List<ServiceType> serviceTypesList = [];
    final serviceTypesData = json['service_types'];
    if (serviceTypesData != null && serviceTypesData is List) {
      for (final serviceData in serviceTypesData) {
        if (serviceData is Map<String, dynamic> && serviceData['service_type'] != null) {
          serviceTypesList.add(ServiceType.fromJson(serviceData['service_type'] as Map<String, dynamic>));
        }
      }
    }

    return Reservation(
      id: json['id'] as String,
      reservationNumber: json['reservation_number'] as String,
      reservationDate: reservationDate,
      startTime: startTime,
      endTime: endTime,
      status: ReservationStatus.fromDbValue(json['status'] as String? ?? 'pending_assignment'),
      clinic: Clinic.fromJson(json['clinic'] as Map<String, dynamic>),
      customers: customersList,
      serviceTypes: serviceTypesList,
      assignedGuide: json['assigned_guide'] != null
          ? ReservationGuide.fromJson(json['assigned_guide'] as Map<String, dynamic>)
          : null,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      guideCommission: (json['commission_amount'] as num?)?.toDouble(),
      notes: json['special_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservation_number': reservationNumber,
      'reservation_date': reservationDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status.dbValue,
      'clinic': clinic.toJson(),
      'customers': customers.map((c) => c.toJson()).toList(),
      'service_types': serviceTypes.map((s) => s.toJson()).toList(),
      'assigned_guide': assignedGuide?.toJson(),
      'total_amount': totalAmount,
      'guide_commission': guideCommission,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Reservation copyWith({
    String? id,
    String? reservationNumber,
    DateTime? reservationDate,
    DateTime? startTime,
    DateTime? endTime,
    ReservationStatus? status,
    Clinic? clinic,
    List<Customer>? customers,
    List<ServiceType>? serviceTypes,
    ReservationGuide? assignedGuide,
    double? totalAmount,
    double? guideCommission,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      reservationNumber: reservationNumber ?? this.reservationNumber,
      reservationDate: reservationDate ?? this.reservationDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      clinic: clinic ?? this.clinic,
      customers: customers ?? this.customers,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      assignedGuide: assignedGuide ?? this.assignedGuide,
      totalAmount: totalAmount ?? this.totalAmount,
      guideCommission: guideCommission ?? this.guideCommission,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 편의 메서드들
  String get customerNames => customers.map((c) => c.name).join(', ');
  String get serviceTypeNames => serviceTypes.map((s) => s.name).join(', ');
  int get customerCount => customers.length;
  Duration get duration => endTime.difference(startTime);
  
  bool get isPending => status == ReservationStatus.pendingAssignment;
  bool get isAssigned => status == ReservationStatus.assigned;
  bool get isInProgress => status == ReservationStatus.inProgress;
  bool get isCompleted => status == ReservationStatus.completed;
  bool get isCancelled => status == ReservationStatus.cancelled;
}

// 페이지네이션된 예약 목록
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

  factory PaginatedReservations.empty() {
    return const PaginatedReservations(
      reservations: [],
      totalCount: 0,
      page: 1,
      pageSize: 20,
      hasNextPage: false,
    );
  }
}

// 예약 필터 모델
class ReservationFilters {
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final ReservationStatus? status;
  final String? clinicId;
  final String? guideId;

  const ReservationFilters({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.status,
    this.clinicId,
    this.guideId,
  });

  // 필터가 비어있는지 확인
  bool get isEmpty {
    return searchQuery == null &&
        startDate == null &&
        endDate == null &&
        status == null &&
        clinicId == null &&
        guideId == null;
  }

  // 필터가 비어있지 않은지 확인
  bool get isNotEmpty => !isEmpty;

  Map<String, dynamic> toJson() {
    final params = <String, dynamic>{};
    if (searchQuery != null) {
      params['search'] = searchQuery;
    }
    if (startDate != null) {
      params['start_date'] = startDate!.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      params['end_date'] = endDate!.toIso8601String().split('T')[0];
    }
    if (status != null) {
      params['status'] = status!.dbValue;
    }
    if (clinicId != null) {
      params['clinic_id'] = clinicId;
    }
    if (guideId != null) {
      params['guide_id'] = guideId;
    }
    return params;
  }
}

// ReservationFilter 별칭 (호환성)
typedef ReservationFilter = ReservationFilters;

// 고객 요청 모델
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'nationality': nationality,
      'email': email,
      'notes': notes,
    };
  }
}

// 가이드 모델 (간단한 버전)
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
      koreanName: json['korean_name'] as String? ?? json['nickname'] as String? ?? '',
      englishName: json['english_name'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      gender: json['gender'] as String? ?? 'other',
      experienceYears: json['experience_years'] as int? ?? 0,
      phoneNumber: json['phone_number'] as String? ?? json['phone'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      languages: [], // 관계 데이터는 별도 처리
      specialties: [], // 관계 데이터는 별도 처리
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'korean_name': koreanName,
      'english_name': englishName,
      'nationality': nationality,
      'gender': gender,
      'experience_years': experienceYears,
      'phone_number': phoneNumber,
      'email': email,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// 예약 생성 요청 모델
class CreateReservationRequest {
  final DateTime reservationDate;
  final DateTime startTime;
  final int durationMinutes;
  final String clinicId;
  final String customerId;
  final List<String> serviceTypeIds;
  final String? notes;

  const CreateReservationRequest({
    required this.reservationDate,
    required this.startTime,
    required this.durationMinutes,
    required this.clinicId,
    required this.customerId,
    required this.serviceTypeIds,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'start_time': startTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'clinic_id': clinicId,
      'customer_id': customerId,
      'service_type_ids': serviceTypeIds,
      'notes': notes,
    };
  }
}

// 예약 통계 모델
class ReservationStats {
  final int totalReservations;
  final int pendingReservations;
  final int assignedReservations;
  final int inProgressReservations;
  final int completedReservations;
  final int cancelledReservations;

  const ReservationStats({
    required this.totalReservations,
    required this.pendingReservations,
    required this.assignedReservations,
    required this.inProgressReservations,
    required this.completedReservations,
    required this.cancelledReservations,
  });

  factory ReservationStats.fromJson(Map<String, dynamic> json) {
    return ReservationStats(
      totalReservations: json['total'] ?? 0,
      pendingReservations: json['pending'] ?? 0,
      assignedReservations: json['assigned'] ?? 0,
      inProgressReservations: json['in_progress'] ?? 0,
      completedReservations: json['completed'] ?? 0,
      cancelledReservations: json['cancelled'] ?? 0,
    );
  }
}

// 가이드 추천 모델
class GuideRecommendation {
  final ReservationGuide guide;
  final double matchScore;
  final List<String> matchReasons;
  final bool isAvailable;

  const GuideRecommendation({
    required this.guide,
    required this.matchScore,
    required this.matchReasons,
    required this.isAvailable,
  });

  factory GuideRecommendation.fromJson(Map<String, dynamic> json) {
    return GuideRecommendation(
      guide: ReservationGuide.fromJson(json['guide']),
      matchScore: (json['match_score'] as num).toDouble(),
      matchReasons: List<String>.from(json['match_reasons'] ?? []),
      isAvailable: json['is_available'] ?? false,
    );
  }
} 