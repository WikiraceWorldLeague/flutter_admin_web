import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/reservation_models.dart';
import '../../data/providers.dart';

class ReservationsPage extends ConsumerStatefulWidget {
  const ReservationsPage({super.key});

  @override
  ConsumerState<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends ConsumerState<ReservationsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    ref.read(searchQueryProvider.notifier).state = _searchController.text;
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(statusFilterProvider.notifier).state = null;
    ref.read(clinicFilterProvider.notifier).state = null;
    ref.read(serviceTypeFilterProvider.notifier).state = null;
    ref.read(dateFromFilterProvider.notifier).state = null;
    ref.read(dateToFilterProvider.notifier).state = null;
    ref.read(reservationPageProvider.notifier).state = 1;
  }

  void _refreshData() {
    ref.invalidate(filteredReservationsProvider);
    ref.invalidate(reservationStatsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(filteredReservationsProvider);
    final statsAsync = ref.watch(reservationStatsProvider);
    final currentPage = ref.watch(reservationPageProvider);
    final pageSize = ref.watch(reservationPageSizeProvider);
    final selectedStatus = ref.watch(statusFilterProvider);
    final selectedClinic = ref.watch(clinicFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Add Button
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '예약 관리',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '고객 예약을 관리하고 가이드를 할당하세요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: _refreshData,
                  icon: const Icon(Icons.refresh),
                  tooltip: '새로고침',
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showCreateReservationDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('새 예약'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Search and Filters Row
        Row(
          children: [
            // 검색 필드
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _updateSearchQuery(),
                decoration: InputDecoration(
                  hintText: '예약번호, 고객명, 국적 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _updateSearchQuery();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // 상태 필터
            Consumer(
              builder: (context, ref, child) {
                return DropdownButton<ReservationStatus?>(
                  value: selectedStatus,
                  onChanged: (value) {
                    ref.read(statusFilterProvider.notifier).state = value;
                    ref.read(reservationPageProvider.notifier).state = 1;
                  },
                  hint: const Text('상태'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('전체'),
                    ),
                    ...ReservationStatus.values.map((status) => 
                      DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      )
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(width: 16),
            
            // 병원 필터 (임시 비활성화)
            Container(
              width: 100,
              child: const Text(
                '병원: 전체',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 필터 초기화 버튼
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('필터 초기화'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // 통계 카드
        statsAsync.when(
          data: (stats) => _buildStatsCards(stats),
          loading: () => _buildStatsLoadingCards(),
          error: (error, _) => _buildStatsErrorCard(error.toString()),
        ),
        
        const SizedBox(height: 24),
        
        // 예약 테이블
        Expanded(
          child: reservationsAsync.when(
            data: (paginatedReservations) => _buildReservationsTable(paginatedReservations),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildErrorWidget(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(ReservationStats stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: '배정 대기',
            count: stats.pendingReservations,
            color: const Color(0xFFC0C0C0),
            icon: Icons.schedule,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: '배정 완료',
            count: stats.assignedReservations,
            color: const Color(0xFFB2C7D9),
            icon: Icons.assignment_turned_in,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: '진행 중',
            count: stats.inProgressReservations,
            color: const Color(0xFFF3D6A4),
            icon: Icons.play_arrow,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: '완료',
            count: stats.completedReservations,
            color: const Color(0xFFA7C8A1),
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsLoadingCards() {
    return Row(
      children: List.generate(4, (index) => 
        Expanded(
          child: Container(
            margin: index < 3 ? const EdgeInsets.only(right: 16) : null,
            child: _buildStatCard(
              title: '로딩 중...',
              count: 0,
              color: AppColors.grey300,
              icon: Icons.hourglass_empty,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '통계 로드 실패: $error',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(reservationStatsProvider),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
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

  Widget _buildReservationsTable(PaginatedReservations paginatedReservations) {
    final reservations = paginatedReservations.reservations;
    
    if (reservations.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('예약번호', style: _headerTextStyle())),
                Expanded(flex: 3, child: Text('고객 정보', style: _headerTextStyle())),
                Expanded(flex: 2, child: Text('가이드', style: _headerTextStyle())),
                Expanded(flex: 2, child: Text('예약 일시', style: _headerTextStyle())),
                Expanded(flex: 2, child: Text('상태', style: _headerTextStyle())),
                const SizedBox(width: 100, child: Text('작업', textAlign: TextAlign.center)),
              ],
            ),
          ),
          
          // 테이블 데이터
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return _buildReservationRow(reservation, index);
              },
            ),
          ),
          
          // 페이지네이션
          _buildPagination(paginatedReservations),
        ],
      ),
    );
  }

  Widget _buildReservationRow(Reservation reservation, int index) {
    final isEven = index % 2 == 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : AppColors.grey50,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 예약번호
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.reservationNumber,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  reservation.clinic?.name ?? '알 수 없음',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          
          // 고객 정보
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.customers.map((c) => c.name).join(', '),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${reservation.customers.length}명 · ${reservation.customers.map((c) => c.nationality).toSet().join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          
          // 가이드
          Expanded(
            flex: 2,
            child: reservation.assignedGuide != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.assignedGuide!.koreanName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        reservation.assignedGuide!.languages.map((l) => l.name).join(', '),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () => _showGuideAssignmentDialog(reservation),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text('가이드 할당'),
                  ),
          ),
          
          // 예약 일시
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MM/dd').format(reservation.reservationDate),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('HH:mm').format(reservation.startTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          
          // 상태
          Expanded(
            flex: 2,
            child: _buildStatusChip(reservation.status),
          ),
          
          // 작업 버튼
          SizedBox(
            width: 100,
            child: PopupMenuButton<String>(
              onSelected: (action) => _handleMenuAction(action, reservation),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility),
                      SizedBox(width: 8),
                      Text('상세보기'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('수정'),
                    ],
                  ),
                ),
                if (reservation.status != ReservationStatus.cancelled)
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 8),
                        Text('취소', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ReservationStatus status) {
    Color color;
    String text = status.displayName;
    
    switch (status) {
      case ReservationStatus.pendingAssignment:
        color = const Color(0xFFC0C0C0);
        break;
      case ReservationStatus.assigned:
        color = const Color(0xFFB2C7D9);
        break;
      case ReservationStatus.inProgress:
        color = const Color(0xFFF3D6A4);
        break;
      case ReservationStatus.completed:
        color = const Color(0xFFA7C8A1);
        break;
      case ReservationStatus.cancelled:
        color = const Color(0xFFE5B5B5);
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPagination(PaginatedReservations paginatedReservations) {
    final currentPage = ref.watch(reservationPageProvider);
    final pageSize = ref.watch(reservationPageSizeProvider);
    final totalPages = (paginatedReservations.totalCount / pageSize).ceil();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Text(
            '총 ${paginatedReservations.totalCount}개 항목',
            style: TextStyle(color: AppColors.grey600),
          ),
          
          const Spacer(),
          
          // 페이지 크기 선택
          DropdownButton<int>(
            value: pageSize,
            onChanged: (value) {
              if (value != null) {
                ref.read(reservationPageSizeProvider.notifier).state = value;
                ref.read(reservationPageProvider.notifier).state = 1;
              }
            },
            items: [10, 20, 50, 100].map((size) => 
              DropdownMenuItem(
                value: size,
                child: Text('$size개씩'),
              )
            ).toList(),
          ),
          
          const SizedBox(width: 16),
          
          // 페이지 네비게이션
          Row(
            children: [
              IconButton(
                onPressed: currentPage > 1 
                    ? () => ref.read(reservationPageProvider.notifier).state = currentPage - 1
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              
              Text('$currentPage / $totalPages'),
              
              IconButton(
                onPressed: paginatedReservations.hasNextPage
                    ? () => ref.read(reservationPageProvider.notifier).state = currentPage + 1
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '예약이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 예약을 생성해보세요.',
            style: TextStyle(color: AppColors.grey500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateReservationDialog(),
            icon: const Icon(Icons.add),
            label: const Text('새 예약 생성'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            '데이터 로드 실패',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
  }

  void _showCreateReservationDialog() {
    // TODO: 예약 생성 다이얼로그 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('예약 생성 기능은 개발 중입니다.')),
    );
  }

  void _showGuideAssignmentDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => _GuideAssignmentDialog(reservation: reservation),
    );
  }

  void _handleMenuAction(String action, Reservation reservation) {
    switch (action) {
      case 'view':
        // TODO: 상세보기 구현
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reservation.reservationNumber} 상세보기')),
        );
        break;
      case 'edit':
        // TODO: 수정 구현
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reservation.reservationNumber} 수정')),
        );
        break;
      case 'cancel':
        _showCancelConfirmation(reservation);
        break;
    }
  }

  void _showCancelConfirmation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: Text('${reservation.reservationNumber}을(를) 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelReservation(reservation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _cancelReservation(Reservation reservation) {
    ref.read(reservationFormProvider.notifier).updateStatus(
      reservation.id,
      ReservationStatus.cancelled,
    );
    
    // 성공/실패 처리는 reservationFormProvider를 watch하여 처리할 수 있음
    ref.listen(reservationFormProvider, (previous, next) {
      next.when(
        data: (updatedReservation) {
          if (updatedReservation != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('예약이 취소되었습니다.')),
            );
            _refreshData(); // 데이터 새로고침
          }
        },
        loading: () {}, // 로딩 중에는 아무것도 하지 않음
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('취소 실패: $error')),
          );
        },
      );
    });
  }
}

// 가이드 할당 다이얼로그
class _GuideAssignmentDialog extends ConsumerWidget {
  final Reservation reservation;

  const _GuideAssignmentDialog({required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(guideRecommendationsProvider(reservation.id));
    
    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '가이드 할당',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            
            const SizedBox(height: 16),
            
            // 예약 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '예약 정보',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('예약번호: ${reservation.reservationNumber}'),
                  Text('고객: ${reservation.customers.map((c) => c.name).join(', ')}'),
                  Text('일시: ${DateFormat('yyyy-MM-dd HH:mm').format(reservation.startTime)}'),
                  Text('병원: ${reservation.clinic?.name ?? '알 수 없음'}'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '추천 가이드',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 가이드 목록
            Expanded(
              child: recommendationsAsync.when(
                data: (recommendations) => _buildGuideList(context, ref, recommendations),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('가이드 목록 로드 실패: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideList(BuildContext context, WidgetRef ref, List<GuideRecommendation> recommendations) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Text('사용 가능한 가이드가 없습니다.'),
      );
    }

    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];
        final guide = recommendation.guide;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: recommendation.isAvailable 
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              child: Icon(
                recommendation.isAvailable ? Icons.check : Icons.close,
                color: recommendation.isAvailable ? AppColors.success : AppColors.error,
              ),
            ),
                         title: Text(guide.koreanName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('언어: ${guide.languages.map((l) => l.name).join(', ')}'),
                Text('전문분야: ${guide.specialties.map((s) => s.name).join(', ')}'),
                if (!recommendation.isAvailable)
                  Text(
                    '사유: 해당 시간대 불가능',
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '매칭점수',
                  style: TextStyle(fontSize: 10, color: AppColors.grey600),
                ),
                Text(
                  '${recommendation.matchScore}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: recommendation.isAvailable 
                ? () => _assignGuide(context, ref, guide.id)
                : null,
          ),
        );
      },
    );
  }

  void _assignGuide(BuildContext context, WidgetRef ref, String guideId) {
    ref.read(reservationFormProvider.notifier).assignGuide(reservation.id, guideId);
    
    ref.listen(reservationFormProvider, (previous, next) {
      next.when(
        data: (updatedReservation) {
          if (updatedReservation != null) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('가이드가 할당되었습니다.')),
            );
            ref.invalidate(filteredReservationsProvider); // 데이터 새로고침
          }
        },
        loading: () {}, // 로딩 표시는 다이얼로그에서 처리
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('가이드 할당 실패: $error')),
          );
        },
      );
    });
  }
} 