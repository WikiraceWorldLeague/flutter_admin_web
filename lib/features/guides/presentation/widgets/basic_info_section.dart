import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/guide_form_providers.dart';
import '../../data/guide_form_models.dart';

class BasicInfoSection extends ConsumerStatefulWidget {
  const BasicInfoSection({super.key});

  @override
  ConsumerState<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends ConsumerState<BasicInfoSection> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passportFirstNameController;
  late final TextEditingController _passportLastNameController;
  late final TextEditingController _nationalityController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passportFirstNameController = TextEditingController();
    _passportLastNameController = TextEditingController();
    _nationalityController = TextEditingController();

    // 초기 상태에서 컨트롤러에 값 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formState = ref.read(guideFormProvider);
      _nicknameController.text = formState.nickname;
      _phoneController.text = formState.phoneNumber;
      _emailController.text = formState.email;
      _passportFirstNameController.text = formState.passportFirstName;
      _passportLastNameController.text = formState.passportLastName;
      _nationalityController.text = formState.nationality;
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passportFirstNameController.dispose();
    _passportLastNameController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(guideFormProvider);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 닉네임 필드
          _buildTextField(
            label: '닉네임',
            controller: _nicknameController,
            hintText: '가이드 닉네임을 입력해주세요',
            errorText: ref.watch(fieldErrorProvider('nickname')),
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updateNickname(value);
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // 성별 필드
          _buildGenderDropdown(formState.gender),
          const SizedBox(height: 20),

          // 생년월일 필드
          _buildBirthDatePicker(formState.birthDate),
          const SizedBox(height: 20),

          // 전화번호 필드
          _buildTextField(
            label: '전화번호',
            controller: _phoneController,
            hintText: '010-0000-0000',
            errorText: ref.watch(fieldErrorProvider('phoneNumber')),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updatePhoneNumber(value);
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // 이메일 필드
          _buildTextField(
            label: '이메일',
            controller: _emailController,
            hintText: 'example@email.com',
            errorText: ref.watch(fieldErrorProvider('email')),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updateEmail(value);
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // 여권 이름 필드
          _buildTextField(
            label: '여권 이름',
            controller: _passportFirstNameController,
            hintText: 'First Name',
            errorText: ref.watch(fieldErrorProvider('passportFirstName')),
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updatePassportFirstName(value);
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // 여권 성 필드
          _buildTextField(
            label: '여권 성',
            controller: _passportLastNameController,
            hintText: 'Last Name',
            errorText: ref.watch(fieldErrorProvider('passportLastName')),
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updatePassportLastName(value);
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // 국적 필드
          _buildTextField(
            label: '국적',
            controller: _nationalityController,
            hintText: '국적을 입력해주세요',
            errorText: ref.watch(fieldErrorProvider('nationality')),
            onChanged: (value) {
              ref.read(guideFormProvider.notifier).updateNationality(value);
            },
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required ValueChanged<String> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212529),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFDC3545),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF495057), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF212529),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: Color(0xFFDC3545),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFDC3545),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildGenderDropdown(String? selectedGender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '성별',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: InputDecoration(
            hintText: '성별을 선택해주세요',
            hintStyle: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF495057), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: Gender.values.map((gender) {
            return DropdownMenuItem<String>(
              value: gender.value,
              child: Text(
                gender.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF212529),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(guideFormProvider.notifier).updateGender(value);
          },
        ),
      ],
    );
  }

  Widget _buildBirthDatePicker(DateTime? selectedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '생년월일',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectBirthDate(selectedDate),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFCED4DA)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일'
                        : '생년월일을 선택해주세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate != null 
                          ? const Color(0xFF212529)
                          : const Color(0xFF6C757D),
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF6C757D),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectBirthDate(DateTime? currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF495057),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF212529),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      ref.read(guideFormProvider.notifier).updateBirthDate(picked);
    }
  }
} 