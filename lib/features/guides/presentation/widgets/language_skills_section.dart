import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/guide_form_providers.dart';
import '../../data/language_specialty_models.dart';

class LanguageSkillsSection extends ConsumerStatefulWidget {
  const LanguageSkillsSection({super.key});

  @override
  ConsumerState<LanguageSkillsSection> createState() => _LanguageSkillsSectionState();
}

class _LanguageSkillsSectionState extends ConsumerState<LanguageSkillsSection> {
  String? _selectedLanguageId;
  ProficiencyLevel? _selectedProficiency;
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final availableLanguagesAsync = ref.watch(availableLanguagesProvider);
    final selectedLanguages = ref.watch(selectedLanguagesProvider);
    final languageError = ref.watch(fieldErrorProvider('languages'));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 언어 추가 섹션
          _buildLanguageSelector(availableLanguagesAsync, selectedLanguages),
          
          if (languageError != null) ...[
            const SizedBox(height: 12),
            _buildErrorText(languageError),
          ],
          
          const SizedBox(height: 24),
          
          // 추가된 언어 목록
          if (selectedLanguages.isNotEmpty) ...[
            const Text(
              '선택된 언어',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 12),
            _buildSelectedLanguagesList(selectedLanguages),
          ] else ...[
            _buildEmptyState(),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(AsyncValue<List<Language>> availableLanguagesAsync, List<dynamic> selectedLanguages) {
    return availableLanguagesAsync.when(
      data: (availableLanguages) {
        // 이미 선택된 언어는 제외
        final availableOptions = availableLanguages.where((language) {
          return !selectedLanguages.any((selected) => selected.languageId == language.id);
        }).toList();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '언어 추가',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // 언어 선택 드롭다운
                  Expanded(
                    flex: 2,
                    child: _buildLanguageDropdown(availableOptions),
                  ),
                  const SizedBox(width: 12),
                  
                  // 숙련도 선택 드롭다운
                  Expanded(
                    flex: 2,
                    child: _buildProficiencyDropdown(),
                  ),
                  const SizedBox(width: 12),
                  
                  // 추가 버튼
                  _buildAddButton(availableOptions),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8D7DA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDC3545)),
        ),
        child: Text(
          '언어 목록을 불러오는데 실패했습니다: $error',
          style: const TextStyle(
            color: Color(0xFFDC3545),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(List<Language> availableLanguages) {
    return DropdownButtonFormField<String>(
      value: _selectedLanguageId,
      decoration: InputDecoration(
        hintText: '언어 선택',
        hintStyle: const TextStyle(
          color: Color(0xFF6C757D),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCED4DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCED4DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF495057), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: availableLanguages.map((language) {
        return DropdownMenuItem<String>(
          value: language.id,
          child: Text(
                         language.name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF212529),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguageId = value;
        });
      },
    );
  }

  Widget _buildProficiencyDropdown() {
    return DropdownButtonFormField<ProficiencyLevel>(
      value: _selectedProficiency,
      decoration: InputDecoration(
        hintText: '숙련도 선택',
        hintStyle: const TextStyle(
          color: Color(0xFF6C757D),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCED4DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCED4DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF495057), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: ProficiencyLevel.values.map((level) {
        return DropdownMenuItem<ProficiencyLevel>(
          value: level,
          child: Text(
            level.displayName,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF212529),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedProficiency = value;
        });
      },
    );
  }

  Widget _buildAddButton(List<Language> availableLanguages) {
    final canAdd = _selectedLanguageId != null && _selectedProficiency != null;
    
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        onPressed: canAdd ? _addLanguage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canAdd ? const Color(0xFF495057) : const Color(0xFFE9ECEF),
          foregroundColor: canAdd ? Colors.white : const Color(0xFF6C757D),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16),
            SizedBox(width: 4),
            Text(
              '추가',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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

  Widget _buildSelectedLanguagesList(List<dynamic> selectedLanguages) {
    return Column(
      children: selectedLanguages.map((languageForm) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            children: [
              // 언어 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageForm.language.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getProficiencyColor(languageForm.proficiencyLevel),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        languageForm.proficiencyLevel.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 삭제 버튼
              IconButton(
                onPressed: () => _removeLanguage(languageForm.tempId),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFDC3545),
                  size: 20,
                ),
                tooltip: '언어 삭제',
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.language,
            size: 48,
            color: Color(0xFFCED4DA),
          ),
          SizedBox(height: 12),
          Text(
            '아직 추가된 언어가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6C757D),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '위에서 언어를 선택하고 추가해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProficiencyColor(ProficiencyLevel level) {
    switch (level) {
      case ProficiencyLevel.beginner:
        return const Color(0xFF6C757D);
      case ProficiencyLevel.intermediate:
        return const Color(0xFF0D6EFD);
      case ProficiencyLevel.advanced:
        return const Color(0xFF198754);
      case ProficiencyLevel.native:
        return const Color(0xFF495057);
    }
  }

  void _addLanguage() {
    if (_selectedLanguageId == null || _selectedProficiency == null) return;

    final availableLanguagesAsync = ref.read(availableLanguagesProvider);
    availableLanguagesAsync.whenData((languages) {
      final selectedLanguage = languages.firstWhere(
        (lang) => lang.id == _selectedLanguageId,
      );

      ref.read(guideFormProvider.notifier).addLanguage(
        selectedLanguage,
        _selectedProficiency!,
      );

      // 선택 초기화
      setState(() {
        _selectedLanguageId = null;
        _selectedProficiency = null;
      });
    });
  }

  void _removeLanguage(String tempId) {
    ref.read(guideFormProvider.notifier).removeLanguage(tempId);
  }
} 