import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';

part 'customers_ui_providers.g.dart';

/// 고객 목록 필터 상태 Provider
@riverpod
class CustomerFiltersNotifier extends _$CustomerFiltersNotifier {
  @override
  CustomerFilters build() => const CustomerFilters();

  /// 검색어 설정
  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 성별 필터 설정
  void setGender(CustomerGender? gender) {
    state = state.copyWith(gender: gender);
  }

  /// 국적 필터 설정
  void setNationality(String? nationality) {
    state = state.copyWith(nationality: nationality);
  }

  /// 유입채널 필터 설정
  void setAcquisitionChannel(String? channel) {
    state = state.copyWith(acquisitionChannel: channel);
  }

  /// 소통채널 필터 설정
  void setCommunicationChannel(CommunicationChannel? channel) {
    state = state.copyWith(communicationChannel: channel);
  }

  /// 예약자 여부 필터 설정
  void setIsBooker(bool? isBooker) {
    state = state.copyWith(isBooker: isBooker);
  }

  /// 생성일 필터 설정
  void setCreatedDateRange(DateTime? after, DateTime? before) {
    state = state.copyWith(createdAfter: after, createdBefore: before);
  }

  /// 결제금액 범위 필터 설정
  void setPaymentAmountRange(double? min, double? max) {
    state = state.copyWith(minPaymentAmount: min, maxPaymentAmount: max);
  }

  /// 필터 초기화
  void clearFilters() {
    state = const CustomerFilters();
  }
}

/// 고객 목록 페이지네이션 상태 Provider
@riverpod
class CustomerPaginationNotifier extends _$CustomerPaginationNotifier {
  @override
  CustomerPaginationState build() => const CustomerPaginationState();

  /// 페이지 변경
  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// 페이지 크기 변경
  void setPageSize(int pageSize) {
    state = state.copyWith(
      pageSize: pageSize,
      currentPage: 0, // 페이지 크기 변경 시 첫 페이지로 리셋
    );
  }

  /// 다음 페이지
  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// 이전 페이지
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }
}

/// 고객 목록 페이지네이션 상태 모델
class CustomerPaginationState {
  const CustomerPaginationState({this.currentPage = 0, this.pageSize = 20});

  final int currentPage;
  final int pageSize;

  /// offset 계산
  int get offset => currentPage * pageSize;

  CustomerPaginationState copyWith({int? currentPage, int? pageSize}) {
    return CustomerPaginationState(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// 고객 폼 상태 Provider
@riverpod
class CustomerFormNotifier extends _$CustomerFormNotifier {
  @override
  CustomerInput build() => const CustomerInput(name: '');

  /// 폼 데이터 설정 (수정 시 기존 고객 데이터로 초기화)
  void initializeWithCustomer(Customer customer) {
    state = CustomerInput(
      name: customer.name,
      nationality: customer.nationality,
      gender: customer.gender,
      age: customer.age,
      customerNote: customer.customerNote,
      birthDate: customer.birthDate,
      isBooker: customer.isBooker,
      booker: customer.booker,
      passportName: customer.passportName,
      passportLastName: customer.passportLastName,
      passportFirstName: customer.passportFirstName,
      acquisitionChannel: customer.acquisitionChannel,
      communicationChannel: customer.communicationChannel,
      channelAccount: customer.channelAccount,
    );
  }

  /// 폼 초기화
  void reset() {
    state = const CustomerInput(name: '');
  }

  /// 개별 필드 업데이트 메서드들
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateNationality(String? nationality) {
    state = state.copyWith(nationality: nationality);
  }

  void updateGender(CustomerGender? gender) {
    state = state.copyWith(gender: gender);
  }

  void updateAge(double? age) {
    state = state.copyWith(age: age);
  }

  void updateCustomerNote(String? note) {
    state = state.copyWith(customerNote: note);
  }

  void updateBirthDate(DateTime? birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void updateIsBooker(bool isBooker) {
    state = state.copyWith(isBooker: isBooker);
  }

  void updateBooker(String? booker) {
    state = state.copyWith(booker: booker);
  }

  void updateCustomerCode(String? customerCode) {
    state = state.copyWith(customerCode: customerCode);
  }

  void updatePassportName(String? passportName) {
    state = state.copyWith(passportName: passportName);
  }

  void updatePhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void updateAcquisitionChannel(String? channel) {
    state = state.copyWith(acquisitionChannel: channel);
  }

  void updateCommunicationChannel(CommunicationChannel? channel) {
    state = state.copyWith(communicationChannel: channel);
  }

  void updateChannelAccount(String? account) {
    state = state.copyWith(channelAccount: account);
  }

  void updatePurchaseCode(String? code) {
    state = state.copyWith(purchaseCode: code);
  }
}

/// 선택된 고객 상태 Provider
@riverpod
class SelectedCustomerNotifier extends _$SelectedCustomerNotifier {
  @override
  Customer? build() => null;

  /// 고객 선택
  void selectCustomer(Customer customer) {
    state = customer;
  }

  /// 선택 해제
  void clearSelection() {
    state = null;
  }
}
