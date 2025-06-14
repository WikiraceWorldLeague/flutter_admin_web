import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../reservations/data/simple_models.dart';
import '../../data/guides_providers.dart';
import '../../data/guides_repository.dart';

class GuidesPage extends ConsumerStatefulWidget {
  const GuidesPage({super.key});

  @override
  ConsumerState<GuidesPage> createState() => _GuidesPageState();
}

class _GuidesPageState extends ConsumerState<GuidesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    ref.read(guideSearchQueryProvider.notifier).state = _searchController.text;
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(guideSearchQueryProvider.notifier).state = '';
    ref.read(guideStatusFilterProvider.notifier).state = null;
    ref.read(guideLanguageFilterProvider.notifier).state = null;
    ref.read(guideSpecialtyFilterProvider.notifier).state = null;
    ref.read(guideGradeFilterProvider.notifier).state = null;
    ref.read(guidePageProvider.notifier).state = 1;
  }

  void _refreshData() {
    ref.invalidate(guidesProvider);
    ref.invalidate(guideStatsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(guidesProvider);
    final statsAsync = ref.watch(guideStatsProvider);
    final viewMode = ref.watch(guideViewModeProvider);
    final currentPage = ref.watch(guidePageProvider);
    final pageSize = ref.watch(guidePageSizeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '가이드 관리',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '가이드 정보를 관리하고 할당 현황을 확인하세요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new guide
              },
              icon: const Icon(Icons.person_add),
              label: const Text('가이드 등록'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Search and Filters
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '가이드명, 전화번호, 이메일 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _updateSearchQuery();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (_) => _updateSearchQuery(),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('필터 초기화'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey100,
                foregroundColor: AppColors.grey700,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              tooltip: '새로고침',
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Statistics Cards
        statsAsync.when(
          data: (stats) => _buildStatsCards(stats),
          loading: () => _buildStatsCardsLoading(),
          error: (error, _) => _buildStatsCardsError(),
        ),
        
        const SizedBox(height: 24),
        
        // Filters and View Toggle
        Row(
          children: [
            // Status Filter
            _buildFilterDropdown(
              label: '상태',
              value: ref.watch(guideStatusFilterProvider),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('활성')),
                DropdownMenuItem(value: 'inactive', child: Text('비활성')),
                DropdownMenuItem(value: 'suspended', child: Text('정지')),
              ],
              onChanged: (value) {
                ref.read(guideStatusFilterProvider.notifier).state = value;
              },
            ),
            const SizedBox(width: 16),
            
            // Language Filter (임시)
            _buildFilterDropdown(
              label: '언어',
              value: ref.watch(guideLanguageFilterProvider),
              items: const [
                DropdownMenuItem(value: 'korean', child: Text('한국어')),
                DropdownMenuItem(value: 'english', child: Text('영어')),
                DropdownMenuItem(value: 'chinese', child: Text('중국어')),
                DropdownMenuItem(value: 'japanese', child: Text('일본어')),
              ],
              onChanged: (value) {
                ref.read(guideLanguageFilterProvider.notifier).state = value;
              },
            ),
            
            const Spacer(),
            
            // View Mode Toggle
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(guideViewModeProvider.notifier).state = GuideViewMode.grid;
                    },
                    icon: const Icon(Icons.grid_view),
                    color: viewMode == GuideViewMode.grid ? AppColors.primary : AppColors.grey600,
                    tooltip: '그리드 뷰',
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(guideViewModeProvider.notifier).state = GuideViewMode.list;
                    },
                    icon: const Icon(Icons.view_list),
                    color: viewMode == GuideViewMode.list ? AppColors.primary : AppColors.grey600,
                    tooltip: '리스트 뷰',
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Guides List/Grid
        Expanded(
          child: guidesAsync.when(
            data: (paginatedGuides) => viewMode == GuideViewMode.grid
                ? _buildGuidesGrid(paginatedGuides)
                : _buildGuidesList(paginatedGuides),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('가이드 목록 로드 실패: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(GuideStats stats) {
    return Row(
      children: [
        Expanded(
          child: _GuideStatsCard(
            title: '전체 가이드',
            count: stats.total,
            color: AppColors.primary,
            icon: Icons.people,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _GuideStatsCard(
            title: '활성 가이드',
            count: stats.active,
            color: AppColors.success,
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _GuideStatsCard(
            title: '신규가입',
            count: stats.newThisMonth,
            color: AppColors.info,
            icon: Icons.person_add,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _GuideStatsCard(
            title: '이번달 예약',
            count: stats.thisMonthReservations,
            color: AppColors.warning,
            icon: Icons.calendar_today,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCardsLoading() {
    return Row(
      children: List.generate(4, (index) => 
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCardsError() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          '통계 로드 실패',
          style: TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 120,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('전체', style: TextStyle(color: AppColors.grey600)),
          ),
          ...items,
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildGuidesGrid(PaginatedGuides paginatedGuides) {
    final guides = paginatedGuides.guides;
    
    if (guides.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return _GuideCard(
                guide: guide,
                onTap: () => _showGuideDetailModal(guide),
              );
            },
          ),
        ),
        if (guides.isNotEmpty) _buildPagination(paginatedGuides),
      ],
    );
  }

  Widget _buildGuidesList(PaginatedGuides paginatedGuides) {
    final guides = paginatedGuides.guides;
    
    if (guides.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            border: Border.all(color: AppColors.grey200),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('닉네임', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('상태', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('언어', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('전문분야', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('평점', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('예약건수', style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('액션', style: TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        
        // Table Body
        Expanded(
          child: ListView.builder(
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return _GuideListItem(
                guide: guide,
                onTap: () => _showGuideDetailModal(guide),
              );
            },
          ),
        ),
        
        if (guides.isNotEmpty) _buildPagination(paginatedGuides),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            '가이드가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 가이드를 등록해보세요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to add guide
            },
            icon: const Icon(Icons.person_add),
            label: const Text('가이드 등록'),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(PaginatedGuides paginatedGuides) {
    final currentPage = ref.watch(guidePageProvider);
    final totalPages = (paginatedGuides.totalCount / paginatedGuides.pageSize).ceil();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '총 ${paginatedGuides.totalCount}개 항목',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: currentPage > 1
                    ? () => ref.read(guidePageProvider.notifier).state = currentPage - 1
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('$currentPage / $totalPages'),
              IconButton(
                onPressed: paginatedGuides.hasNextPage
                    ? () => ref.read(guidePageProvider.notifier).state = currentPage + 1
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGuideDetailModal(Guide guide) {
    showDialog(
      context: context,
      builder: (context) => _GuideDetailModal(guide: guide),
    );
  }
}

// 통계 카드 위젯
class _GuideStatsCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _GuideStatsCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 가이드 카드 위젯
class _GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback onTap;

  const _GuideCard({
    required this.guide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 이미지 영역
              Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    guide.koreanName.isNotEmpty ? guide.koreanName[0] : 'G',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // 닉네임
              Text(
                guide.koreanName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // 언어 (임시)
              Text(
                '언어: 한국어, 영어',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // 전문분야 (임시)
              Text(
                '전문분야: 성형외과',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // 상태
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '활성',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // 평점과 예약건수
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(
                        '4.8',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '총 25건',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey600,
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
}

// 가이드 리스트 아이템 위젯
class _GuideListItem extends StatelessWidget {
  final Guide guide;
  final VoidCallback onTap;

  const _GuideListItem({
    required this.guide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 닉네임
              Expanded(
                flex: 2,
                child: Text(
                  guide.koreanName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              
              // 상태
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '활성',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 언어
              const Expanded(
                flex: 2,
                child: Text('한국어, 영어'),
              ),
              
              // 전문분야
              const Expanded(
                flex: 2,
                child: Text('성형외과'),
              ),
              
              // 평점
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    const Text('4.8'),
                  ],
                ),
              ),
              
              // 예약건수
              const Expanded(
                flex: 1,
                child: Text('25건'),
              ),
              
              // 액션
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: Edit guide
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      tooltip: '편집',
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Toggle status
                      },
                      icon: const Icon(Icons.toggle_on, size: 16),
                      tooltip: '비활성화',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 가이드 상세 모달
class _GuideDetailModal extends StatelessWidget {
  final Guide guide;

  const _GuideDetailModal({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '가이드 상세 정보',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 프로필 정보
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    guide.koreanName.isNotEmpty ? guide.koreanName[0] : 'G',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.koreanName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '국적: ${guide.nationality}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '경력: ${guide.experienceYears}년',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 연락처 정보
            if (guide.phoneNumber != null) ...[
              Text(
                '전화번호: ${guide.phoneNumber}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            if (guide.email != null) ...[
              Text(
                '이메일: ${guide.email}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            
            const SizedBox(height: 24),
            
            // 액션 버튼들
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Edit guide
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('편집'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: View schedule
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('스케줄'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: View reservations
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('예약내역'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 