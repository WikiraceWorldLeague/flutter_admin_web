import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/presentation/providers/customers_ui_providers.dart';

/// 고객 검색 및 필터 위젯
class CustomerSearchWidget extends HookConsumerWidget {
  const CustomerSearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final filters = ref.watch(customerFiltersNotifierProvider);
    final showAdvancedFilters = useState(false);

    // 검색어 변경 시 필터 업데이트
    useEffect(() {
      void onSearchChanged() {
        if (searchController.text != filters.searchQuery) {
          ref
              .read(customerFiltersNotifierProvider.notifier)
              .setSearchQuery(
                searchController.text.isEmpty ? null : searchController.text,
              );
          // 검색 시 첫 페이지로 리셋
          ref.read(customerPaginationNotifierProvider.notifier).setPage(0);
        }
      }

      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController]);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 기본 검색 영역
            Row(
              children: [
                // 검색 필드
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: '고객명, 여권명, 고객코드, 전화번호로 검색...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                onPressed: () {
                                  searchController.clear();
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

                // 고급 필터 토글 버튼
                FilledButton.tonalIcon(
                  onPressed: () {
                    showAdvancedFilters.value = !showAdvancedFilters.value;
                  },
                  icon: Icon(
                    showAdvancedFilters.value
                        ? Icons.filter_list_off
                        : Icons.filter_list,
                  ),
                  label: Text(showAdvancedFilters.value ? '필터 숨기기' : '고급 필터'),
                ),
              ],
            ),

            // 고급 필터 영역
            if (showAdvancedFilters.value) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildAdvancedFilters(context, ref, filters),
            ],
          ],
        ),
      ),
    );
  }

  /// 고급 필터 위젯
  Widget _buildAdvancedFilters(
    BuildContext context,
    WidgetRef ref,
    CustomerFilters filters,
  ) {
    return Column(
      children: [
        // 첫 번째 행: 성별, 국적, 예약자 여부
        Row(
          children: [
            // 성별 필터
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('성별', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<CustomerGender?>(
                    value: filters.gender,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<CustomerGender?>(
                        value: null,
                        child: Text('전체'),
                      ),
                      for (final gender in CustomerGender.values)
                        DropdownMenuItem<CustomerGender?>(
                          value: gender,
                          child: Text(_getGenderDisplayName(gender)),
                        ),
                    ],
                    onChanged: (value) {
                      ref
                          .read(customerFiltersNotifierProvider.notifier)
                          .setGender(value);
                      ref
                          .read(customerPaginationNotifierProvider.notifier)
                          .setPage(0);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 국적 필터
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('국적', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: filters.nationality,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '국적 입력',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      ref
                          .read(customerFiltersNotifierProvider.notifier)
                          .setNationality(value.isEmpty ? null : value);
                      ref
                          .read(customerPaginationNotifierProvider.notifier)
                          .setPage(0);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 예약자 여부 필터
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '예약자 여부',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<bool?>(
                    value: filters.isBooker,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem<bool?>(value: null, child: Text('전체')),
                      DropdownMenuItem<bool?>(value: true, child: Text('예약자')),
                      DropdownMenuItem<bool?>(
                        value: false,
                        child: Text('비예약자'),
                      ),
                    ],
                    onChanged: (value) {
                      ref
                          .read(customerFiltersNotifierProvider.notifier)
                          .setIsBooker(value);
                      ref
                          .read(customerPaginationNotifierProvider.notifier)
                          .setPage(0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 두 번째 행: 유입채널, 소통채널
        Row(
          children: [
            // 유입채널 필터
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('유입채널', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: filters.acquisitionChannel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '유입채널 입력',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      ref
                          .read(customerFiltersNotifierProvider.notifier)
                          .setAcquisitionChannel(value.isEmpty ? null : value);
                      ref
                          .read(customerPaginationNotifierProvider.notifier)
                          .setPage(0);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 소통채널 필터
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('소통채널', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<CommunicationChannel?>(
                    value: filters.communicationChannel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<CommunicationChannel?>(
                        value: null,
                        child: Text('전체'),
                      ),
                      ...CommunicationChannel.values.map((channel) {
                        return DropdownMenuItem<CommunicationChannel?>(
                          value: channel,
                          child: Text(channel.displayName),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      ref
                          .read(customerFiltersNotifierProvider.notifier)
                          .setCommunicationChannel(value);
                      ref
                          .read(customerPaginationNotifierProvider.notifier)
                          .setPage(0);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 빈 공간 (레이아웃 맞춤)
            const Expanded(child: SizedBox()),
          ],
        ),

        const SizedBox(height: 16),

        // 액션 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                ref
                    .read(customerFiltersNotifierProvider.notifier)
                    .clearFilters();
                ref
                    .read(customerPaginationNotifierProvider.notifier)
                    .setPage(0);
              },
              child: const Text('필터 초기화'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                // 필터 적용 (상태가 자동으로 적용되므로 특별한 액션 불필요)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('필터가 적용되었습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('필터 적용'),
            ),
          ],
        ),
      ],
    );
  }

  /// 성별 표시명 반환
  String _getGenderDisplayName(CustomerGender gender) {
    switch (gender) {
      case CustomerGender.male:
        return '남성';
      case CustomerGender.female:
        return '여성';
      case CustomerGender.other:
        return '기타';
    }
  }
}
