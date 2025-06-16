import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/reservation_models.dart';
import '../../data/providers.dart';
import '../../../../shared/widgets/common/error_display_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../guides/data/guide_form_models.dart';

class EditReservationDialog extends HookConsumerWidget {
  final Reservation reservation;

  const EditReservationDialog({super.key, required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 기존 데이터로 초기화
    final selectedDate = useState<DateTime?>(reservation.reservationDate);
    final startTime = useState<TimeOfDay?>(
      TimeOfDay.fromDateTime(reservation.startTime),
    );
    final endTime = useState<TimeOfDay?>(
      TimeOfDay.fromDateTime(reservation.endTime),
    );
    final selectedClinic = useState<Clinic?>(null); // 클리닉 데이터 로드 후 설정
    final customClinicName = useState('');
    final selectedServiceType = useState<ServiceTypeEnum?>(
      reservation.serviceType,
    );
    final notes = useState(reservation.notes ?? '');
    final requiredLanguages = useState(reservation.contactInfo ?? '');

    // 기존 고객 정보로 초기화
    final customers = useState<List<CustomerFormData>>(
      reservation.customers
              ?.map(
                (customer) => CustomerFormData(
                  name: customer.name,
                  nationality: customer.nationality ?? '',
                  birthDate: customer.birthDate,
                  gender:
                      customer.gender != null
                          ? GenderEnum.values.firstWhere(
                            (g) => g.value == customer.gender,
                          )
                          : null,
                  notes: customer.notes ?? '',
                  isBooker: customer.isBooker,
                ),
              )
              .toList() ??
          [CustomerFormData()..isBooker = true],
    );

    final isLoading = useState(false);

    void showError(BuildContext context, String message) {
      if (context.mounted) {
        NotificationHelper.showError(context, message);
      }
    }

    void addCustomer() {
      if (customers.value.length < 6) {
        customers.value = [...customers.value, CustomerFormData()];
      }
    }

    void removeCustomer(int index) {
      if (customers.value.length > 1) {
        final newCustomers = [...customers.value];
        newCustomers.removeAt(index);
        customers.value = newCustomers;
      }
    }

    Future<void> selectDate() async {
      final date = await showDatePicker(
        context: context,
        initialDate:
            selectedDate.value ?? DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      );

      if (date != null) {
        selectedDate.value = date;
      }
    }

    Future<void> selectTime(bool isStartTime) async {
      final time = await showTimePicker(
        context: context,
        initialTime:
            isStartTime
                ? (startTime.value ?? const TimeOfDay(hour: 9, minute: 0))
                : (endTime.value ?? const TimeOfDay(hour: 12, minute: 0)),
      );

      if (time != null) {
        if (isStartTime) {
          startTime.value = time;
          // 자동으로 종료 시간 설정 (기본 3시간)
          const duration = 180;
          final endMinutes = time.hour * 60 + time.minute + duration;
          endTime.value = TimeOfDay(
            hour: (endMinutes ~/ 60) % 24,
            minute: endMinutes % 60,
          );
        } else {
          endTime.value = time;
        }
      }
    }

    Future<void> updateReservation() async {
      if (!formKey.currentState!.validate()) return;
      if (selectedDate.value == null ||
          startTime.value == null ||
          endTime.value == null) {
        showError(context, '날짜와 시간을 모두 선택해주세요');
        return;
      }
      if (selectedClinic.value == null) {
        showError(context, '병원을 선택해주세요');
        return;
      }

      // '기타' 병원 선택 시 직접 입력된 병원명 확인
      if (selectedClinic.value!.name == '기타' &&
          customClinicName.value.isEmpty) {
        showError(context, '기타 병원명을 입력해주세요');
        return;
      }

      // 예약자가 선택되었는지 확인
      final hasBooker = customers.value.any((customer) => customer.isBooker);
      if (!hasBooker) {
        showError(context, '예약자를 선택해주세요');
        return;
      }

      isLoading.value = true;

      try {
        // 시작/종료 시간을 문자열로 변환
        final startTimeStr =
            '${startTime.value!.hour.toString().padLeft(2, '0')}:${startTime.value!.minute.toString().padLeft(2, '0')}:00';
        final endTimeStr =
            '${endTime.value!.hour.toString().padLeft(2, '0')}:${endTime.value!.minute.toString().padLeft(2, '0')}:00';

        // 예약 수정 요청 데이터 준비
        final request = UpdateReservationRequest(
          id: reservation.id,
          reservationDate: selectedDate.value!,
          startTime: startTimeStr,
          endTime: endTimeStr,
          clinicId: selectedClinic.value!.id,
          serviceType: selectedServiceType.value,
          notes:
              selectedClinic.value!.name == '기타'
                  ? '병원명: ${customClinicName.value}${notes.value.isNotEmpty ? '\n\n${notes.value}' : ''}'
                  : (notes.value.isNotEmpty ? notes.value : null),
          contactInfo:
              requiredLanguages.value.isNotEmpty
                  ? requiredLanguages.value
                  : null,
          durationMinutes: 180,
          customers:
              customers.value
                  .where((customer) => customer.name.isNotEmpty)
                  .map(
                    (customer) => CustomerData(
                      name: customer.name,
                      nationality: customer.nationality,
                      birthDate: customer.birthDate,
                      gender: customer.gender?.value,
                      notes: customer.notes.isNotEmpty ? customer.notes : null,
                      isBooker: customer.isBooker,
                    ),
                  )
                  .toList(),
        );

        // ReservationsRepository를 통해 실제 예약 수정
        final repository = ref.read(reservationsRepositoryProvider);
        await repository.updateReservation(request);

        isLoading.value = false;
        if (context.mounted) {
          Navigator.of(context).pop(true); // 성공 시 true 반환
          NotificationHelper.showSuccess(context, '예약이 성공적으로 수정되었습니다.');

          // 예약 목록 자동 새로고침
          ref.invalidate(filteredReservationsProvider);
          ref.invalidate(reservationStatsProvider);
          ref.invalidate(todayReservationsProvider);
          ref.invalidate(upcomingReservationsProvider);
        }
      } catch (e) {
        isLoading.value = false;
        if (context.mounted) {
          showError(context, '예약 수정 중 오류가 발생했습니다: $e');
        }
      }
    }

    final clinicsAsync = ref.watch(clinicsProvider);
    final serviceTypes = ref.watch(serviceTypesProvider);

    // 클리닉 데이터 로드 후 기존 클리닉 설정
    useEffect(() {
      clinicsAsync.whenData((clinics) {
        final clinic = clinics.firstWhere(
          (c) => c.id == reservation.clinicId,
          orElse: () => clinics.first,
        );
        selectedClinic.value = clinic;
      });
      return null;
    }, [clinicsAsync]);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '예약 수정',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '예약번호: ${reservation.reservationNumber}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // 내용 (CreateReservationDialog와 동일한 폼 구조)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보 섹션
                      _buildSectionTitle('기본 정보'),
                      const SizedBox(height: 16),

                      // 날짜 및 시간 선택
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(selectedDate, selectDate),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimeField(
                              '시작 시간',
                              startTime,
                              () => selectTime(true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimeField(
                              '종료 시간',
                              endTime,
                              () => selectTime(false),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 병원 및 서비스 타입
                      Row(
                        children: [
                          Expanded(
                            child: _buildClinicDropdown(
                              clinicsAsync,
                              selectedClinic,
                              customClinicName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildServiceTypeDropdown(
                              serviceTypes,
                              selectedServiceType,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 고객 정보 섹션
                      _buildCustomersSection(
                        customers,
                        addCustomer,
                        removeCustomer,
                      ),

                      const SizedBox(height: 24),

                      // 추가 정보 섹션
                      _buildAdditionalInfoSection(notes, requiredLanguages),
                    ],
                  ),
                ),
              ),
            ),

            // 버튼 영역
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          isLoading.value
                              ? null
                              : () => Navigator.of(context).pop(),
                      child: const Text('취소'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading.value ? null : updateReservation,
                      child:
                          isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text('수정 완료'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 헬퍼 메서드들 (CreateReservationDialog에서 복사)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.grey800,
      ),
    );
  }

  Widget _buildDateField(
    ValueNotifier<DateTime?> selectedDate,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            Text(
              selectedDate.value != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
                  : '날짜 선택',
              style: TextStyle(
                color:
                    selectedDate.value != null
                        ? Colors.black
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    ValueNotifier<TimeOfDay?> time,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 20),
            const SizedBox(width: 8),
            Text(
              time.value != null
                  ? time.value!.format(context as BuildContext)
                  : label,
              style: TextStyle(
                color: time.value != null ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicDropdown(
    AsyncValue<List<Clinic>> clinicsAsync,
    ValueNotifier<Clinic?> selectedClinic,
    ValueNotifier<String> customClinicName,
  ) {
    return clinicsAsync.when(
      data:
          (clinics) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<Clinic>(
                value: selectedClinic.value,
                decoration: const InputDecoration(
                  labelText: '병원 선택',
                  border: OutlineInputBorder(),
                ),
                items:
                    clinics
                        .map(
                          (clinic) => DropdownMenuItem(
                            value: clinic,
                            child: Text(clinic.name),
                          ),
                        )
                        .toList(),
                onChanged: (clinic) {
                  selectedClinic.value = clinic;
                },
                validator: (value) => value == null ? '병원을 선택해주세요' : null,
              ),
              if (selectedClinic.value?.name == '기타') ...[
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '병원명 직접 입력',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => customClinicName.value = value,
                  validator:
                      (value) =>
                          selectedClinic.value?.name == '기타' &&
                                  (value?.isEmpty ?? true)
                              ? '병원명을 입력해주세요'
                              : null,
                ),
              ],
            ],
          ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('오류: $error'),
    );
  }

  Widget _buildServiceTypeDropdown(
    List<ServiceTypeEnum> serviceTypes,
    ValueNotifier<ServiceTypeEnum?> selectedServiceType,
  ) {
    return DropdownButtonFormField<ServiceTypeEnum>(
      value: selectedServiceType.value,
      decoration: const InputDecoration(
        labelText: '서비스 타입',
        border: OutlineInputBorder(),
      ),
      items:
          serviceTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                ),
              )
              .toList(),
      onChanged: (type) {
        selectedServiceType.value = type;
      },
    );
  }

  Widget _buildCustomersSection(
    ValueNotifier<List<CustomerFormData>> customers,
    VoidCallback addCustomer,
    Function(int) removeCustomer,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSectionTitle('고객 정보'),
            const Spacer(),
            if (customers.value.length < 6)
              TextButton.icon(
                onPressed: addCustomer,
                icon: const Icon(Icons.add),
                label: const Text('고객 추가'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...customers.value.asMap().entries.map((entry) {
          final index = entry.key;
          final customer = entry.value;
          return _buildCustomerForm(
            customer,
            index,
            customers.value.length > 1,
            () => removeCustomer(index),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCustomerForm(
    CustomerFormData customer,
    int index,
    bool canRemove,
    VoidCallback onRemove,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '고객 ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Checkbox(
                value: customer.isBooker,
                onChanged: (value) {
                  customer.isBooker = value ?? false;
                },
              ),
              const Text('예약자'),
              if (canRemove) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.red,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: customer.name,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => customer.name = value,
                  validator:
                      (value) => value?.isEmpty ?? true ? '이름을 입력해주세요' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: customer.nationality,
                  decoration: const InputDecoration(
                    labelText: '국적',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => customer.nationality = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context as BuildContext,
                      initialDate: customer.birthDate ?? DateTime(1990),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      customer.birthDate = date;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          customer.birthDate != null
                              ? DateFormat(
                                'yyyy-MM-dd',
                              ).format(customer.birthDate!)
                              : '생년월일',
                          style: TextStyle(
                            color:
                                customer.birthDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<GenderEnum>(
                  value: customer.gender,
                  decoration: const InputDecoration(
                    labelText: '성별',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      GenderEnum.values
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender.displayName),
                            ),
                          )
                          .toList(),
                  onChanged: (gender) {
                    customer.gender = gender;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: customer.notes,
            decoration: const InputDecoration(
              labelText: '메모',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (value) => customer.notes = value,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection(
    ValueNotifier<String> notes,
    ValueNotifier<String> requiredLanguages,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('추가 정보'),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: notes.value,
          decoration: const InputDecoration(
            labelText: '특별 요청사항',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => notes.value = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: requiredLanguages.value,
          decoration: const InputDecoration(
            labelText: '필요 언어 / 연락처',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => requiredLanguages.value = value,
        ),
      ],
    );
  }
}
