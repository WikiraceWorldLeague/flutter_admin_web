import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/guide_form_providers.dart';
import '../../data/language_specialty_models.dart';

class SpecialtiesSection extends ConsumerWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableSpecialtiesAsync = ref.watch(availableSpecialtiesProvider);
    final selectedSpecialtyIds = ref.watch(selectedSpecialtyIdsProvider);
    final specialtyError = ref.watch(fieldErrorProvider('specialties'));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 설명
          const Text(
            '전문분야 *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '가이드가 전문적으로 안내할 수 있는 의료 분야를 선택해주세요.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6C757D),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // 전문분야 목록
          availableSpecialtiesAsync.when(
            data: (specialties) => _buildSpecialtyChips(
              context,
              ref,
              specialties,
              selectedSpecialtyIds,
            ),
            loading: () => _buildLoadingState(),
            error: (error, stackTrace) => _buildErrorState(error),
          ),

          // 오류 메시지 표시
          if (specialtyError != null) ...[
            const SizedBox(height: 12),
            _buildErrorText(specialtyError),
          ],

          const SizedBox(height: 20),

          // 선택된 전문분야 개수 표시
          _buildSelectionSummary(selectedSpecialtyIds.length),
        ],
      ),
    );
  }

  Widget _buildSpecialtyChips(
    BuildContext context,
    WidgetRef ref,
    List<Specialty> specialties,
    List<String> selectedIds,
  ) {
    // 카테고리별로 그룹화
    final specialtiesByCategory = <String, List<Specialty>>{};
    for (final specialty in specialties) {
      if (!specialtiesByCategory.containsKey(specialty.category)) {
        specialtiesByCategory[specialty.category] = [];
      }
      specialtiesByCategory[specialty.category]!.add(specialty);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specialtiesByCategory.entries.map((entry) {
        final category = entry.key;
        final categorySpecialties = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 제목
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
              ),
            ),

            // 해당 카테고리의 전문분야 Chip들
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categorySpecialties.map((specialty) {
                final isSelected = selectedIds.contains(specialty.id);
                
                return _buildSpecialtyChip(
                  specialty: specialty,
                  isSelected: isSelected,
                  onTap: () => _toggleSpecialty(ref, specialty.id),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSpecialtyChip({
    required Specialty specialty,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF495057)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF495057)
                : const Color(0xFFCED4DA),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF495057).withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              specialty.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? Colors.white
                    : const Color(0xFF495057),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: const Column(
        children: [
          CircularProgressIndicator(
            color: Color(0xFF495057),
          ),
          SizedBox(height: 16),
          Text(
            '전문분야 목록을 불러오는 중...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8D7DA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDC3545)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Color(0xFFDC3545),
          ),
          const SizedBox(height: 12),
          const Text(
            '전문분야 목록을 불러오는데 실패했습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDC3545),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFDC3545),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String errorText) {
    return Row(
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
    );
  }

  Widget _buildSelectionSummary(int selectedCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedCount > 0 
            ? const Color(0xFFD1ECF1)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selectedCount > 0 
              ? const Color(0xFF0C5460)
              : const Color(0xFFE9ECEF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            selectedCount > 0 ? Icons.check_circle : Icons.info_outline,
            size: 20,
            color: selectedCount > 0 
                ? const Color(0xFF0C5460)
                : const Color(0xFF6C757D),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedCount > 0
                  ? '$selectedCount개의 전문분야가 선택되었습니다'
                  : '최소 1개 이상의 전문분야를 선택해주세요',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selectedCount > 0 
                    ? const Color(0xFF0C5460)
                    : const Color(0xFF6C757D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSpecialty(WidgetRef ref, String specialtyId) {
    ref.read(guideFormProvider.notifier).toggleSpecialty(specialtyId);
  }
} 