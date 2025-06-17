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
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController(text: customer?.name ?? '');
    final phoneController = useTextEditingController(
      text: customer?.phone ?? '',
    );
    final nationalityController = useTextEditingController(
      text: customer?.nationality ?? '',
    );
    final selectedGender = useState<CustomerGender?>(customer?.gender);
    final selectedBirthDate = useState<DateTime?>(customer?.birthDate);
    final isLoading = useState(false);

    return AlertDialog(
      title: Text(isEditing ? '고객 정보 수정' : '새 고객 등록'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '고객명 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '고객명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nationalityController,
                decoration: const InputDecoration(
                  labelText: '국적 (예: KR, US, JP)',
                  border: OutlineInputBorder(),
                ),
                maxLength: 2,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthDate.value ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    helpText: '생년월일 선택',
                  );
                  if (picked != null) {
                    selectedBirthDate.value = picked;
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
                        : '날짜를 선택하세요',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CustomerGender>(
                value: selectedGender.value,
                decoration: const InputDecoration(
                  labelText: '성별',
                  border: OutlineInputBorder(),
                ),
                items:
                    CustomerGender.values.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(_getGenderDisplayName(gender)),
                      );
                    }).toList(),
                onChanged: (value) {
                  selectedGender.value = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed:
              isLoading.value
                  ? null
                  : () => _saveCustomer(
                    context,
                    ref,
                    formKey,
                    isLoading,
                    nameController,
                    phoneController,
                    nationalityController,
                    selectedGender,
                    selectedBirthDate,
                  ),
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
    );
  }

  String _getGenderDisplayName(CustomerGender gender) {
    switch (gender) {
      case CustomerGender.male:
        return '남성';
      case CustomerGender.female:
        return '여성';
      case CustomerGender.other:
        return '기타';
    }
  }

  Future<void> _saveCustomer(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    ValueNotifier<bool> isLoading,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController nationalityController,
    ValueNotifier<CustomerGender?> selectedGender,
    ValueNotifier<DateTime?> selectedBirthDate,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final input = CustomerInput(
        name: nameController.text,
        phone: phoneController.text.isEmpty ? null : phoneController.text,
        nationality:
            nationalityController.text.isEmpty
                ? null
                : nationalityController.text.toUpperCase(),
        gender: selectedGender.value,
        birthDate: selectedBirthDate.value,
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
        onSaved();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? '고객 정보가 수정되었습니다.' : '새 고객이 등록되었습니다.'),
          ),
        );
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
      isLoading.value = false;
    }
  }
}
