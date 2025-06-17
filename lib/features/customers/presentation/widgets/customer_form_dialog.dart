import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/data/providers/customers_providers.dart';

/// 고객 등록/수정 다이얼로그
class CustomerFormDialog extends HookConsumerWidget {
  const CustomerFormDialog({super.key, this.customer, required this.onSaved});

  final Customer? customer;
  final VoidCallback onSaved;

  bool get isEditing => customer != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form key
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Loading state
    final isLoading = useState<bool>(false);

    // Form controllers
    final nameController = useTextEditingController(text: customer?.name ?? '');
    final nationalityController = useTextEditingController(
      text: customer?.nationality ?? '',
    );
    final passportLastNameController = useTextEditingController(text: '');
    final passportFirstNameController = useTextEditingController(text: '');
    final customerNoteController = useTextEditingController(text: '');
    final acquisitionChannelController = useTextEditingController(text: '');
    final channelAccountController = useTextEditingController(
      text: customer?.channelAccount ?? '',
    );

    // Form state
    final selectedGender = useState<CustomerGender?>(customer?.gender);
    final selectedBirthDate = useState<DateTime?>(customer?.birthDate);
    final selectedIsBooker = useState<bool>(customer?.isBooker ?? true);
    final selectedBookerCustomer = useState<Customer?>(null);
    final selectedCommunicationChannel = useState<CommunicationChannel?>(
      customer?.communicationChannel,
    );

    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? '고객 정보 수정' : '새 고객 등록',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보 섹션
                      _buildSectionTitle('기본 정보'),
                      const SizedBox(height: 16),

                      // 고객명
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: '고객명 *',
                          hintText: '고객의 이름을 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '고객명을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 국적
                      TextFormField(
                        controller: nationalityController,
                        decoration: const InputDecoration(
                          labelText: '국적',
                          hintText: '예: KR, US, JP',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 성별 및 생년월일
                      Row(
                        children: [
                          // 성별
                          Expanded(
                            child: DropdownButtonFormField<CustomerGender>(
                              value: selectedGender.value,
                              decoration: const InputDecoration(
                                labelText: '성별',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  CustomerGender.values.map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender.displayName),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) => selectedGender.value = value,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 생년월일
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedBirthDate.value ?? DateTime(1990),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  selectedBirthDate.value = date;
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '생년월일',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  selectedBirthDate.value != null
                                      ? '${selectedBirthDate.value!.year}-${selectedBirthDate.value!.month.toString().padLeft(2, '0')}-${selectedBirthDate.value!.day.toString().padLeft(2, '0')}'
                                      : '날짜 선택',
                                  style:
                                      selectedBirthDate.value != null
                                          ? null
                                          : TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 여권 정보 섹션
                      _buildSectionTitle('여권 정보'),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: passportLastNameController,
                              decoration: const InputDecoration(
                                labelText: '여권 성 (Last Name)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: passportFirstNameController,
                              decoration: const InputDecoration(
                                labelText: '여권 이름 (First Name)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 예약자/동반자 구분 섹션
                      _buildSectionTitle('고객 구분'),
                      const SizedBox(height: 16),

                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(
                            value: true,
                            label: Text('예약자'),
                            icon: Icon(Icons.person),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: Text('동반자'),
                            icon: Icon(Icons.group),
                          ),
                        ],
                        selected: {selectedIsBooker.value},
                        onSelectionChanged: (selection) {
                          selectedIsBooker.value = selection.first;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 예약자 선택 시 - 유입 경로
                      if (selectedIsBooker.value) ...[
                        TextFormField(
                          controller: acquisitionChannelController,
                          decoration: const InputDecoration(
                            labelText: '유입 경로',
                            hintText: '예: 네이버, 구글, 지인 추천 등',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 동반자 선택 시 - 예약자 선택
                      if (!selectedIsBooker.value) ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '예약자 ID',
                            hintText: '예약자의 ID를 입력하세요',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // 임시로 텍스트로 처리
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 소통 채널 섹션
                      _buildSectionTitle('소통 정보'),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField<CommunicationChannel>(
                                  value: selectedCommunicationChannel.value,
                                  decoration: const InputDecoration(
                                    labelText: '소통 채널',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      CommunicationChannel.values.map((
                                        channel,
                                      ) {
                                        return DropdownMenuItem(
                                          value: channel,
                                          child: Text(channel.displayName),
                                        );
                                      }).toList(),
                                  onChanged:
                                      (value) =>
                                          selectedCommunicationChannel.value =
                                              value,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: channelAccountController,
                              decoration: const InputDecoration(
                                labelText: '채널 계정',
                                hintText: '예: ID, 전화번호, 이메일 등',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 고객 메모
                      TextFormField(
                        controller: customerNoteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: '고객 메모',
                          hintText: '고객에 대한 추가 정보나 특이사항을 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        isLoading.value
                            ? null
                            : () => Navigator.of(context).pop(),
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed:
                        isLoading.value
                            ? null
                            : () async {
                              if (isLoading.value) return;

                              await _saveCustomer(
                                context,
                                ref,
                                formKey,
                                isLoading,
                                nameController,
                                nationalityController,
                                passportLastNameController,
                                passportFirstNameController,
                                customerNoteController,
                                acquisitionChannelController,
                                channelAccountController,
                                selectedGender,
                                selectedBirthDate,
                                selectedIsBooker,
                                selectedBookerCustomer,
                                selectedCommunicationChannel,
                              );
                            },
                    child:
                        isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(isEditing ? '수정' : '등록'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _saveCustomer(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    ValueNotifier<bool> isLoading,
    TextEditingController nameController,
    TextEditingController nationalityController,
    TextEditingController passportLastNameController,
    TextEditingController passportFirstNameController,
    TextEditingController customerNoteController,
    TextEditingController acquisitionChannelController,
    TextEditingController channelAccountController,
    ValueNotifier<CustomerGender?> selectedGender,
    ValueNotifier<DateTime?> selectedBirthDate,
    ValueNotifier<bool> selectedIsBooker,
    ValueNotifier<Customer?> selectedBookerCustomer,
    ValueNotifier<CommunicationChannel?> selectedCommunicationChannel,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final input = CustomerInput(
        name: nameController.text.trim(),
        nationality:
            nationalityController.text.trim().isEmpty
                ? null
                : nationalityController.text.trim().toUpperCase(),
        gender: selectedGender.value,
        birthDate: selectedBirthDate.value,
        // 임시로 기존 필드 사용
        passportName:
            passportLastNameController.text.trim().isEmpty &&
                    passportFirstNameController.text.trim().isEmpty
                ? null
                : '${passportLastNameController.text.trim()}, ${passportFirstNameController.text.trim()}',
        isBooker: selectedIsBooker.value,
        acquisitionChannel:
            selectedIsBooker.value &&
                    acquisitionChannelController.text.trim().isNotEmpty
                ? acquisitionChannelController.text.trim()
                : null,
        booker:
            !selectedIsBooker.value ? selectedBookerCustomer.value?.id : null,
        communicationChannel: selectedCommunicationChannel.value,
        channelAccount:
            channelAccountController.text.trim().isEmpty
                ? null
                : channelAccountController.text.trim(),
        customerNote:
            customerNoteController.text.trim().isEmpty
                ? null
                : customerNoteController.text.trim(),
      );

      if (isEditing) {
        await ref
            .read(customerUpdaterProvider.notifier)
            .updateCustomer(customer!.id!, input);
      } else {
        await ref.read(customerCreatorProvider.notifier).createCustomer(input);
      }

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? '고객 정보가 수정되었습니다' : '새 고객이 등록되었습니다'),
            backgroundColor: Colors.green,
          ),
        );

        // 콜백 실행을 지연시켜 상태 충돌 방지
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onSaved();
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }
}

/// 예약자 선택 위젯
class _BookerSelector extends HookConsumerWidget {
  const _BookerSelector({
    required this.selectedBooker,
    required this.onBookerSelected,
  });

  final String? selectedBooker;
  final ValueChanged<String?> onBookerSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');

    // 검색어가 변경될 때마다 업데이트
    useEffect(() {
      void listener() {
        searchQuery.value = searchController.text;
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // 임시로 빈 리스트 반환
    final customersAsync = AsyncValue.data(<Customer>[]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 검색 필드
        TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: '예약자 검색',
            hintText: '예약자 이름을 검색하세요',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 8),

        // 검색 결과 리스트
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: customersAsync.when(
            data: (customers) {
              // 예약자만 필터링하고 검색어로 필터링
              final bookers =
                  customers
                      .where((c) => c.isBooker)
                      .where(
                        (c) =>
                            searchQuery.value.isEmpty ||
                            c.name.toLowerCase().contains(
                              searchQuery.value.toLowerCase(),
                            ),
                      )
                      .toList();

              if (bookers.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다'));
              }

              return ListView.builder(
                itemCount: bookers.length,
                itemBuilder: (context, index) {
                  final booker = bookers[index];
                  final isSelected = selectedBooker == booker.id;

                  return ListTile(
                    title: Text(booker.name),
                    subtitle: Text(
                      '${booker.nationality ?? ''} • ${booker.gender?.displayName ?? ''}',
                    ),
                    trailing:
                        isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                    selected: isSelected,
                    onTap: () => onBookerSelected(booker.id),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('오류: $error')),
          ),
        ),
      ],
    );
  }
}
