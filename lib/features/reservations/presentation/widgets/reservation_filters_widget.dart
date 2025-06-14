import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/reservation_models.dart';
import '../providers/reservations_providers.dart';
import '../../../../core/theme/app_theme.dart';

class ReservationFiltersWidget extends ConsumerStatefulWidget {
  const ReservationFiltersWidget({super.key});

  @override
  ConsumerState<ReservationFiltersWidget> createState() => _ReservationFiltersWidgetState();
}

class _ReservationFiltersWidgetState extends ConsumerState<ReservationFiltersWidget> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  ReservationStatus? _selectedStatus;
  String? _selectedClinicId;
  String? _selectedGuideId;

  @override
  void initState() {
    super.initState();
    
    // 현재 필터 상태로 초기화
    final currentFilters = ref.read(reservationFiltersProvider);
    _searchController.text = currentFilters.searchQuery ?? '';
    _startDate = currentFilters.startDate;
    _endDate = currentFilters.endDate;
    _selectedStatus = currentFilters.status;
    _selectedClinicId = currentFilters.clinicId;
    _selectedGuideId = currentFilters.guideId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = ReservationFilters(
      startDate: _startDate,
      endDate: _endDate,
      status: _selectedStatus,
      clinicId: _selectedClinicId,
      guideId: _selectedGuideId,
      searchQuery: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    );

    ref.read(reservationFiltersProvider.notifier).state = filters;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _startDate = null;
      _endDate = null;
      _selectedStatus = null;
      _selectedClinicId = null;
      _selectedGuideId = null;
    });
    
    ref.read(reservationFiltersProvider.notifier).state = const ReservationFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 검색어 입력
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '예약번호 또는 고객명으로 검색',
            prefixIcon: Icon(Icons.search, color: AppColors.grey600),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                    icon: Icon(Icons.clear, color: AppColors.grey600),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
          onChanged: (_) => _applyFilters(),
        ),

        const SizedBox(height: 16),

        // 날짜 범위 선택
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: '시작 날짜',
                date: _startDate,
                onDateSelected: (date) {
                  setState(() {
                    _startDate = date;
                  });
                  _applyFilters();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                label: '종료 날짜',
                date: _endDate,
                onDateSelected: (date) {
                  setState(() {
                    _endDate = date;
                  });
                  _applyFilters();
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 상태 및 클리닉 선택
        Row(
          children: [
            Expanded(
              child: _buildStatusDropdown(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildClinicDropdown(),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 가이드 선택 및 액션 버튼
        Row(
          children: [
            Expanded(
              child: _buildGuideDropdown(),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.grey600,
                elevation: 0,
                side: BorderSide(color: AppColors.grey300),
              ),
              child: const Text('초기화'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        onDateSelected(selectedDate);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.background,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null
                    ? '${date.month}/${date.day}/${date.year}'
                    : label,
                style: TextStyle(
                  color: date != null ? AppColors.onBackground : AppColors.grey600,
                  fontSize: 14,
                ),
              ),
            ),
            if (date != null)
              GestureDetector(
                onTap: () => onDateSelected(null),
                child: Icon(Icons.clear, size: 16, color: AppColors.grey600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<ReservationStatus>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: '상태',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.background,
      ),
      items: [
        const DropdownMenuItem<ReservationStatus>(
          value: null,
          child: Text('전체'),
        ),
        ...ReservationStatus.values.map((status) {
          return DropdownMenuItem<ReservationStatus>(
            value: status,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(ReservationStatusColors.getColor(status)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(status.displayName),
              ],
            ),
          );
        }),
      ],
      onChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
        _applyFilters();
      },
    );
  }

  Widget _buildClinicDropdown() {
    final clinicsAsync = ref.watch(clinicsProvider);

    return clinicsAsync.when(
      data: (clinics) {
        return DropdownButtonFormField<String>(
          value: _selectedClinicId,
          decoration: InputDecoration(
            labelText: '클리닉',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('전체'),
            ),
            ...clinics.map((clinic) {
              return DropdownMenuItem<String>(
                value: clinic.id,
                child: Text(
                  clinic.name,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: (clinicId) {
            setState(() {
              _selectedClinicId = clinicId;
            });
            _applyFilters();
          },
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.background,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              '클리닉 로딩 중...',
              style: TextStyle(color: AppColors.grey600),
            ),
          ],
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.background,
        ),
        child: Text(
          '클리닉 로드 실패',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildGuideDropdown() {
    final guidesAsync = ref.watch(guidesProvider);

    return guidesAsync.when(
      data: (guides) {
        return DropdownButtonFormField<String>(
          value: _selectedGuideId,
          decoration: InputDecoration(
            labelText: '가이드',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('전체'),
            ),
            ...guides.map((guide) {
              return DropdownMenuItem<String>(
                value: guide.id,
                child: Text(
                  guide.nickname,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: (guideId) {
            setState(() {
              _selectedGuideId = guideId;
            });
            _applyFilters();
          },
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.background,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              '가이드 로딩 중...',
              style: TextStyle(color: AppColors.grey600),
            ),
          ],
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.background,
        ),
        child: Text(
          '가이드 로드 실패',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
} 