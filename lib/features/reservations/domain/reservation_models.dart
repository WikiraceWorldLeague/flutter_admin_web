// 언어 모델
class Language {
  final String code;
  final String name;

  const Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(code: json['code'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}

// 전문분야 모델
class Specialty {
  final String id;
  final String name;

  const Specialty({required this.id, required this.name});

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
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
    ReservationStatus.pendingAssignment: 0xFFC0C0C0, // soft gray
    ReservationStatus.assigned: 0xFFB2C7D9, // warm blue gray
    ReservationStatus.inProgress: 0xFFF3D6A4, // soft amber
    ReservationStatus.completed: 0xFFA7C8A1, // sage green
    ReservationStatus.cancelled: 0xFFE5B5B5, // dusty rose
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
  final DateTime? birthDate;
  final String? gender;
  final String? notes;
  final bool isBooker;
  final String? booker;
  final double? age;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.nationality,
    this.birthDate,
    this.gender,
    this.notes,
    this.isBooker = false,
    this.booker,
    this.age,
    required this.createdAt,
  });

  // 나이 계산 (예약일 기준)
  double? calculateAge(DateTime reservationDate) {
    if (birthDate == null) return null;
    final difference = reservationDate.difference(birthDate!);
    return double.parse((difference.inDays / 365.0).toStringAsFixed(2));
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      nationality: json['nationality'] as String? ?? '',
      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'] as String)
              : null,
      gender: json['gender'] as String?,
      notes: json['customer_note'] as String?,
      isBooker: json['is_booker'] as bool? ?? false,
      booker: json['booker'] as String?,
      age: (json['age'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nationality': nationality,
      'birth_date': birthDate?.toIso8601String().split('T')[0],
      'gender': gender,
      'customer_note': notes,
      'is_booker': isBooker,
      'booker': booker,
      'age': age,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? nationality,
    DateTime? birthDate,
    String? gender,
    String? notes,
    bool? isBooker,
    String? booker,
    double? age,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      notes: notes ?? this.notes,
      isBooker: isBooker ?? this.isBooker,
      booker: booker ?? this.booker,
      age: age ?? this.age,
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
      id: json['id'] as String? ?? '',
      name: json['clinic_name'] as String? ?? '',
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
      nickname:
          json['nickname'] as String? ?? json['korean_name'] as String? ?? '',
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

// 서비스 타입 enum (단순화)
enum ServiceTypeEnum {
  translationOnly('translation_only', '단순 통역'),
  fullPackage('full_package', '미용의료 풀패키지'),
  generalGuide('general_guide', '일반 관광 가이드');

  const ServiceTypeEnum(this.code, this.displayName);

  final String code;
  final String displayName;

  static ServiceTypeEnum? fromCode(String? code) {
    if (code == null) return null;
    for (final type in ServiceTypeEnum.values) {
      if (type.code == code) return type;
    }
    return null;
  }

  @override
  String toString() => displayName;
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
  final ServiceTypeEnum? serviceType;
  final ReservationGuide? assignedGuide;
  final double? totalAmount;
  final double? guideCommission;
  final String? notes;
  final String? contactInfo;
  final String? bookerId;
  final int groupSize;
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
    this.serviceType,
    this.assignedGuide,
    this.totalAmount,
    this.guideCommission,
    this.notes,
    this.contactInfo,
    this.bookerId,
    this.groupSize = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // 날짜와 시간 파싱 처리
    final reservationDate = DateTime.parse(json['reservation_date'] as String);
    final startTimeStr = json['start_time'] as String;
    final endTimeStr = json['end_time'] as String?;

    // 시간 문자열을 DateTime으로 변환
    final startTime = DateTime.parse(
      '${reservationDate.toIso8601String().split('T')[0]}T$startTimeStr',
    );
    final endTime =
        endTimeStr != null
            ? DateTime.parse(
              '${reservationDate.toIso8601String().split('T')[0]}T$endTimeStr',
            )
            : startTime.add(const Duration(hours: 3)); // 기본 3시간

    // customers 처리 - 직접 배열이거나 단일 객체일 수 있음
    List<Customer> customersList = [];
    final customersData = json['customers'];
    if (customersData != null) {
      if (customersData is List) {
        customersList =
            customersData
                .map((c) => Customer.fromJson(c as Map<String, dynamic>))
                .toList();
      } else if (customersData is Map<String, dynamic>) {
        customersList = [Customer.fromJson(customersData)];
      }
    }

    // service_type 처리 - 단일 enum 값
    ServiceTypeEnum? serviceType;
    final serviceTypeData = json['service_type'];
    if (serviceTypeData != null) {
      serviceType = ServiceTypeEnum.fromCode(serviceTypeData as String);
    }

    return Reservation(
      id: json['id'] as String,
      reservationNumber: json['reservation_number'] as String,
      reservationDate: reservationDate,
      startTime: startTime,
      endTime: endTime,
      status: ReservationStatus.fromDbValue(
        json['status'] as String? ?? 'pending_assignment',
      ),
      clinic: Clinic.fromJson(json['clinic'] as Map<String, dynamic>),
      customers: customersList,
      serviceType: serviceType,
      assignedGuide:
          json['assigned_guide'] != null
              ? ReservationGuide.fromJson(
                json['assigned_guide'] as Map<String, dynamic>,
              )
              : null,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      guideCommission: (json['commission_amount'] as num?)?.toDouble(),
      notes: json['special_notes'] as String?,
      contactInfo: json['contact_info'] as String?,
      bookerId: json['booker_id'] as String?,
      groupSize: json['group_size'] as int? ?? 1,
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
      'service_type': serviceType?.code,
      'assigned_guide': assignedGuide?.toJson(),
      'total_amount': totalAmount,
      'guide_commission': guideCommission,
      'notes': notes,
      'contact_info': contactInfo,
      'booker_id': bookerId,
      'group_size': groupSize,
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
    ServiceTypeEnum? serviceType,
    ReservationGuide? assignedGuide,
    double? totalAmount,
    double? guideCommission,
    String? notes,
    String? contactInfo,
    String? bookerId,
    int? groupSize,
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
      serviceType: serviceType ?? this.serviceType,
      assignedGuide: assignedGuide ?? this.assignedGuide,
      totalAmount: totalAmount ?? this.totalAmount,
      guideCommission: guideCommission ?? this.guideCommission,
      notes: notes ?? this.notes,
      contactInfo: contactInfo ?? this.contactInfo,
      bookerId: bookerId ?? this.bookerId,
      groupSize: groupSize ?? this.groupSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 편의 메서드들
  String get customerNames => customers.map((c) => c.name).join(', ');
  String get serviceTypeNames => serviceType?.displayName ?? '미지정';
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
      koreanName:
          json['korean_name'] as String? ?? json['nickname'] as String? ?? '',
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

// 고객 데이터 모델 (예약 생성용)
class CustomerData {
  final String name;
  final String nationality;
  final DateTime? birthDate;
  final String? gender;
  final String? notes;
  final bool isBooker;

  const CustomerData({
    required this.name,
    required this.nationality,
    this.birthDate,
    this.gender,
    this.notes,
    this.isBooker = false,
  });

  // 나이 계산 (예약일 기준)
  double? calculateAge(DateTime reservationDate) {
    if (birthDate == null) return null;
    final difference = reservationDate.difference(birthDate!);
    return double.parse((difference.inDays / 365.0).toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nationality': nationality,
      'birth_date': birthDate?.toIso8601String().split('T')[0],
      'gender': gender,
      'notes': notes,
      'is_booker': isBooker,
    };
  }

  CustomerData copyWith({
    String? name,
    String? nationality,
    DateTime? birthDate,
    String? gender,
    String? notes,
    bool? isBooker,
  }) {
    return CustomerData(
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      notes: notes ?? this.notes,
      isBooker: isBooker ?? this.isBooker,
    );
  }
}

// 새로운 예약 생성 요청 모델
class CreateReservationRequestNew {
  final String reservationNumber;
  final DateTime reservationDate;
  final String startTime;
  final String endTime;
  final String clinicId;
  final ServiceTypeEnum? serviceType;
  final String? notes;
  final String? contactInfo;
  final int durationMinutes;
  final List<CustomerData> customers;

  const CreateReservationRequestNew({
    required this.reservationNumber,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.clinicId,
    this.serviceType,
    this.notes,
    this.contactInfo,
    required this.durationMinutes,
    required this.customers,
  });

  // 예약자 찾기
  CustomerData? get booker => customers.firstWhere(
    (customer) => customer.isBooker,
    orElse:
        () =>
            customers.isNotEmpty
                ? customers.first
                : throw StateError('No customers found'),
  );

  // 그룹 크기
  int get groupSize => customers.length;

  Map<String, dynamic> toJson() {
    return {
      'reservation_number': reservationNumber,
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'clinic_id': clinicId,
      'service_type': serviceType?.code,
      'special_notes': notes,
      'contact_info': contactInfo,
      'duration_minutes': durationMinutes,
      'group_size': groupSize,
      'status': 'assigned',
      'total_amount': 0,
      'commission_amount': 0,
      'payment_amount': 0,
      'customers': customers.map((c) => c.toJson()).toList(),
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
