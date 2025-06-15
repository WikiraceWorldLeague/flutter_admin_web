import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/reservation_models.dart';

class ReservationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 새로운 예약을 생성합니다
  Future<String> createReservation(CreateReservationRequestNew request) async {
    try {
      // 1. 예약 데이터 생성
      final reservationData = {
        'reservation_number': request.reservationNumber,
        'reservation_date':
            request.reservationDate.toIso8601String().split('T')[0],
        'start_time': request.startTime,
        'end_time': request.endTime,
        'clinic_id': request.clinicId,
        'service_type': request.serviceType?.code, // 단순화된 enum 값
        'special_notes': request.notes,
        'contact_info': request.contactInfo,
        'duration_minutes': request.durationMinutes,
        'status': 'assigned',
        'settlement_status': 'pending',
        'total_amount': 0,
        'commission_rate': 4.5,
        'commission_amount': 0,
        'payment_amount': 0,
      };

      final reservationResponse =
          await _supabase
              .from('reservations')
              .insert(reservationData)
              .select('id')
              .single();

      final reservationId = reservationResponse['id'] as String;

      // 2. 고객 데이터 생성
      for (final customer in request.customers) {
        final customerData = {
          'reservation_id': reservationId,
          'name': customer.name,
          'nationality': customer.nationality,
          'birth_date': customer.birthDate?.toIso8601String().split('T')[0],
          'gender': customer.gender,
          'customer_note': customer.notes,
        };

        await _supabase.from('customers').insert(customerData);
      }

      print('Reservation created successfully: $reservationId');
      return reservationId;
    } catch (e) {
      print('Error creating reservation: $e');
      rethrow;
    }
  }

  /// 활성화된 클리닉 목록을 가져옵니다
  Future<List<Clinic>> getClinics() async {
    try {
      final response = await _supabase
          .from('clinics')
          .select('id, clinic_name, address, phone')
          .eq('is_active', true)
          .order('clinic_name');

      return response
          .map<Clinic>(
            (data) => Clinic.fromJson({
              'id': data['id'],
              'clinic_name': data['clinic_name'],
              'address': data['address'],
              'phone': data['phone'],
            }),
          )
          .toList();
    } catch (e) {
      print('Error fetching clinics: $e');
      rethrow;
    }
  }

  /// 서비스 타입 enum 목록을 반환합니다 (더 이상 데이터베이스에서 조회하지 않음)
  List<ServiceTypeEnum> getServiceTypes() {
    return ServiceTypeEnum.values;
  }
}
