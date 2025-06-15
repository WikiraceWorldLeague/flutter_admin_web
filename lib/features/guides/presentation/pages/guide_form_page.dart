import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/guide_form_providers.dart';
import '../widgets/basic_info_section.dart';
import '../widgets/language_skills_section.dart';
import '../widgets/specialties_section.dart';
import '../widgets/profile_section.dart';

class GuideFormPage extends ConsumerStatefulWidget {
  final String? guideId; // null이면 신규 등록, 값이 있으면 수정

  const GuideFormPage({super.key, this.guideId});

  @override
  ConsumerState<GuideFormPage> createState() => _GuideFormPageState();
}

class _GuideFormPageState extends ConsumerState<GuideFormPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 편집 모드인 경우 데이터 로드 (추후 구현)
    if (widget.guideId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadGuideData();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadGuideData() async {
    if (widget.guideId != null) {
      final success = await ref
          .read(guideFormProvider.notifier)
          .loadGuideForEdit(widget.guideId!);
      if (!success && mounted) {
        // 데이터 로드 실패 시 에러 처리
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('가이드 정보를 불러오는데 실패했습니다.')));
        context.go('/guides'); // 목록 페이지로 이동
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isFormLoadingProvider);
    final isValid = ref.watch(isFormValidProvider);
    final hasChanges = ref.watch(hasFormChangesProvider);
    final isEditMode = ref.watch(isEditModeProvider);

    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasChanges) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // 그레이 배경
        appBar: _buildAppBar(isEditMode),
        body: Column(
          children: [
            // 메인 폼 영역
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 페이지 제목
                        _buildPageTitle(isEditMode),
                        const SizedBox(height: 32),

                        // 폼 섹션들
                        _buildFormSections(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 하단 저장 버튼 영역
            _buildBottomActions(isValid, isLoading),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isEditMode) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212529)),
        onPressed: () => _handleBackPress(),
      ),
      title: Text(
        isEditMode ? '가이드 정보 수정' : '새 가이드 등록',
        style: const TextStyle(
          color: Color(0xFF212529),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Color(0xFFE9ECEF)),
      ),
    );
  }

  Widget _buildPageTitle(bool isEditMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? '가이드 정보 수정' : '새 가이드 등록',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? '가이드의 기본 정보, 언어 능력, 전문분야를 수정할 수 있습니다.'
              : '새로운 가이드의 기본 정보, 언어 능력, 전문분야를 입력해주세요.',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6C757D),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSections() {
    return Column(
      children: [
        // 1. 기본 정보 섹션
        _buildSectionCard(
          title: '기본 정보',
          subtitle: '가이드의 기본적인 신상 정보를 입력해주세요.',
          child: const BasicInfoSection(),
        ),
        const SizedBox(height: 24),

        // 2. 언어 능력 섹션
        _buildSectionCard(
          title: '언어 능력',
          subtitle: '가이드가 구사할 수 있는 언어와 숙련도를 선택해주세요.',
          child: const LanguageSkillsSection(),
        ),
        const SizedBox(height: 24),

        // 3. 전문분야 섹션
        _buildSectionCard(
          title: '전문분야',
          subtitle: '가이드가 전문적으로 안내할 수 있는 의료 분야를 선택해주세요.',
          child: const SpecialtiesSection(),
        ),
        const SizedBox(height: 24),

        // 4. 프로필 섹션
        _buildSectionCard(
          title: '프로필 정보',
          subtitle: '가이드의 프로필 이미지와 자기소개를 입력해주세요.',
          child: const ProfileSection(),
        ),
        const SizedBox(height: 100), // 하단 버튼 공간 확보
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 헤더
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 섹션 내용
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(bool isValid, bool isLoading) {
    final isEditMode = ref.watch(isEditModeProvider);
    final currentGuide = ref.watch(currentGuideProvider);
    final currentGuideActiveStatus = ref.watch(
      currentGuideActiveStatusProvider,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9ECEF), width: 1)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 편집 모드일 때만 표시되는 관리 액션들
              if (isEditMode && currentGuide != null) ...[
                Row(
                  children: [
                    // 활성화/비활성화 토글
                    Row(
                      children: [
                        Text(
                          '상태: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF495057),
                          ),
                        ),
                        currentGuideActiveStatus.when(
                          data:
                              (isActive) => Switch(
                                value: isActive,
                                onChanged:
                                    isLoading
                                        ? null
                                        : (value) => _toggleGuideStatus(value),
                                activeColor: Color(0xFF28A745),
                              ),
                          loading:
                              () => Switch(
                                value: true,
                                onChanged: null,
                                activeColor: Color(0xFF28A745),
                              ),
                          error:
                              (_, __) => Switch(
                                value: true,
                                onChanged: null,
                                activeColor: Color(0xFF28A745),
                              ),
                        ),
                        currentGuideActiveStatus.when(
                          data:
                              (isActive) => Text(
                                isActive ? '활성' : '비활성',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isActive
                                          ? Color(0xFF28A745)
                                          : Color(0xFF6C757D),
                                ),
                              ),
                          loading:
                              () => Text(
                                '로딩중...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6C757D),
                                ),
                              ),
                          error:
                              (_, __) => Text(
                                '오류',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFDC3545),
                                ),
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // 완전 삭제 버튼
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _showDeleteConfirmDialog,
                      icon: const Icon(Icons.delete_forever, size: 18),
                      label: const Text('완전 삭제'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFDC3545),
                        side: BorderSide(color: Color(0xFFDC3545)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE9ECEF)),
                const SizedBox(height: 16),
              ],

              // 기본 액션 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 취소 버튼
                  OutlinedButton(
                    onPressed: isLoading ? null : () => _handleBackPress(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      side: const BorderSide(color: Color(0xFF6C757D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 저장 버튼
                  ElevatedButton(
                    onPressed: (isValid && !isLoading) ? _handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF495057),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              '저장',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackPress() {
    final hasChanges = ref.read(hasFormChangesProvider);

    if (hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      context.pop();
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('변경사항이 있습니다'),
            content: const Text('저장하지 않은 변경사항이 있습니다. 정말 나가시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('계속 작성'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(guideFormProvider.notifier).resetForm();
                  context.pop();
                },
                child: const Text('나가기'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleSave() async {
    final success = await ref.read(guideFormProvider.notifier).saveGuide();

    if (success && mounted) {
      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.guideId != null ? '가이드 정보가 수정되었습니다.' : '새 가이드가 등록되었습니다.',
          ),
          backgroundColor: const Color(0xFF28A745),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 폼 초기화 후 이전 페이지로 이동
      ref.read(guideFormProvider.notifier).resetForm();
      context.pop();
    } else if (mounted) {
      // 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('저장 중 오류가 발생했습니다. 다시 시도해주세요.'),
          backgroundColor: Color(0xFFDC3545),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // 가이드 상태 토글
  Future<void> _toggleGuideStatus(bool newStatus) async {
    final success = await ref
        .read(guideFormProvider.notifier)
        .toggleGuideStatus(newStatus);

    if (success && mounted) {
      // 상태 provider 새로고침
      ref.invalidate(currentGuideActiveStatusProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? '가이드가 활성화되었습니다.' : '가이드가 비활성화되었습니다.'),
          backgroundColor: const Color(0xFF28A745),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상태 변경 중 오류가 발생했습니다.'),
          backgroundColor: Color(0xFFDC3545),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // 완전 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              '가이드 완전 삭제',
              style: TextStyle(
                color: Color(0xFFDC3545),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ 경고: 이 작업은 되돌릴 수 없습니다.',
                  style: TextStyle(
                    color: Color(0xFFDC3545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text('가이드와 관련된 모든 데이터가 데이터베이스에서 완전히 삭제됩니다.'),
                SizedBox(height: 8),
                Text(
                  '정말로 삭제하시겠습니까?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteGuide();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC3545),
                  foregroundColor: Colors.white,
                ),
                child: const Text('완전 삭제'),
              ),
            ],
          ),
    );
  }

  // 가이드 완전 삭제
  Future<void> _deleteGuide() async {
    final success = await ref.read(guideFormProvider.notifier).deleteGuide();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('가이드가 완전히 삭제되었습니다.'),
          backgroundColor: Color(0xFF28A745),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 폼 초기화 후 이전 페이지로 이동
      ref.read(guideFormProvider.notifier).resetForm();
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('삭제 중 오류가 발생했습니다.'),
          backgroundColor: Color(0xFFDC3545),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
