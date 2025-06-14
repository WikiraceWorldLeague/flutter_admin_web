import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../domain/reservation_models.dart';
import '../providers/reservations_providers.dart';
import '../widgets/reservation_filters_widget.dart';
import '../widgets/reservation_status_chip.dart';
import '../widgets/guide_assignment_dialog.dart';

// 베이지 테마 색상 정의
class ReservationColors {
  static const primary = Color(0xFFD4B896);
  static const primaryLight = Color(0xFFE8D5B7);
  static const primaryDark = Color(0xFFB8956F);
  static const background = Color(0xFFFAF8F5);
  static const surface = Color(0xFFF5F2ED);
  static const onSurface = Color(0xFF5D4E37);
  static const secondary = Color(0xFF8B7355);
  static const accent = Color(0xFFE6D7C3);
}

class ReservationsListPage extends ConsumerStatefulWidget {
  const ReservationsListPage({super.key});

  @override
  ConsumerState<ReservationsListPage> createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends ConsumerState<ReservationsListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // 페이지 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reservationsListProvider.notifier).loadReservations();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // 스크롤이 끝에 가까워지면 다음 페이지 로드
      ref.read(reservationsListProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationsState = ref.watch(reservationsListProvider);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final filterSummary = ref.watch(filterSummaryProvider);

    return Scaffold(
      backgroundColor: ReservationColors.background,
      appBar: AppBar(
        title: const Text(
          '예약 관리',
          style: TextStyle(
            color: ReservationColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ReservationColors.background,
        elevation: 0,
        actions: [
          // 필터 토글 버튼
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: hasActiveFilters ? ReservationColors.primary : ReservationColors.secondary,
            ),
            tooltip: '필터',
          ),
          // 새로고침 버튼
          IconButton(
            onPressed: reservationsState.isRefreshing
                ? null
                : () => ref.read(reservationsListProvider.notifier).refresh(),
            icon: reservationsState.isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ReservationColors.primary,
                    ),
                  )
                : const Icon(Icons.refresh, color: ReservationColors.secondary),
            tooltip: '새로고침',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 필터 섹션
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ReservationColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: ReservationColors.onSurface,
                    width: 1,
                  ),
                ),
              ),
              child: const ReservationFiltersWidget(),
            ),

          // 필터 요약 표시
          if (hasActiveFilters)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ReservationColors.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: ReservationColors.onSurface,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 16,
                    color: ReservationColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '필터: $filterSummary',
                    style: TextStyle(
                      color: ReservationColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      ref.read(reservationFiltersProvider.notifier).state = const ReservationFilters();
                    },
                    child: Text(
                      '초기화',
                      style: TextStyle(
                        color: ReservationColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 통계 요약
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildStatsRow(),
          ),

          // 예약 목록
          Expanded(
            child: _buildReservationsList(reservationsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 예약 등록 페이지로 이동
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('예약 등록 기능은 추후 구현 예정입니다.')),
          );
        },
        backgroundColor: ReservationColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = ref.watch(reservationStatsProvider);
    
    return Row(
      children: ReservationStatus.values.map((status) {
        final count = stats[status] ?? 0;
        final color = Color(ReservationStatusColors.getColor(status));
        
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReservationsList(ReservationsListState state) {
    if (state.isLoading && state.reservations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: ReservationColors.primary),
      );
    }

    if (state.error != null && state.reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: ReservationColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없습니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ReservationColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: TextStyle(
                color: ReservationColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(reservationsListProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ReservationColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state.reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: ReservationColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              '예약이 없습니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ReservationColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 예약을 등록해보세요',
              style: TextStyle(
                color: ReservationColors.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(reservationsListProvider.notifier).refresh(),
      color: ReservationColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.reservations.length + (state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.reservations.length) {
            // 로딩 인디케이터
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: ReservationColors.primary),
              ),
            );
          }

          final reservation = state.reservations[index];
          return _buildReservationCard(reservation);
        },
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ReservationColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ReservationColors.onSurface, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 행
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.reservationNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ReservationColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reservation.clinic.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: ReservationColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ReservationStatusChip(status: reservation.status),
              ],
            ),

            const SizedBox(height: 12),

            // 예약 정보 행
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.calendar_today,
                    DateFormat('MM/dd (E)', 'ko_KR').format(reservation.reservationDate),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.access_time,
                    '${DateFormat('HH:mm').format(reservation.startTime)} - ${DateFormat('HH:mm').format(reservation.endTime)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 고객 및 서비스 정보
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.people,
                    '${reservation.customerNames} (${reservation.customerCount}명)',
                  ),
                ),
              ],
            ),

            if (reservation.serviceTypeNames.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoItem(
                Icons.medical_services,
                reservation.serviceTypeNames,
              ),
            ],

            // 가이드 정보
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.person,
                    reservation.assignedGuide?.nickname ?? '미배정',
                    color: reservation.assignedGuide != null 
                        ? ReservationColors.onSurface 
                        : ReservationColors.secondary,
                  ),
                ),
                if (reservation.isPending || reservation.isAssigned)
                  TextButton.icon(
                    onPressed: () => _showGuideAssignmentDialog(reservation),
                    icon: Icon(
                      reservation.assignedGuide != null ? Icons.edit : Icons.person_add,
                      size: 16,
                      color: ReservationColors.primary,
                    ),
                    label: Text(
                      reservation.assignedGuide != null ? '변경' : '배정',
                      style: TextStyle(
                        color: ReservationColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            // 금액 정보
            if (reservation.totalAmount != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.attach_money,
                      '${NumberFormat('#,###').format(reservation.totalAmount!)}원',
                    ),
                  ),
                  if (reservation.guideCommission != null)
                    Expanded(
                      child: _buildInfoItem(
                        Icons.account_balance_wallet,
                        '수수료: ${NumberFormat('#,###').format(reservation.guideCommission!)}원',
                      ),
                    ),
                ],
              ),
            ],

            // 액션 버튼들
            if (reservation.isPending || reservation.isAssigned || reservation.isInProgress) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (reservation.isPending)
                    _buildActionButton(
                      '취소',
                      Icons.cancel,
                      Colors.red,
                      () => _updateStatus(reservation, ReservationStatus.cancelled),
                    ),
                  if (reservation.isAssigned)
                    _buildActionButton(
                      '시작',
                      Icons.play_arrow,
                      Colors.green,
                      () => _updateStatus(reservation, ReservationStatus.inProgress),
                    ),
                  if (reservation.isInProgress)
                    _buildActionButton(
                      '완료',
                      Icons.check,
                      Colors.blue,
                      () => _updateStatus(reservation, ReservationStatus.completed),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? ReservationColors.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color ?? ReservationColors.secondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  void _showGuideAssignmentDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => GuideAssignmentDialog(
        reservation: reservation,
        onAssign: (guideId) {
          ref.read(reservationsListProvider.notifier).assignGuide(reservation.id, guideId);
        },
      ),
    );
  }

  void _updateStatus(Reservation reservation, ReservationStatus newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상태 변경'),
        content: Text('예약 상태를 "${newStatus.displayName}"(으)로 변경하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(reservationsListProvider.notifier).updateReservationStatus(
                reservation.id,
                newStatus,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ReservationColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
} 