import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/common/error_display_widget.dart';
import '../../domain/reservation_models.dart';
import '../../data/providers.dart';
import '../widgets/create_reservation_dialog.dart';

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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
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
                  suffixIcon:
                      _searchController.text.isNotEmpty
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
                    const DropdownMenuItem(value: null, child: Text('전체')),
                    ...ReservationStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(width: 16),

            // 병원 필터 (임시 비활성화)
            Container(
              width: 100,
              child: const Text('병원: 전체', style: TextStyle(color: Colors.grey)),
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
            data:
                (paginatedReservations) =>
                    _buildReservationsTable(paginatedReservations),
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
      children: List.generate(
        4,
        (index) => Expanded(
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
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
                Expanded(
                  flex: 2,
                  child: Text('예약번호', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('병원명', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 3,
                  child: Text('예약자', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('가이드', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('예약 일시', style: _headerTextStyle()),
                ),
                Expanded(flex: 1, child: Text('상태', style: _headerTextStyle())),
                const SizedBox(
                  width: 100,
                  child: Text('작업', textAlign: TextAlign.center),
                ),
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
            child: Text(
              reservation.reservationNumber,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // 병원명
          Expanded(
            flex: 2,
            child: Text(
              reservation.clinic?.name ?? '알 수 없음',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // 예약자 정보
          Expanded(flex: 3, child: _buildBookerInfo(reservation)),

          // 가이드
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  reservation.assignedGuide != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation.assignedGuide!.koreanName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            reservation.assignedGuide!.languages
                                .map((l) => l.name)
                                .join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              () => _showGuideAssignmentDialog(reservation),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          child: const Text(
                            '가이드 할당',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
            ),
          ),

          // 예약 일시
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MM/dd').format(reservation.reservationDate),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat('HH:mm').format(reservation.startTime),
                    style: TextStyle(fontSize: 12, color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ),

          // 상태
          Expanded(flex: 1, child: _buildStatusChip(reservation.status)),

          // 작업 버튼
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 상세 보기 버튼
                IconButton(
                  onPressed: () => _handleMenuAction('view', reservation),
                  icon: const Icon(Icons.visibility),
                  tooltip: '상세 보기',
                  iconSize: 20,
                ),
                const SizedBox(width: 4),
                // 삭제 버튼
                IconButton(
                  onPressed: () => _showDeleteConfirmDialog(reservation),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: '삭제',
                  iconSize: 20,
                ),
              ],
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
        color = const Color(0xFF808080); // 더 진한 회색
        break;
      case ReservationStatus.assigned:
        color = const Color(0xFF2E7D32); // 더 진한 파란색 계열
        break;
      case ReservationStatus.inProgress:
        color = const Color(0xFFE65100); // 더 진한 오렌지
        break;
      case ReservationStatus.completed:
        color = const Color(0xFF1B5E20); // 더 진한 초록
        break;
      case ReservationStatus.cancelled:
        color = const Color(0xFFC62828); // 더 진한 빨강
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
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
            items:
                [10, 20, 50, 100]
                    .map(
                      (size) =>
                          DropdownMenuItem(value: size, child: Text('$size개씩')),
                    )
                    .toList(),
          ),

          const SizedBox(width: 16),

          // 페이지 네비게이션
          Row(
            children: [
              IconButton(
                onPressed:
                    currentPage > 1
                        ? () =>
                            ref.read(reservationPageProvider.notifier).state =
                                currentPage - 1
                        : null,
                icon: const Icon(Icons.chevron_left),
              ),

              Text('$currentPage / $totalPages'),

              IconButton(
                onPressed:
                    paginatedReservations.hasNextPage
                        ? () =>
                            ref.read(reservationPageProvider.notifier).state =
                                currentPage + 1
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
          Icon(Icons.event_note, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            '예약이 없습니다',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 8),
          Text('첫 번째 예약을 생성해보세요.', style: TextStyle(color: AppColors.grey500)),
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
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            '데이터 로드 실패',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppColors.error),
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
    return const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
  }

  Widget _buildBookerInfo(Reservation reservation) {
    // 예약자 찾기 (isBooker가 true인 고객)
    final booker = reservation.customers.where((c) => c.isBooker).firstOrNull;

    if (booker == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '예약자 정보 없음',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
          Text(
            '총 ${reservation.customers.length}명',
            style: TextStyle(fontSize: 12, color: AppColors.grey600),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(booker.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          '${booker.nationality} · ${booker.birthDate != null ? DateFormat('yyyy-MM-dd').format(booker.birthDate!) : '생년월일 없음'}',
          style: TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
      ],
    );
  }

  void _showCreateReservationDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateReservationDialog(),
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
        _showReservationDetailsDialog(reservation);
        break;
      case 'edit':
        _showEditReservationDialog(reservation);
        break;
      case 'cancel':
        _showCancelConfirmation(reservation);
        break;
    }
  }

  void _showReservationDetailsDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 헤더
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '예약 상세 정보',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              reservation.reservationNumber,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                // 내용
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection('기본 정보', [
                          _buildDetailRow(
                            '예약번호',
                            reservation.reservationNumber,
                          ),
                          _buildDetailRow(
                            '예약일',
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(reservation.reservationDate),
                          ),
                          _buildDetailRow(
                            '시작시간',
                            DateFormat('HH:mm').format(reservation.startTime),
                          ),
                          _buildDetailRow(
                            '종료시간',
                            DateFormat('HH:mm').format(reservation.endTime),
                          ),
                          _buildDetailRow(
                            '소요시간',
                            '${reservation.endTime.difference(reservation.startTime).inMinutes}분',
                          ),
                          _buildDetailRow(
                            '상태',
                            _getStatusText(reservation.status.displayName),
                          ),
                          _buildDetailRow(
                            '서비스 유형',
                            _getServiceTypeText(reservation.serviceType?.code),
                          ),
                          _buildDetailRow('그룹 크기', '${reservation.groupSize}명'),
                        ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('금액 정보', [
                          _buildDetailRow(
                            '총 금액',
                            reservation.totalAmount != null
                                ? '${NumberFormat('#,###').format(reservation.totalAmount)}원'
                                : '미정',
                          ),
                          _buildDetailRow(
                            '가이드 수수료',
                            reservation.guideCommission != null
                                ? '${NumberFormat('#,###').format(reservation.guideCommission)}원'
                                : '미정',
                          ),
                        ]),
                        const SizedBox(height: 20),
                        if (reservation.assignedGuide != null)
                          _buildDetailSection('가이드 정보', [
                            _buildDetailRow(
                              '가이드명',
                              reservation.assignedGuide!.nickname,
                            ),
                            if (reservation.assignedGuide!.phoneNumber != null)
                              _buildDetailRow(
                                '연락처',
                                reservation.assignedGuide!.phoneNumber!,
                              ),
                            if (reservation.assignedGuide!.email != null)
                              _buildDetailRow(
                                '이메일',
                                reservation.assignedGuide!.email!,
                              ),
                          ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('병원 정보', [
                          _buildDetailRow('병원명', reservation.clinic.name),
                          if (reservation.clinic.address != null)
                            _buildDetailRow('주소', reservation.clinic.address!),
                          if (reservation.clinic.phone != null)
                            _buildDetailRow('연락처', reservation.clinic.phone!),
                        ]),
                        const SizedBox(height: 20),
                        if (reservation.customers.isNotEmpty)
                          _buildDetailSection(
                            '고객 정보',
                            reservation.customers
                                .map((customer) => _buildCustomerInfo(customer))
                                .toList(),
                          ),
                        const SizedBox(height: 20),
                        if (reservation.notes?.isNotEmpty == true)
                          _buildDetailSection('특별 요청사항', [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                reservation.notes!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ]),
                        const SizedBox(height: 20),
                        if (reservation.contactInfo?.isNotEmpty == true)
                          _buildDetailSection('연락처 정보', [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                reservation.contactInfo!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('시스템 정보', [
                          _buildDetailRow(
                            '생성일',
                            DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(reservation.createdAt),
                          ),
                          _buildDetailRow(
                            '수정일',
                            DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(reservation.updatedAt),
                          ),
                        ]),
                      ],
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
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showEditReservationDialog(reservation);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('수정하기'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showSettlementDialog(reservation);
                          },
                          icon: const Icon(Icons.account_balance_wallet),
                          label: const Text('정산하기'),
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
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(Customer customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                customer.isBooker ? Icons.person : Icons.person_outline,
                color: customer.isBooker ? Colors.blue[700] : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: customer.isBooker ? Colors.blue[700] : null,
                ),
              ),
              if (customer.isBooker) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '예약자',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (customer.nationality != null)
            _buildDetailRow('국적', customer.nationality!),
          if (customer.gender != null)
            _buildDetailRow('성별', _getGenderText(customer.gender!)),
          if (customer.age != null) _buildDetailRow('나이', '${customer.age}세'),
          if (customer.birthDate != null)
            _buildDetailRow(
              '생년월일',
              DateFormat('yyyy-MM-dd').format(customer.birthDate!),
            ),
          if (customer.notes?.isNotEmpty == true)
            _buildDetailRow('메모', customer.notes!),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending_assignment':
        return '배정 대기';
      case 'assigned':
        return '배정 완료';
      case 'in_progress':
        return '진행 중';
      case 'completed':
        return '완료';
      case 'cancelled':
        return '취소';
      default:
        return status;
    }
  }

  String _getServiceTypeText(String? serviceType) {
    if (serviceType == null) return '미지정';
    switch (serviceType) {
      case 'translation_only':
        return '통역만';
      case 'full_package':
        return '풀 패키지';
      case 'general_guide':
        return '일반 가이드';
      default:
        return serviceType;
    }
  }

  String _getGenderText(String gender) {
    switch (gender) {
      case 'male':
        return '남성';
      case 'female':
        return '여성';
      case 'other':
        return '기타';
      default:
        return gender;
    }
  }

  void _showCancelConfirmation(Reservation reservation) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
    ref
        .read(reservationFormProvider.notifier)
        .updateStatus(reservation.id, ReservationStatus.cancelled);

    // 성공/실패 처리는 reservationFormProvider를 watch하여 처리할 수 있음
    ref.listen(reservationFormProvider, (previous, next) {
      next.when(
        data: (_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('예약이 취소되었습니다.')));
          _refreshData(); // 데이터 새로고침
        },
        loading: () {}, // 로딩 중에는 아무것도 하지 않음
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('취소 실패: $error')));
        },
      );
    });
  }

  // 삭제 확인 다이얼로그를 표시하는 메서드
  void _showDeleteConfirmDialog(Reservation reservation) {
    showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('예약 삭제'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('정말로 이 예약을 삭제하시겠습니까?'),
                const SizedBox(height: 8),
                Text(
                  '한 번 삭제하면 되돌릴 수 없습니다.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('예약번호: ${reservation.reservationNumber}'),
                      Text('병원: ${reservation.clinic.name}'),
                      Text(
                        '예약자: ${reservation.customers.where((c) => c.isBooker).firstOrNull?.name ?? "정보 없음"}',
                      ),
                      Text(
                        '일시: ${DateFormat('yyyy-MM-dd HH:mm').format(reservation.startTime)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
    ).then((confirmed) {
      if (confirmed == true) {
        _deleteReservation(reservation);
      }
    });
  }

  // 예약을 완전히 삭제하는 메서드
  Future<void> _deleteReservation(Reservation reservation) async {
    try {
      // 외래키 제약 조건을 고려한 순차적 삭제

      // 1. reservations의 booker_id를 null로 설정 (외래키 제약 해제)
      await ref
          .read(supabaseClientProvider)
          .from('reservations')
          .update({'booker_id': null})
          .eq('id', reservation.id);

      // 2. customers 테이블에서 해당 예약의 고객들 삭제
      await ref
          .read(supabaseClientProvider)
          .from('customers')
          .delete()
          .eq('reservation_id', reservation.id);

      // 3. reservations 테이블에서 예약 삭제
      await ref
          .read(supabaseClientProvider)
          .from('reservations')
          .delete()
          .eq('id', reservation.id);

      if (mounted) {
        NotificationHelper.showSuccess(context, '예약이 완전히 삭제되었습니다.');

        // 실시간 구독이 자동으로 업데이트하지만, 즉시 반영을 위해 한 번 더 새로고침
        ref.invalidate(filteredReservationsProvider);
        ref.invalidate(reservationStatsProvider);
        ref.invalidate(todayReservationsProvider);
        ref.invalidate(upcomingReservationsProvider);
      }
    } catch (e) {
      if (mounted) {
        NotificationHelper.showError(context, '예약 삭제 중 오류가 발생했습니다: $e');
      }
    }
  }

  void _showEditReservationDialog(Reservation reservation) {
    // TODO: EditReservationDialog 구현 완료 후 교체
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text(
                    '예약 수정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '예약번호: ${reservation.reservationNumber}',
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '예약 수정 기능은 현재 개발 중입니다. 곧 완전한 수정 폼이 제공될 예정입니다.',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('닫기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('수정 기능은 곧 구현될 예정입니다.'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('확인'),
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

  void _showSettlementDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '정산 관리',
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

                // 내용
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSettlementSection('예약 정보', [
                          _buildDetailRow(
                            '예약번호',
                            reservation.reservationNumber,
                          ),
                          _buildDetailRow(
                            '예약일',
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(reservation.reservationDate),
                          ),
                          _buildDetailRow(
                            '고객명',
                            reservation.customers?.isNotEmpty == true
                                ? reservation.customers!
                                    .where((c) => c.isBooker)
                                    .first
                                    .name
                                : '정보 없음',
                          ),
                          if (reservation.assignedGuide != null)
                            _buildDetailRow(
                              '가이드',
                              reservation.assignedGuide!.nickname,
                            ),
                        ]),
                        const SizedBox(height: 20),
                        _buildSettlementSection('금액 정보', [
                          _buildDetailRow(
                            '총 금액',
                            reservation.totalAmount != null
                                ? '${NumberFormat('#,###').format(reservation.totalAmount)}원'
                                : '미정',
                          ),
                          _buildDetailRow(
                            '가이드 수수료',
                            reservation.guideCommission != null
                                ? '${NumberFormat('#,###').format(reservation.guideCommission)}원'
                                : '미정',
                          ),
                          _buildDetailRow(
                            '정산 상태',
                            _getSettlementStatus(reservation),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '정산 기능은 현재 개발 중입니다. 곧 정산 관리 탭과 연동될 예정입니다.',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('닫기'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: 정산 처리 로직 구현
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('정산 기능은 곧 구현될 예정입니다.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('정산 처리'),
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
      },
    );
  }

  Widget _buildSettlementSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  String _getSettlementStatus(Reservation reservation) {
    // TODO: 실제 정산 상태 로직 구현
    if (reservation.status == ReservationStatus.completed) {
      return '정산 대기';
    } else if (reservation.status == ReservationStatus.cancelled) {
      return '정산 불필요';
    } else {
      return '예약 진행 중';
    }
  }
}

// 가이드 할당 다이얼로그
class _GuideAssignmentDialog extends ConsumerWidget {
  final Reservation reservation;

  const _GuideAssignmentDialog({required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(
      guideRecommendationsProvider(reservation.id),
    );

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
                  Text(
                    '고객: ${reservation.customers.map((c) => c.name).join(', ')}',
                  ),
                  Text(
                    '일시: ${DateFormat('yyyy-MM-dd HH:mm').format(reservation.startTime)}',
                  ),
                  Text('병원: ${reservation.clinic?.name ?? '알 수 없음'}'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '추천 가이드',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // 가이드 목록
            Expanded(
              child: recommendationsAsync.when(
                data:
                    (recommendations) =>
                        _buildGuideList(context, ref, recommendations),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, _) => Center(child: Text('가이드 목록 로드 실패: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideList(
    BuildContext context,
    WidgetRef ref,
    List<GuideRecommendation> recommendations,
  ) {
    if (recommendations.isEmpty) {
      return const Center(child: Text('사용 가능한 가이드가 없습니다.'));
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
              backgroundColor:
                  recommendation.isAvailable
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
              child: Icon(
                recommendation.isAvailable ? Icons.check : Icons.close,
                color:
                    recommendation.isAvailable
                        ? AppColors.success
                        : AppColors.error,
              ),
            ),
            title: Text(guide.koreanName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('언어: ${guide.languages.map((l) => l.name).join(', ')}'),
                Text(
                  '전문분야: ${guide.specialties.map((s) => s.name).join(', ')}',
                ),
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
            onTap:
                recommendation.isAvailable
                    ? () => _assignGuide(context, ref, guide.id)
                    : null,
          ),
        );
      },
    );
  }

  void _assignGuide(BuildContext context, WidgetRef ref, String guideId) {
    ref
        .read(reservationFormProvider.notifier)
        .assignGuide(reservation.id, guideId);

    ref.listen(reservationFormProvider, (previous, next) {
      next.when(
        data: (_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('가이드가 할당되었습니다.')));
          ref.invalidate(filteredReservationsProvider); // 데이터 새로고침
        },
        loading: () {}, // 로딩 표시는 다이얼로그에서 처리
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('가이드 할당 실패: $error')));
        },
      );
    });
  }
}
