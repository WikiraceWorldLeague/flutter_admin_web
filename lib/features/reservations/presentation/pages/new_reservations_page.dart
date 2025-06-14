import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';

// 임시 데이터 모델 (나중에 실제 모델로 교체)
class MockReservation {
  final String id;
  final String reservationNumber;
  final String customerName;
  final String guideName;
  final DateTime date;
  final String status;
  final int customerCount;
  final String clinic;

  MockReservation({
    required this.id,
    required this.reservationNumber,
    required this.customerName,
    required this.guideName,
    required this.date,
    required this.status,
    required this.customerCount,
    required this.clinic,
  });
}

// 임시 데이터
final mockReservations = [
  MockReservation(
    id: '1',
    reservationNumber: 'R20241201001',
    customerName: '김철수',
    guideName: '이영희',
    date: DateTime(2024, 12, 15, 10, 0),
    status: '할당 완료',
    customerCount: 2,
    clinic: '강남성형외과',
  ),
  MockReservation(
    id: '2',
    reservationNumber: 'R20241201002',
    customerName: '박민수',
    guideName: '미배정',
    date: DateTime(2024, 12, 16, 14, 0),
    status: '할당 대기',
    customerCount: 1,
    clinic: '신사동피부과',
  ),
  MockReservation(
    id: '3',
    reservationNumber: 'R20241201003',
    customerName: '최예진',
    guideName: '김가이드',
    date: DateTime(2024, 12, 17, 9, 30),
    status: '진행 중',
    customerCount: 3,
    clinic: '압구정의원',
  ),
];

class NewReservationsPage extends ConsumerStatefulWidget {
  const NewReservationsPage({super.key});

  @override
  ConsumerState<NewReservationsPage> createState() => _NewReservationsPageState();
}

class _NewReservationsPageState extends ConsumerState<NewReservationsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = '전체';
  String _selectedClinic = '전체';
  String _selectedServiceType = '전체';
  int _currentPage = 1;
  int _itemsPerPage = 20;
  
  List<MockReservation> _filteredReservations = mockReservations;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredReservations = mockReservations.where((reservation) {
        // 검색어 필터
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          if (!reservation.customerName.toLowerCase().contains(query) &&
              !reservation.reservationNumber.toLowerCase().contains(query)) {
            return false;
          }
        }

        // 상태 필터
        if (_selectedStatus != '전체' && reservation.status != _selectedStatus) {
          return false;
        }

        // 병원 필터
        if (_selectedClinic != '전체' && reservation.clinic != _selectedClinic) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        
        const SizedBox(height: 24),
        
        // Search and Filters Row
        Row(
          children: [
            // 검색 필드
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilters(),
                decoration: InputDecoration(
                  hintText: '예약번호, 고객명 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _applyFilters();
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
            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
                _applyFilters();
              },
              items: ['전체', '할당 대기', '할당 완료', '진행 중', '완료', '취소']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
            
            const SizedBox(width: 16),
            
            // 병원 필터
            DropdownButton<String>(
              value: _selectedClinic,
              onChanged: (value) {
                setState(() {
                  _selectedClinic = value!;
                });
                _applyFilters();
              },
              items: ['전체', '강남성형외과', '신사동피부과', '압구정의원']
                  .map((clinic) => DropdownMenuItem(
                        value: clinic,
                        child: Text(clinic),
                      ))
                  .toList(),
            ),
            
            const SizedBox(width: 16),
            
            // 필터 버튼
            OutlinedButton.icon(
              onPressed: () => _showFilterDialog(),
              icon: const Icon(Icons.filter_list),
              label: const Text('상세 필터'),
            ),
            
            const SizedBox(width: 8),
            
            // 내보내기 버튼
            OutlinedButton.icon(
              onPressed: () => _exportData(),
              icon: const Icon(Icons.download),
              label: const Text('내보내기'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Status Cards - Phase 2.1 답변에 따른 대시보드 지표
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: '할당 대기',
                count: mockReservations.where((r) => r.status == '할당 대기').length,
                color: AppColors.warning,
                icon: Icons.pending_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatusCard(
                title: '할당 완료',
                count: mockReservations.where((r) => r.status == '할당 완료').length,
                color: AppColors.success,
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatusCard(
                title: '진행 중',
                count: mockReservations.where((r) => r.status == '진행 중').length,
                color: AppColors.info,
                icon: Icons.schedule_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatusCard(
                title: '완료',
                count: mockReservations.where((r) => r.status == '완료').length,
                color: AppColors.primary,
                icon: Icons.task_alt_outlined,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Page Size Selector
        Row(
          children: [
            Text('페이지당 항목 수: '),
            DropdownButton<int>(
              value: _itemsPerPage,
              onChanged: (value) {
                setState(() {
                  _itemsPerPage = value!;
                  _currentPage = 1;
                });
              },
              items: [20, 50, 100]
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text('$size개'),
                      ))
                  .toList(),
            ),
            const Spacer(),
            Text('총 ${_filteredReservations.length}개 예약'),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Reservations Table
        Expanded(
          child: Card(
            child: Column(
              children: [
                // Table Header - Phase 2.1 답변에 따른 컬럼 순서
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(flex: 2, child: Text('예약번호', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('고객정보', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('가이드', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('날짜/시간', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 1, child: Text('상태', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 120, child: Text('작업', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                
                // Table Content
                Expanded(
                  child: _filteredReservations.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _filteredReservations.length,
                          itemBuilder: (context, index) {
                            final reservation = _filteredReservations[index];
                            return _buildReservationRow(reservation, index);
                          },
                        ),
                ),
                
                // Pagination
                if (_filteredReservations.isNotEmpty) _buildPagination(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationRow(MockReservation reservation, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  reservation.clinic,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          
          // 고객정보 - Phase 2.1 답변에 따른 "고객 수" 표기
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reservation.customerName),
                Text(
                  '${reservation.customerCount}명',
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
            child: Row(
              children: [
                if (reservation.guideName == '미배정')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '미배정',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          reservation.guideName[0],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(reservation.guideName),
                    ],
                  ),
              ],
            ),
          ),
          
          // 날짜/시간
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(reservation.date)),
                Text(
                  DateFormat('HH:mm').format(reservation.date),
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
            flex: 1,
            child: _buildStatusBadge(reservation.status),
          ),
          
          // 작업 버튼들
          SizedBox(
            width: 120,
            child: Row(
              children: [
                if (reservation.guideName == '미배정')
                  IconButton(
                    onPressed: () => _showGuideAssignmentDialog(reservation),
                    icon: const Icon(Icons.person_add),
                    tooltip: '가이드 할당',
                    color: AppColors.primary,
                  ),
                IconButton(
                  onPressed: () => _editReservation(reservation),
                  icon: const Icon(Icons.edit),
                  tooltip: '수정',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, reservation),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('상세보기'),
                    ),
                    const PopupMenuItem(
                      value: 'status',
                      child: Text('상태변경'),
                    ),
                    if (reservation.status != '완료' && reservation.status != '취소')
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('취소'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case '할당 대기':
        color = AppColors.warning;
        break;
      case '할당 완료':
        color = AppColors.success;
        break;
      case '진행 중':
        color = AppColors.info;
        break;
      case '완료':
        color = AppColors.primary;
        break;
      case '취소':
        color = AppColors.error;
        break;
      default:
        color = AppColors.grey500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '예약 데이터가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새 예약을 추가하거나 필터를 조정해보세요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_filteredReservations.length / _itemsPerPage).ceil();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage--)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          for (int i = 1; i <= totalPages; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () => setState(() => _currentPage = i),
                style: TextButton.styleFrom(
                  backgroundColor: _currentPage == i ? AppColors.primary : null,
                  foregroundColor: _currentPage == i ? Colors.white : null,
                ),
                child: Text('$i'),
              ),
            ),
          IconButton(
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _showCreateReservationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 예약 생성'),
        content: const Text('예약 생성 폼이 여기에 표시됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }

  void _showGuideAssignmentDialog(MockReservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('가이드 할당'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('예약번호: ${reservation.reservationNumber}'),
            const SizedBox(height: 16),
            const Text('가이드 추천 목록이 여기에 표시됩니다.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('할당'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상세 필터'),
        content: const Text('상세 필터 옵션이 여기에 표시됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('데이터 내보내기 기능이 구현될 예정입니다.')),
    );
  }

  void _editReservation(MockReservation reservation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${reservation.reservationNumber} 수정')),
    );
  }

  void _handleMenuAction(String action, MockReservation reservation) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reservation.reservationNumber} 상세보기')),
        );
        break;
      case 'status':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reservation.reservationNumber} 상태변경')),
        );
        break;
      case 'cancel':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reservation.reservationNumber} 취소')),
        );
        break;
    }
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 