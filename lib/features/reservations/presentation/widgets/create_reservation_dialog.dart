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

class CreateReservationDialog extends HookConsumerWidget {
  const CreateReservationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 기본 정보 상태
    final selectedDate = useState<DateTime?>(null);
    final startTime = useState<TimeOfDay?>(null);
    final endTime = useState<TimeOfDay?>(null);
    final selectedClinic = useState<Clinic?>(null);
    final customClinicName = useState(''); // 기타 병원명 입력용
    final selectedServiceType = useState<ServiceTypeEnum?>(null);
    final notes = useState('');
    final requiredLanguages = useState('');

    // 고객 정보 상태 (최소 1명, 최대 6명)
    final customers = useState<List<CustomerFormData>>([
      CustomerFormData()..isBooker = true,
    ]);

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
        initialDate: DateTime.now().add(Duration(days: 1)),
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
                ? const TimeOfDay(hour: 9, minute: 0)
                : const TimeOfDay(hour: 12, minute: 0),
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

    String generateReservationNumber() {
      final now = DateTime.now();
      final dateStr = DateFormat('yyMMdd').format(now);
      final timeStr = DateFormat('HHmm').format(now);
      return 'RES-$dateStr-$timeStr';
    }

    Future<void> createReservation() async {
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
        // 예약번호 생성
        final reservationNumber = generateReservationNumber();

        // 시작/종료 시간을 문자열로 변환
        final startTimeStr =
            '${startTime.value!.hour.toString().padLeft(2, '0')}:${startTime.value!.minute.toString().padLeft(2, '0')}:00';
        final endTimeStr =
            '${endTime.value!.hour.toString().padLeft(2, '0')}:${endTime.value!.minute.toString().padLeft(2, '0')}:00';

        // 예약 생성 요청 데이터 준비
        final request = CreateReservationRequestNew(
          reservationNumber: reservationNumber,
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

        // ReservationsRepository를 통해 실제 예약 생성
        final repository = ref.read(reservationsRepositoryProvider);
        final reservation = await repository.createReservation(request);

        isLoading.value = false;
        if (context.mounted) {
          Navigator.of(context).pop(true); // 성공 시 true 반환
          NotificationHelper.showSuccess(
            context,
            '예약이 성공적으로 생성되었습니다. (ID: ${reservation.id})',
          );

          // 예약 목록 자동 새로고침
          ref.invalidate(filteredReservationsProvider);
          ref.invalidate(reservationStatsProvider);
          ref.invalidate(todayReservationsProvider);
          ref.invalidate(upcomingReservationsProvider);
        }
      } catch (e) {
        isLoading.value = false;
        if (context.mounted) {
          showError(context, '예약 생성 중 오류가 발생했습니다: $e');
        }
      }
    }

    final clinicsAsync = ref.watch(clinicsProvider);
    final serviceTypes = ref.watch(serviceTypesProvider);

    return Dialog(
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '새 예약 생성',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 폼 내용
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보 섹션
                      _BasicInfoSection(
                        selectedDate: selectedDate,
                        startTime: startTime,
                        endTime: endTime,
                        selectedClinic: selectedClinic,
                        customClinicName: customClinicName,
                        selectedServiceType: selectedServiceType,
                        notes: notes,
                        requiredLanguages: requiredLanguages,
                        clinicsAsync: clinicsAsync,
                        serviceTypes: serviceTypes,
                        onSelectDate: selectDate,
                        onSelectTime: selectTime,
                      ),

                      const SizedBox(height: 32),

                      // 고객 정보 섹션
                      _CustomersSection(
                        customers: customers,
                        onAddCustomer: addCustomer,
                        onRemoveCustomer: removeCustomer,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 버튼
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: isLoading.value ? null : createReservation,
                  child:
                      isLoading.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('예약 생성'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 기본 정보 섹션 위젯
class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.selectedClinic,
    required this.customClinicName,
    required this.selectedServiceType,
    required this.notes,
    required this.requiredLanguages,
    required this.clinicsAsync,
    required this.serviceTypes,
    required this.onSelectDate,
    required this.onSelectTime,
  });

  final ValueNotifier<DateTime?> selectedDate;
  final ValueNotifier<TimeOfDay?> startTime;
  final ValueNotifier<TimeOfDay?> endTime;
  final ValueNotifier<Clinic?> selectedClinic;
  final ValueNotifier<String> customClinicName;
  final ValueNotifier<ServiceTypeEnum?> selectedServiceType;
  final ValueNotifier<String> notes;
  final ValueNotifier<String> requiredLanguages;
  final AsyncValue<List<Clinic>> clinicsAsync;
  final List<ServiceTypeEnum> serviceTypes;
  final VoidCallback onSelectDate;
  final void Function(bool isStartTime) onSelectTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // 날짜 선택
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onSelectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '예약 날짜',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    selectedDate.value != null
                        ? DateFormat(
                          'yyyy년 MM월 dd일',
                        ).format(selectedDate.value!)
                        : '날짜를 선택하세요',
                    style:
                        selectedDate.value != null
                            ? null
                            : TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 시간 선택
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onSelectTime(true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '시작 시간',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    startTime.value != null
                        ? startTime.value!.format(context)
                        : '시간을 선택하세요',
                    style:
                        startTime.value != null
                            ? null
                            : TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => onSelectTime(false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '종료 시간',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    endTime.value != null
                        ? endTime.value!.format(context)
                        : '시간을 선택하세요',
                    style:
                        endTime.value != null
                            ? null
                            : TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 병원 선택
        clinicsAsync.when(
          data:
              (clinics) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Clinic>(
                    decoration: const InputDecoration(
                      labelText: '병원',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedClinic.value,
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
                      // 기타가 아닌 경우 커스텀 병원명 초기화
                      if (clinic?.name != '기타') {
                        customClinicName.value = '';
                      }
                    },
                    validator: (value) => value == null ? '병원을 선택해주세요' : null,
                  ),
                  // 기타 선택 시 직접 입력 필드 표시
                  if (selectedClinic.value?.name == '기타') ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '병원명 직접 입력',
                        border: OutlineInputBorder(),
                        hintText: '병원명을 입력하세요',
                      ),
                      onChanged: (value) => customClinicName.value = value,
                      validator:
                          (value) =>
                              selectedClinic.value?.name == '기타' &&
                                      (value == null || value.isEmpty)
                                  ? '병원명을 입력해주세요'
                                  : null,
                    ),
                  ],
                ],
              ),
          loading:
              () => DropdownButtonFormField<Clinic>(
                decoration: const InputDecoration(
                  labelText: '병원 (로딩 중...)',
                  border: OutlineInputBorder(),
                ),
                items: const [],
                onChanged: null,
              ),
          error:
              (error, stack) => DropdownButtonFormField<Clinic>(
                decoration: InputDecoration(
                  labelText: '병원',
                  border: const OutlineInputBorder(),
                  errorText: '병원 목록을 불러올 수 없습니다: $error',
                ),
                items: const [],
                onChanged: null,
              ),
        ),
        const SizedBox(height: 16),

        // 서비스 타입 선택
        DropdownButtonFormField<ServiceTypeEnum>(
          decoration: const InputDecoration(
            labelText: '서비스 타입',
            border: OutlineInputBorder(),
          ),
          value: selectedServiceType.value,
          items:
              serviceTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    ),
                  )
                  .toList(),
          onChanged: (type) => selectedServiceType.value = type,
        ),
        const SizedBox(height: 16),

        // 메모
        TextFormField(
          decoration: const InputDecoration(
            labelText: '메모',
            border: OutlineInputBorder(),
            hintText: '추가 정보나 특별 요청사항을 입력하세요',
          ),
          maxLines: 3,
          onChanged: (value) => notes.value = value,
        ),
        const SizedBox(height: 16),

        // 연락처 정보
        TextFormField(
          decoration: const InputDecoration(
            labelText: '연락처 정보',
            border: OutlineInputBorder(),
            hintText: '연락처나 언어 요구사항을 입력하세요',
          ),
          onChanged: (value) => requiredLanguages.value = value,
        ),
      ],
    );
  }
}

// 고객 정보 섹션 위젯
class _CustomersSection extends StatelessWidget {
  const _CustomersSection({
    required this.customers,
    required this.onAddCustomer,
    required this.onRemoveCustomer,
  });

  final ValueNotifier<List<CustomerFormData>> customers;
  final VoidCallback onAddCustomer;
  final void Function(int index) onRemoveCustomer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '고객 정보',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (customers.value.length < 6)
              ElevatedButton.icon(
                onPressed: onAddCustomer,
                icon: const Icon(Icons.add),
                label: const Text('고객 추가'),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // 고객 목록
        ...customers.value.asMap().entries.map((entry) {
          final index = entry.key;
          final customer = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _CustomerFormCard(
              customer: customer,
              index: index,
              canRemove: customers.value.length > 1,
              onRemove: () => onRemoveCustomer(index),
              onBookerChanged: (isBooker) {
                if (isBooker) {
                  // 다른 모든 고객의 예약자 상태를 false로 설정
                  final updatedCustomers =
                      customers.value.map((c) {
                        if (c == customer) {
                          return c..isBooker = true;
                        } else {
                          return c..isBooker = false;
                        }
                      }).toList();
                  customers.value = [...updatedCustomers];
                } else {
                  customer.isBooker = false;
                  customers.value = [...customers.value];
                }
              },
              onCustomerDataChanged: () {
                // 고객 데이터가 변경되었을 때 상태 업데이트
                customers.value = [...customers.value];
              },
            ),
          );
        }),
      ],
    );
  }
}

// 고객 폼 카드 위젯
class _CustomerFormCard extends StatelessWidget {
  const _CustomerFormCard({
    required this.customer,
    required this.index,
    required this.canRemove,
    required this.onRemove,
    required this.onBookerChanged,
    required this.onCustomerDataChanged,
  });

  final CustomerFormData customer;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final void Function(bool isBooker) onBookerChanged;
  final VoidCallback onCustomerDataChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '고객 ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    // 예약자 체크박스
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: customer.isBooker,
                          onChanged: (value) => onBookerChanged(value ?? false),
                        ),
                        const Text('예약자'),
                      ],
                    ),
                    const SizedBox(width: 8),
                    if (canRemove)
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: '고객 삭제',
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 폼 필드들
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '이름',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => customer.name = value,
                    validator:
                        (value) => value?.isEmpty ?? true ? '이름을 입력해주세요' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '국적',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => customer.nationality = value,
                    validator:
                        (value) => value?.isEmpty ?? true ? '국적을 입력해주세요' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: customer.birthDate ?? DateTime(1990),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        customer.birthDate = date;
                        // 상태 업데이트를 위해 부모에게 알림
                        onCustomerDataChanged();
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '생년월일',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        customer.birthDate != null
                            ? DateFormat(
                              'yyyy-MM-dd',
                            ).format(customer.birthDate!)
                            : '생년월일을 선택하세요',
                        style:
                            customer.birthDate != null
                                ? null
                                : TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Gender>(
                    decoration: const InputDecoration(
                      labelText: '성별',
                      border: OutlineInputBorder(),
                    ),
                    value: customer.gender,
                    items:
                        Gender.values
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender.displayName),
                              ),
                            )
                            .toList(),
                    onChanged: (gender) => customer.gender = gender,
                    validator: (value) => value == null ? '성별을 선택해주세요' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 메모
            TextFormField(
              decoration: const InputDecoration(
                labelText: '메모',
                border: OutlineInputBorder(),
                hintText: '특별 요청사항이나 주의사항을 입력하세요',
              ),
              maxLines: 2,
              onChanged: (value) => customer.notes = value,
            ),
          ],
        ),
      ),
    );
  }
}

// 고객 폼 데이터 클래스
class CustomerFormData {
  String name = '';
  String nationality = '';
  DateTime? birthDate;
  Gender? gender;
  String notes = '';
  bool isBooker = false;
}
