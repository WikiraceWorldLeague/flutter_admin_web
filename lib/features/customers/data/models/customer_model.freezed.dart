// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'reservation_id')
  String? get reservationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  double? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_note')
  String? get customerNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_booker')
  bool get isBooker => throw _privateConstructorUsedError;
  String? get booker => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_code')
  String? get customerCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'passport_name')
  String? get passportName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel_account')
  String? get channelAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_code')
  String? get purchaseCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_payment_amount')
  double get totalPaymentAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_revenue_with_tax')
  double get companyRevenueWithTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_revenue_without_tax')
  double get companyRevenueWithoutTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'guide_commission')
  double get guideCommission => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_revenue_with_tax')
  double get netRevenueWithTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_revenue_without_tax')
  double get netRevenueWithoutTax => throw _privateConstructorUsedError;

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'reservation_id') String? reservationId,
    String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
    @JsonKey(name: 'total_payment_amount') double totalPaymentAmount,
    @JsonKey(name: 'company_revenue_with_tax') double companyRevenueWithTax,
    @JsonKey(name: 'company_revenue_without_tax')
    double companyRevenueWithoutTax,
    @JsonKey(name: 'guide_commission') double guideCommission,
    @JsonKey(name: 'net_revenue_with_tax') double netRevenueWithTax,
    @JsonKey(name: 'net_revenue_without_tax') double netRevenueWithoutTax,
  });
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? reservationId = freezed,
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? customerNote = freezed,
    Object? createdAt = null,
    Object? birthDate = freezed,
    Object? isBooker = null,
    Object? booker = freezed,
    Object? customerCode = freezed,
    Object? passportName = freezed,
    Object? phone = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? purchaseCode = freezed,
    Object? totalPaymentAmount = null,
    Object? companyRevenueWithTax = null,
    Object? companyRevenueWithoutTax = null,
    Object? guideCommission = null,
    Object? netRevenueWithTax = null,
    Object? netRevenueWithoutTax = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationId:
                freezed == reservationId
                    ? _value.reservationId
                    : reservationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            nationality:
                freezed == nationality
                    ? _value.nationality
                    : nationality // ignore: cast_nullable_to_non_nullable
                        as String?,
            gender:
                freezed == gender
                    ? _value.gender
                    : gender // ignore: cast_nullable_to_non_nullable
                        as CustomerGender?,
            age:
                freezed == age
                    ? _value.age
                    : age // ignore: cast_nullable_to_non_nullable
                        as double?,
            customerNote:
                freezed == customerNote
                    ? _value.customerNote
                    : customerNote // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            birthDate:
                freezed == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isBooker:
                null == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool,
            booker:
                freezed == booker
                    ? _value.booker
                    : booker // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerCode:
                freezed == customerCode
                    ? _value.customerCode
                    : customerCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportName:
                freezed == passportName
                    ? _value.passportName
                    : passportName // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            channelAccount:
                freezed == channelAccount
                    ? _value.channelAccount
                    : channelAccount // ignore: cast_nullable_to_non_nullable
                        as String?,
            purchaseCode:
                freezed == purchaseCode
                    ? _value.purchaseCode
                    : purchaseCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalPaymentAmount:
                null == totalPaymentAmount
                    ? _value.totalPaymentAmount
                    : totalPaymentAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            companyRevenueWithTax:
                null == companyRevenueWithTax
                    ? _value.companyRevenueWithTax
                    : companyRevenueWithTax // ignore: cast_nullable_to_non_nullable
                        as double,
            companyRevenueWithoutTax:
                null == companyRevenueWithoutTax
                    ? _value.companyRevenueWithoutTax
                    : companyRevenueWithoutTax // ignore: cast_nullable_to_non_nullable
                        as double,
            guideCommission:
                null == guideCommission
                    ? _value.guideCommission
                    : guideCommission // ignore: cast_nullable_to_non_nullable
                        as double,
            netRevenueWithTax:
                null == netRevenueWithTax
                    ? _value.netRevenueWithTax
                    : netRevenueWithTax // ignore: cast_nullable_to_non_nullable
                        as double,
            netRevenueWithoutTax:
                null == netRevenueWithoutTax
                    ? _value.netRevenueWithoutTax
                    : netRevenueWithoutTax // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
    _$CustomerImpl value,
    $Res Function(_$CustomerImpl) then,
  ) = __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'reservation_id') String? reservationId,
    String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
    @JsonKey(name: 'total_payment_amount') double totalPaymentAmount,
    @JsonKey(name: 'company_revenue_with_tax') double companyRevenueWithTax,
    @JsonKey(name: 'company_revenue_without_tax')
    double companyRevenueWithoutTax,
    @JsonKey(name: 'guide_commission') double guideCommission,
    @JsonKey(name: 'net_revenue_with_tax') double netRevenueWithTax,
    @JsonKey(name: 'net_revenue_without_tax') double netRevenueWithoutTax,
  });
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
    _$CustomerImpl _value,
    $Res Function(_$CustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? reservationId = freezed,
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? customerNote = freezed,
    Object? createdAt = null,
    Object? birthDate = freezed,
    Object? isBooker = null,
    Object? booker = freezed,
    Object? customerCode = freezed,
    Object? passportName = freezed,
    Object? phone = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? purchaseCode = freezed,
    Object? totalPaymentAmount = null,
    Object? companyRevenueWithTax = null,
    Object? companyRevenueWithoutTax = null,
    Object? guideCommission = null,
    Object? netRevenueWithTax = null,
    Object? netRevenueWithoutTax = null,
  }) {
    return _then(
      _$CustomerImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationId:
            freezed == reservationId
                ? _value.reservationId
                : reservationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        nationality:
            freezed == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                    as String?,
        gender:
            freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                    as CustomerGender?,
        age:
            freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as double?,
        customerNote:
            freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        birthDate:
            freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isBooker:
            null == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool,
        booker:
            freezed == booker
                ? _value.booker
                : booker // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerCode:
            freezed == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportName:
            freezed == passportName
                ? _value.passportName
                : passportName // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        channelAccount:
            freezed == channelAccount
                ? _value.channelAccount
                : channelAccount // ignore: cast_nullable_to_non_nullable
                    as String?,
        purchaseCode:
            freezed == purchaseCode
                ? _value.purchaseCode
                : purchaseCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalPaymentAmount:
            null == totalPaymentAmount
                ? _value.totalPaymentAmount
                : totalPaymentAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        companyRevenueWithTax:
            null == companyRevenueWithTax
                ? _value.companyRevenueWithTax
                : companyRevenueWithTax // ignore: cast_nullable_to_non_nullable
                    as double,
        companyRevenueWithoutTax:
            null == companyRevenueWithoutTax
                ? _value.companyRevenueWithoutTax
                : companyRevenueWithoutTax // ignore: cast_nullable_to_non_nullable
                    as double,
        guideCommission:
            null == guideCommission
                ? _value.guideCommission
                : guideCommission // ignore: cast_nullable_to_non_nullable
                    as double,
        netRevenueWithTax:
            null == netRevenueWithTax
                ? _value.netRevenueWithTax
                : netRevenueWithTax // ignore: cast_nullable_to_non_nullable
                    as double,
        netRevenueWithoutTax:
            null == netRevenueWithoutTax
                ? _value.netRevenueWithoutTax
                : netRevenueWithoutTax // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl({
    this.id,
    @JsonKey(name: 'reservation_id') this.reservationId,
    required this.name,
    this.nationality,
    this.gender,
    this.age,
    @JsonKey(name: 'customer_note') this.customerNote,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'birth_date') this.birthDate,
    @JsonKey(name: 'is_booker') this.isBooker = false,
    this.booker,
    @JsonKey(name: 'customer_code') this.customerCode,
    @JsonKey(name: 'passport_name') this.passportName,
    this.phone,
    @JsonKey(name: 'acquisition_channel') this.acquisitionChannel,
    @JsonKey(name: 'communication_channel') this.communicationChannel,
    @JsonKey(name: 'channel_account') this.channelAccount,
    @JsonKey(name: 'purchase_code') this.purchaseCode,
    @JsonKey(name: 'total_payment_amount') this.totalPaymentAmount = 0.0,
    @JsonKey(name: 'company_revenue_with_tax') this.companyRevenueWithTax = 0.0,
    @JsonKey(name: 'company_revenue_without_tax')
    this.companyRevenueWithoutTax = 0.0,
    @JsonKey(name: 'guide_commission') this.guideCommission = 0.0,
    @JsonKey(name: 'net_revenue_with_tax') this.netRevenueWithTax = 0.0,
    @JsonKey(name: 'net_revenue_without_tax') this.netRevenueWithoutTax = 0.0,
  });

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'reservation_id')
  final String? reservationId;
  @override
  final String name;
  @override
  final String? nationality;
  @override
  final CustomerGender? gender;
  @override
  final double? age;
  @override
  @JsonKey(name: 'customer_note')
  final String? customerNote;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'is_booker')
  final bool isBooker;
  @override
  final String? booker;
  @override
  @JsonKey(name: 'customer_code')
  final String? customerCode;
  @override
  @JsonKey(name: 'passport_name')
  final String? passportName;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'acquisition_channel')
  final String? acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  final String? communicationChannel;
  @override
  @JsonKey(name: 'channel_account')
  final String? channelAccount;
  @override
  @JsonKey(name: 'purchase_code')
  final String? purchaseCode;
  @override
  @JsonKey(name: 'total_payment_amount')
  final double totalPaymentAmount;
  @override
  @JsonKey(name: 'company_revenue_with_tax')
  final double companyRevenueWithTax;
  @override
  @JsonKey(name: 'company_revenue_without_tax')
  final double companyRevenueWithoutTax;
  @override
  @JsonKey(name: 'guide_commission')
  final double guideCommission;
  @override
  @JsonKey(name: 'net_revenue_with_tax')
  final double netRevenueWithTax;
  @override
  @JsonKey(name: 'net_revenue_without_tax')
  final double netRevenueWithoutTax;

  @override
  String toString() {
    return 'Customer(id: $id, reservationId: $reservationId, name: $name, nationality: $nationality, gender: $gender, age: $age, customerNote: $customerNote, createdAt: $createdAt, birthDate: $birthDate, isBooker: $isBooker, booker: $booker, customerCode: $customerCode, passportName: $passportName, phone: $phone, acquisitionChannel: $acquisitionChannel, communicationChannel: $communicationChannel, channelAccount: $channelAccount, purchaseCode: $purchaseCode, totalPaymentAmount: $totalPaymentAmount, companyRevenueWithTax: $companyRevenueWithTax, companyRevenueWithoutTax: $companyRevenueWithoutTax, guideCommission: $guideCommission, netRevenueWithTax: $netRevenueWithTax, netRevenueWithoutTax: $netRevenueWithoutTax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.booker, booker) || other.booker == booker) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.passportName, passportName) ||
                other.passportName == passportName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.channelAccount, channelAccount) ||
                other.channelAccount == channelAccount) &&
            (identical(other.purchaseCode, purchaseCode) ||
                other.purchaseCode == purchaseCode) &&
            (identical(other.totalPaymentAmount, totalPaymentAmount) ||
                other.totalPaymentAmount == totalPaymentAmount) &&
            (identical(other.companyRevenueWithTax, companyRevenueWithTax) ||
                other.companyRevenueWithTax == companyRevenueWithTax) &&
            (identical(
                  other.companyRevenueWithoutTax,
                  companyRevenueWithoutTax,
                ) ||
                other.companyRevenueWithoutTax == companyRevenueWithoutTax) &&
            (identical(other.guideCommission, guideCommission) ||
                other.guideCommission == guideCommission) &&
            (identical(other.netRevenueWithTax, netRevenueWithTax) ||
                other.netRevenueWithTax == netRevenueWithTax) &&
            (identical(other.netRevenueWithoutTax, netRevenueWithoutTax) ||
                other.netRevenueWithoutTax == netRevenueWithoutTax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    reservationId,
    name,
    nationality,
    gender,
    age,
    customerNote,
    createdAt,
    birthDate,
    isBooker,
    booker,
    customerCode,
    passportName,
    phone,
    acquisitionChannel,
    communicationChannel,
    channelAccount,
    purchaseCode,
    totalPaymentAmount,
    companyRevenueWithTax,
    companyRevenueWithoutTax,
    guideCommission,
    netRevenueWithTax,
    netRevenueWithoutTax,
  ]);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(this);
  }
}

abstract class _Customer implements Customer {
  const factory _Customer({
    final String? id,
    @JsonKey(name: 'reservation_id') final String? reservationId,
    required final String name,
    final String? nationality,
    final CustomerGender? gender,
    final double? age,
    @JsonKey(name: 'customer_note') final String? customerNote,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'birth_date') final DateTime? birthDate,
    @JsonKey(name: 'is_booker') final bool isBooker,
    final String? booker,
    @JsonKey(name: 'customer_code') final String? customerCode,
    @JsonKey(name: 'passport_name') final String? passportName,
    final String? phone,
    @JsonKey(name: 'acquisition_channel') final String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') final String? communicationChannel,
    @JsonKey(name: 'channel_account') final String? channelAccount,
    @JsonKey(name: 'purchase_code') final String? purchaseCode,
    @JsonKey(name: 'total_payment_amount') final double totalPaymentAmount,
    @JsonKey(name: 'company_revenue_with_tax')
    final double companyRevenueWithTax,
    @JsonKey(name: 'company_revenue_without_tax')
    final double companyRevenueWithoutTax,
    @JsonKey(name: 'guide_commission') final double guideCommission,
    @JsonKey(name: 'net_revenue_with_tax') final double netRevenueWithTax,
    @JsonKey(name: 'net_revenue_without_tax') final double netRevenueWithoutTax,
  }) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'reservation_id')
  String? get reservationId;
  @override
  String get name;
  @override
  String? get nationality;
  @override
  CustomerGender? get gender;
  @override
  double? get age;
  @override
  @JsonKey(name: 'customer_note')
  String? get customerNote;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'is_booker')
  bool get isBooker;
  @override
  String? get booker;
  @override
  @JsonKey(name: 'customer_code')
  String? get customerCode;
  @override
  @JsonKey(name: 'passport_name')
  String? get passportName;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel;
  @override
  @JsonKey(name: 'channel_account')
  String? get channelAccount;
  @override
  @JsonKey(name: 'purchase_code')
  String? get purchaseCode;
  @override
  @JsonKey(name: 'total_payment_amount')
  double get totalPaymentAmount;
  @override
  @JsonKey(name: 'company_revenue_with_tax')
  double get companyRevenueWithTax;
  @override
  @JsonKey(name: 'company_revenue_without_tax')
  double get companyRevenueWithoutTax;
  @override
  @JsonKey(name: 'guide_commission')
  double get guideCommission;
  @override
  @JsonKey(name: 'net_revenue_with_tax')
  double get netRevenueWithTax;
  @override
  @JsonKey(name: 'net_revenue_without_tax')
  double get netRevenueWithoutTax;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerFilters _$CustomerFiltersFromJson(Map<String, dynamic> json) {
  return _CustomerFilters.fromJson(json);
}

/// @nodoc
mixin _$CustomerFilters {
  @JsonKey(name: 'search_query')
  String? get searchQuery => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_booker')
  bool? get isBooker => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_after')
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_before')
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_payment_amount')
  double? get minPaymentAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_payment_amount')
  double? get maxPaymentAmount => throw _privateConstructorUsedError;

  /// Serializes this CustomerFilters to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerFiltersCopyWith<CustomerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerFiltersCopyWith<$Res> {
  factory $CustomerFiltersCopyWith(
    CustomerFilters value,
    $Res Function(CustomerFilters) then,
  ) = _$CustomerFiltersCopyWithImpl<$Res, CustomerFilters>;
  @useResult
  $Res call({
    @JsonKey(name: 'search_query') String? searchQuery,
    CustomerGender? gender,
    String? nationality,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'is_booker') bool? isBooker,
    @JsonKey(name: 'created_after') DateTime? createdAfter,
    @JsonKey(name: 'created_before') DateTime? createdBefore,
    @JsonKey(name: 'min_payment_amount') double? minPaymentAmount,
    @JsonKey(name: 'max_payment_amount') double? maxPaymentAmount,
  });
}

/// @nodoc
class _$CustomerFiltersCopyWithImpl<$Res, $Val extends CustomerFilters>
    implements $CustomerFiltersCopyWith<$Res> {
  _$CustomerFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? gender = freezed,
    Object? nationality = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? isBooker = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? minPaymentAmount = freezed,
    Object? maxPaymentAmount = freezed,
  }) {
    return _then(
      _value.copyWith(
            searchQuery:
                freezed == searchQuery
                    ? _value.searchQuery
                    : searchQuery // ignore: cast_nullable_to_non_nullable
                        as String?,
            gender:
                freezed == gender
                    ? _value.gender
                    : gender // ignore: cast_nullable_to_non_nullable
                        as CustomerGender?,
            nationality:
                freezed == nationality
                    ? _value.nationality
                    : nationality // ignore: cast_nullable_to_non_nullable
                        as String?,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            isBooker:
                freezed == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool?,
            createdAfter:
                freezed == createdAfter
                    ? _value.createdAfter
                    : createdAfter // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdBefore:
                freezed == createdBefore
                    ? _value.createdBefore
                    : createdBefore // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            minPaymentAmount:
                freezed == minPaymentAmount
                    ? _value.minPaymentAmount
                    : minPaymentAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            maxPaymentAmount:
                freezed == maxPaymentAmount
                    ? _value.maxPaymentAmount
                    : maxPaymentAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerFiltersImplCopyWith<$Res>
    implements $CustomerFiltersCopyWith<$Res> {
  factory _$$CustomerFiltersImplCopyWith(
    _$CustomerFiltersImpl value,
    $Res Function(_$CustomerFiltersImpl) then,
  ) = __$$CustomerFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'search_query') String? searchQuery,
    CustomerGender? gender,
    String? nationality,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'is_booker') bool? isBooker,
    @JsonKey(name: 'created_after') DateTime? createdAfter,
    @JsonKey(name: 'created_before') DateTime? createdBefore,
    @JsonKey(name: 'min_payment_amount') double? minPaymentAmount,
    @JsonKey(name: 'max_payment_amount') double? maxPaymentAmount,
  });
}

/// @nodoc
class __$$CustomerFiltersImplCopyWithImpl<$Res>
    extends _$CustomerFiltersCopyWithImpl<$Res, _$CustomerFiltersImpl>
    implements _$$CustomerFiltersImplCopyWith<$Res> {
  __$$CustomerFiltersImplCopyWithImpl(
    _$CustomerFiltersImpl _value,
    $Res Function(_$CustomerFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? gender = freezed,
    Object? nationality = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? isBooker = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? minPaymentAmount = freezed,
    Object? maxPaymentAmount = freezed,
  }) {
    return _then(
      _$CustomerFiltersImpl(
        searchQuery:
            freezed == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                    as String?,
        gender:
            freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                    as CustomerGender?,
        nationality:
            freezed == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                    as String?,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        isBooker:
            freezed == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool?,
        createdAfter:
            freezed == createdAfter
                ? _value.createdAfter
                : createdAfter // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdBefore:
            freezed == createdBefore
                ? _value.createdBefore
                : createdBefore // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        minPaymentAmount:
            freezed == minPaymentAmount
                ? _value.minPaymentAmount
                : minPaymentAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        maxPaymentAmount:
            freezed == maxPaymentAmount
                ? _value.maxPaymentAmount
                : maxPaymentAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerFiltersImpl implements _CustomerFilters {
  const _$CustomerFiltersImpl({
    @JsonKey(name: 'search_query') this.searchQuery,
    this.gender,
    this.nationality,
    @JsonKey(name: 'acquisition_channel') this.acquisitionChannel,
    @JsonKey(name: 'communication_channel') this.communicationChannel,
    @JsonKey(name: 'is_booker') this.isBooker,
    @JsonKey(name: 'created_after') this.createdAfter,
    @JsonKey(name: 'created_before') this.createdBefore,
    @JsonKey(name: 'min_payment_amount') this.minPaymentAmount,
    @JsonKey(name: 'max_payment_amount') this.maxPaymentAmount,
  });

  factory _$CustomerFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerFiltersImplFromJson(json);

  @override
  @JsonKey(name: 'search_query')
  final String? searchQuery;
  @override
  final CustomerGender? gender;
  @override
  final String? nationality;
  @override
  @JsonKey(name: 'acquisition_channel')
  final String? acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  final String? communicationChannel;
  @override
  @JsonKey(name: 'is_booker')
  final bool? isBooker;
  @override
  @JsonKey(name: 'created_after')
  final DateTime? createdAfter;
  @override
  @JsonKey(name: 'created_before')
  final DateTime? createdBefore;
  @override
  @JsonKey(name: 'min_payment_amount')
  final double? minPaymentAmount;
  @override
  @JsonKey(name: 'max_payment_amount')
  final double? maxPaymentAmount;

  @override
  String toString() {
    return 'CustomerFilters(searchQuery: $searchQuery, gender: $gender, nationality: $nationality, acquisitionChannel: $acquisitionChannel, communicationChannel: $communicationChannel, isBooker: $isBooker, createdAfter: $createdAfter, createdBefore: $createdBefore, minPaymentAmount: $minPaymentAmount, maxPaymentAmount: $maxPaymentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerFiltersImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.minPaymentAmount, minPaymentAmount) ||
                other.minPaymentAmount == minPaymentAmount) &&
            (identical(other.maxPaymentAmount, maxPaymentAmount) ||
                other.maxPaymentAmount == maxPaymentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    searchQuery,
    gender,
    nationality,
    acquisitionChannel,
    communicationChannel,
    isBooker,
    createdAfter,
    createdBefore,
    minPaymentAmount,
    maxPaymentAmount,
  );

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerFiltersImplCopyWith<_$CustomerFiltersImpl> get copyWith =>
      __$$CustomerFiltersImplCopyWithImpl<_$CustomerFiltersImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerFiltersImplToJson(this);
  }
}

abstract class _CustomerFilters implements CustomerFilters {
  const factory _CustomerFilters({
    @JsonKey(name: 'search_query') final String? searchQuery,
    final CustomerGender? gender,
    final String? nationality,
    @JsonKey(name: 'acquisition_channel') final String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') final String? communicationChannel,
    @JsonKey(name: 'is_booker') final bool? isBooker,
    @JsonKey(name: 'created_after') final DateTime? createdAfter,
    @JsonKey(name: 'created_before') final DateTime? createdBefore,
    @JsonKey(name: 'min_payment_amount') final double? minPaymentAmount,
    @JsonKey(name: 'max_payment_amount') final double? maxPaymentAmount,
  }) = _$CustomerFiltersImpl;

  factory _CustomerFilters.fromJson(Map<String, dynamic> json) =
      _$CustomerFiltersImpl.fromJson;

  @override
  @JsonKey(name: 'search_query')
  String? get searchQuery;
  @override
  CustomerGender? get gender;
  @override
  String? get nationality;
  @override
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel;
  @override
  @JsonKey(name: 'is_booker')
  bool? get isBooker;
  @override
  @JsonKey(name: 'created_after')
  DateTime? get createdAfter;
  @override
  @JsonKey(name: 'created_before')
  DateTime? get createdBefore;
  @override
  @JsonKey(name: 'min_payment_amount')
  double? get minPaymentAmount;
  @override
  @JsonKey(name: 'max_payment_amount')
  double? get maxPaymentAmount;

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerFiltersImplCopyWith<_$CustomerFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerInput _$CustomerInputFromJson(Map<String, dynamic> json) {
  return _CustomerInput.fromJson(json);
}

/// @nodoc
mixin _$CustomerInput {
  @JsonKey(name: 'reservation_id')
  String? get reservationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  double? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_note')
  String? get customerNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_booker')
  bool get isBooker => throw _privateConstructorUsedError;
  String? get booker => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_code')
  String? get customerCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'passport_name')
  String? get passportName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel_account')
  String? get channelAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_code')
  String? get purchaseCode => throw _privateConstructorUsedError;

  /// Serializes this CustomerInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInputCopyWith<CustomerInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInputCopyWith<$Res> {
  factory $CustomerInputCopyWith(
    CustomerInput value,
    $Res Function(CustomerInput) then,
  ) = _$CustomerInputCopyWithImpl<$Res, CustomerInput>;
  @useResult
  $Res call({
    @JsonKey(name: 'reservation_id') String? reservationId,
    String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
  });
}

/// @nodoc
class _$CustomerInputCopyWithImpl<$Res, $Val extends CustomerInput>
    implements $CustomerInputCopyWith<$Res> {
  _$CustomerInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = freezed,
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? customerNote = freezed,
    Object? birthDate = freezed,
    Object? isBooker = null,
    Object? booker = freezed,
    Object? customerCode = freezed,
    Object? passportName = freezed,
    Object? phone = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? purchaseCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            reservationId:
                freezed == reservationId
                    ? _value.reservationId
                    : reservationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            nationality:
                freezed == nationality
                    ? _value.nationality
                    : nationality // ignore: cast_nullable_to_non_nullable
                        as String?,
            gender:
                freezed == gender
                    ? _value.gender
                    : gender // ignore: cast_nullable_to_non_nullable
                        as CustomerGender?,
            age:
                freezed == age
                    ? _value.age
                    : age // ignore: cast_nullable_to_non_nullable
                        as double?,
            customerNote:
                freezed == customerNote
                    ? _value.customerNote
                    : customerNote // ignore: cast_nullable_to_non_nullable
                        as String?,
            birthDate:
                freezed == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isBooker:
                null == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool,
            booker:
                freezed == booker
                    ? _value.booker
                    : booker // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerCode:
                freezed == customerCode
                    ? _value.customerCode
                    : customerCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportName:
                freezed == passportName
                    ? _value.passportName
                    : passportName // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            channelAccount:
                freezed == channelAccount
                    ? _value.channelAccount
                    : channelAccount // ignore: cast_nullable_to_non_nullable
                        as String?,
            purchaseCode:
                freezed == purchaseCode
                    ? _value.purchaseCode
                    : purchaseCode // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInputImplCopyWith<$Res>
    implements $CustomerInputCopyWith<$Res> {
  factory _$$CustomerInputImplCopyWith(
    _$CustomerInputImpl value,
    $Res Function(_$CustomerInputImpl) then,
  ) = __$$CustomerInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'reservation_id') String? reservationId,
    String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
  });
}

/// @nodoc
class __$$CustomerInputImplCopyWithImpl<$Res>
    extends _$CustomerInputCopyWithImpl<$Res, _$CustomerInputImpl>
    implements _$$CustomerInputImplCopyWith<$Res> {
  __$$CustomerInputImplCopyWithImpl(
    _$CustomerInputImpl _value,
    $Res Function(_$CustomerInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = freezed,
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? customerNote = freezed,
    Object? birthDate = freezed,
    Object? isBooker = null,
    Object? booker = freezed,
    Object? customerCode = freezed,
    Object? passportName = freezed,
    Object? phone = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? purchaseCode = freezed,
  }) {
    return _then(
      _$CustomerInputImpl(
        reservationId:
            freezed == reservationId
                ? _value.reservationId
                : reservationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        nationality:
            freezed == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                    as String?,
        gender:
            freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                    as CustomerGender?,
        age:
            freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as double?,
        customerNote:
            freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                    as String?,
        birthDate:
            freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isBooker:
            null == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool,
        booker:
            freezed == booker
                ? _value.booker
                : booker // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerCode:
            freezed == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportName:
            freezed == passportName
                ? _value.passportName
                : passportName // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        channelAccount:
            freezed == channelAccount
                ? _value.channelAccount
                : channelAccount // ignore: cast_nullable_to_non_nullable
                    as String?,
        purchaseCode:
            freezed == purchaseCode
                ? _value.purchaseCode
                : purchaseCode // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInputImpl implements _CustomerInput {
  const _$CustomerInputImpl({
    @JsonKey(name: 'reservation_id') this.reservationId,
    required this.name,
    this.nationality,
    this.gender,
    this.age,
    @JsonKey(name: 'customer_note') this.customerNote,
    @JsonKey(name: 'birth_date') this.birthDate,
    @JsonKey(name: 'is_booker') this.isBooker = false,
    this.booker,
    @JsonKey(name: 'customer_code') this.customerCode,
    @JsonKey(name: 'passport_name') this.passportName,
    this.phone,
    @JsonKey(name: 'acquisition_channel') this.acquisitionChannel,
    @JsonKey(name: 'communication_channel') this.communicationChannel,
    @JsonKey(name: 'channel_account') this.channelAccount,
    @JsonKey(name: 'purchase_code') this.purchaseCode,
  });

  factory _$CustomerInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInputImplFromJson(json);

  @override
  @JsonKey(name: 'reservation_id')
  final String? reservationId;
  @override
  final String name;
  @override
  final String? nationality;
  @override
  final CustomerGender? gender;
  @override
  final double? age;
  @override
  @JsonKey(name: 'customer_note')
  final String? customerNote;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'is_booker')
  final bool isBooker;
  @override
  final String? booker;
  @override
  @JsonKey(name: 'customer_code')
  final String? customerCode;
  @override
  @JsonKey(name: 'passport_name')
  final String? passportName;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'acquisition_channel')
  final String? acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  final String? communicationChannel;
  @override
  @JsonKey(name: 'channel_account')
  final String? channelAccount;
  @override
  @JsonKey(name: 'purchase_code')
  final String? purchaseCode;

  @override
  String toString() {
    return 'CustomerInput(reservationId: $reservationId, name: $name, nationality: $nationality, gender: $gender, age: $age, customerNote: $customerNote, birthDate: $birthDate, isBooker: $isBooker, booker: $booker, customerCode: $customerCode, passportName: $passportName, phone: $phone, acquisitionChannel: $acquisitionChannel, communicationChannel: $communicationChannel, channelAccount: $channelAccount, purchaseCode: $purchaseCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInputImpl &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.booker, booker) || other.booker == booker) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.passportName, passportName) ||
                other.passportName == passportName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.channelAccount, channelAccount) ||
                other.channelAccount == channelAccount) &&
            (identical(other.purchaseCode, purchaseCode) ||
                other.purchaseCode == purchaseCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    reservationId,
    name,
    nationality,
    gender,
    age,
    customerNote,
    birthDate,
    isBooker,
    booker,
    customerCode,
    passportName,
    phone,
    acquisitionChannel,
    communicationChannel,
    channelAccount,
    purchaseCode,
  );

  /// Create a copy of CustomerInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInputImplCopyWith<_$CustomerInputImpl> get copyWith =>
      __$$CustomerInputImplCopyWithImpl<_$CustomerInputImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInputImplToJson(this);
  }
}

abstract class _CustomerInput implements CustomerInput {
  const factory _CustomerInput({
    @JsonKey(name: 'reservation_id') final String? reservationId,
    required final String name,
    final String? nationality,
    final CustomerGender? gender,
    final double? age,
    @JsonKey(name: 'customer_note') final String? customerNote,
    @JsonKey(name: 'birth_date') final DateTime? birthDate,
    @JsonKey(name: 'is_booker') final bool isBooker,
    final String? booker,
    @JsonKey(name: 'customer_code') final String? customerCode,
    @JsonKey(name: 'passport_name') final String? passportName,
    final String? phone,
    @JsonKey(name: 'acquisition_channel') final String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') final String? communicationChannel,
    @JsonKey(name: 'channel_account') final String? channelAccount,
    @JsonKey(name: 'purchase_code') final String? purchaseCode,
  }) = _$CustomerInputImpl;

  factory _CustomerInput.fromJson(Map<String, dynamic> json) =
      _$CustomerInputImpl.fromJson;

  @override
  @JsonKey(name: 'reservation_id')
  String? get reservationId;
  @override
  String get name;
  @override
  String? get nationality;
  @override
  CustomerGender? get gender;
  @override
  double? get age;
  @override
  @JsonKey(name: 'customer_note')
  String? get customerNote;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'is_booker')
  bool get isBooker;
  @override
  String? get booker;
  @override
  @JsonKey(name: 'customer_code')
  String? get customerCode;
  @override
  @JsonKey(name: 'passport_name')
  String? get passportName;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'acquisition_channel')
  String? get acquisitionChannel;
  @override
  @JsonKey(name: 'communication_channel')
  String? get communicationChannel;
  @override
  @JsonKey(name: 'channel_account')
  String? get channelAccount;
  @override
  @JsonKey(name: 'purchase_code')
  String? get purchaseCode;

  /// Create a copy of CustomerInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInputImplCopyWith<_$CustomerInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerStats _$CustomerStatsFromJson(Map<String, dynamic> json) {
  return _CustomerStats.fromJson(json);
}

/// @nodoc
mixin _$CustomerStats {
  @JsonKey(name: 'total_customers')
  int get totalCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_customers')
  int get newCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'returning_customers')
  int get returningCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_revenue_per_customer')
  double get averageRevenuePerCustomer => throw _privateConstructorUsedError;
  @JsonKey(name: 'customers_by_nationality')
  Map<String, int> get customersByNationality =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'customers_by_channel')
  Map<String, int> get customersByChannel => throw _privateConstructorUsedError;
  @JsonKey(name: 'customers_by_gender')
  Map<CustomerGender, int> get customersByGender =>
      throw _privateConstructorUsedError;

  /// Serializes this CustomerStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerStatsCopyWith<CustomerStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerStatsCopyWith<$Res> {
  factory $CustomerStatsCopyWith(
    CustomerStats value,
    $Res Function(CustomerStats) then,
  ) = _$CustomerStatsCopyWithImpl<$Res, CustomerStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_customers') int totalCustomers,
    @JsonKey(name: 'new_customers') int newCustomers,
    @JsonKey(name: 'returning_customers') int returningCustomers,
    @JsonKey(name: 'total_revenue') double totalRevenue,
    @JsonKey(name: 'average_revenue_per_customer')
    double averageRevenuePerCustomer,
    @JsonKey(name: 'customers_by_nationality')
    Map<String, int> customersByNationality,
    @JsonKey(name: 'customers_by_channel') Map<String, int> customersByChannel,
    @JsonKey(name: 'customers_by_gender')
    Map<CustomerGender, int> customersByGender,
  });
}

/// @nodoc
class _$CustomerStatsCopyWithImpl<$Res, $Val extends CustomerStats>
    implements $CustomerStatsCopyWith<$Res> {
  _$CustomerStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? newCustomers = null,
    Object? returningCustomers = null,
    Object? totalRevenue = null,
    Object? averageRevenuePerCustomer = null,
    Object? customersByNationality = null,
    Object? customersByChannel = null,
    Object? customersByGender = null,
  }) {
    return _then(
      _value.copyWith(
            totalCustomers:
                null == totalCustomers
                    ? _value.totalCustomers
                    : totalCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            newCustomers:
                null == newCustomers
                    ? _value.newCustomers
                    : newCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            returningCustomers:
                null == returningCustomers
                    ? _value.returningCustomers
                    : returningCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            totalRevenue:
                null == totalRevenue
                    ? _value.totalRevenue
                    : totalRevenue // ignore: cast_nullable_to_non_nullable
                        as double,
            averageRevenuePerCustomer:
                null == averageRevenuePerCustomer
                    ? _value.averageRevenuePerCustomer
                    : averageRevenuePerCustomer // ignore: cast_nullable_to_non_nullable
                        as double,
            customersByNationality:
                null == customersByNationality
                    ? _value.customersByNationality
                    : customersByNationality // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            customersByChannel:
                null == customersByChannel
                    ? _value.customersByChannel
                    : customersByChannel // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            customersByGender:
                null == customersByGender
                    ? _value.customersByGender
                    : customersByGender // ignore: cast_nullable_to_non_nullable
                        as Map<CustomerGender, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerStatsImplCopyWith<$Res>
    implements $CustomerStatsCopyWith<$Res> {
  factory _$$CustomerStatsImplCopyWith(
    _$CustomerStatsImpl value,
    $Res Function(_$CustomerStatsImpl) then,
  ) = __$$CustomerStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_customers') int totalCustomers,
    @JsonKey(name: 'new_customers') int newCustomers,
    @JsonKey(name: 'returning_customers') int returningCustomers,
    @JsonKey(name: 'total_revenue') double totalRevenue,
    @JsonKey(name: 'average_revenue_per_customer')
    double averageRevenuePerCustomer,
    @JsonKey(name: 'customers_by_nationality')
    Map<String, int> customersByNationality,
    @JsonKey(name: 'customers_by_channel') Map<String, int> customersByChannel,
    @JsonKey(name: 'customers_by_gender')
    Map<CustomerGender, int> customersByGender,
  });
}

/// @nodoc
class __$$CustomerStatsImplCopyWithImpl<$Res>
    extends _$CustomerStatsCopyWithImpl<$Res, _$CustomerStatsImpl>
    implements _$$CustomerStatsImplCopyWith<$Res> {
  __$$CustomerStatsImplCopyWithImpl(
    _$CustomerStatsImpl _value,
    $Res Function(_$CustomerStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? newCustomers = null,
    Object? returningCustomers = null,
    Object? totalRevenue = null,
    Object? averageRevenuePerCustomer = null,
    Object? customersByNationality = null,
    Object? customersByChannel = null,
    Object? customersByGender = null,
  }) {
    return _then(
      _$CustomerStatsImpl(
        totalCustomers:
            null == totalCustomers
                ? _value.totalCustomers
                : totalCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        newCustomers:
            null == newCustomers
                ? _value.newCustomers
                : newCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        returningCustomers:
            null == returningCustomers
                ? _value.returningCustomers
                : returningCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        totalRevenue:
            null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                    as double,
        averageRevenuePerCustomer:
            null == averageRevenuePerCustomer
                ? _value.averageRevenuePerCustomer
                : averageRevenuePerCustomer // ignore: cast_nullable_to_non_nullable
                    as double,
        customersByNationality:
            null == customersByNationality
                ? _value._customersByNationality
                : customersByNationality // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        customersByChannel:
            null == customersByChannel
                ? _value._customersByChannel
                : customersByChannel // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        customersByGender:
            null == customersByGender
                ? _value._customersByGender
                : customersByGender // ignore: cast_nullable_to_non_nullable
                    as Map<CustomerGender, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerStatsImpl implements _CustomerStats {
  const _$CustomerStatsImpl({
    @JsonKey(name: 'total_customers') required this.totalCustomers,
    @JsonKey(name: 'new_customers') required this.newCustomers,
    @JsonKey(name: 'returning_customers') required this.returningCustomers,
    @JsonKey(name: 'total_revenue') required this.totalRevenue,
    @JsonKey(name: 'average_revenue_per_customer')
    required this.averageRevenuePerCustomer,
    @JsonKey(name: 'customers_by_nationality')
    required final Map<String, int> customersByNationality,
    @JsonKey(name: 'customers_by_channel')
    required final Map<String, int> customersByChannel,
    @JsonKey(name: 'customers_by_gender')
    required final Map<CustomerGender, int> customersByGender,
  }) : _customersByNationality = customersByNationality,
       _customersByChannel = customersByChannel,
       _customersByGender = customersByGender;

  factory _$CustomerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_customers')
  final int totalCustomers;
  @override
  @JsonKey(name: 'new_customers')
  final int newCustomers;
  @override
  @JsonKey(name: 'returning_customers')
  final int returningCustomers;
  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'average_revenue_per_customer')
  final double averageRevenuePerCustomer;
  final Map<String, int> _customersByNationality;
  @override
  @JsonKey(name: 'customers_by_nationality')
  Map<String, int> get customersByNationality {
    if (_customersByNationality is EqualUnmodifiableMapView)
      return _customersByNationality;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customersByNationality);
  }

  final Map<String, int> _customersByChannel;
  @override
  @JsonKey(name: 'customers_by_channel')
  Map<String, int> get customersByChannel {
    if (_customersByChannel is EqualUnmodifiableMapView)
      return _customersByChannel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customersByChannel);
  }

  final Map<CustomerGender, int> _customersByGender;
  @override
  @JsonKey(name: 'customers_by_gender')
  Map<CustomerGender, int> get customersByGender {
    if (_customersByGender is EqualUnmodifiableMapView)
      return _customersByGender;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customersByGender);
  }

  @override
  String toString() {
    return 'CustomerStats(totalCustomers: $totalCustomers, newCustomers: $newCustomers, returningCustomers: $returningCustomers, totalRevenue: $totalRevenue, averageRevenuePerCustomer: $averageRevenuePerCustomer, customersByNationality: $customersByNationality, customersByChannel: $customersByChannel, customersByGender: $customersByGender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerStatsImpl &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.newCustomers, newCustomers) ||
                other.newCustomers == newCustomers) &&
            (identical(other.returningCustomers, returningCustomers) ||
                other.returningCustomers == returningCustomers) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(
                  other.averageRevenuePerCustomer,
                  averageRevenuePerCustomer,
                ) ||
                other.averageRevenuePerCustomer == averageRevenuePerCustomer) &&
            const DeepCollectionEquality().equals(
              other._customersByNationality,
              _customersByNationality,
            ) &&
            const DeepCollectionEquality().equals(
              other._customersByChannel,
              _customersByChannel,
            ) &&
            const DeepCollectionEquality().equals(
              other._customersByGender,
              _customersByGender,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCustomers,
    newCustomers,
    returningCustomers,
    totalRevenue,
    averageRevenuePerCustomer,
    const DeepCollectionEquality().hash(_customersByNationality),
    const DeepCollectionEquality().hash(_customersByChannel),
    const DeepCollectionEquality().hash(_customersByGender),
  );

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerStatsImplCopyWith<_$CustomerStatsImpl> get copyWith =>
      __$$CustomerStatsImplCopyWithImpl<_$CustomerStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerStatsImplToJson(this);
  }
}

abstract class _CustomerStats implements CustomerStats {
  const factory _CustomerStats({
    @JsonKey(name: 'total_customers') required final int totalCustomers,
    @JsonKey(name: 'new_customers') required final int newCustomers,
    @JsonKey(name: 'returning_customers') required final int returningCustomers,
    @JsonKey(name: 'total_revenue') required final double totalRevenue,
    @JsonKey(name: 'average_revenue_per_customer')
    required final double averageRevenuePerCustomer,
    @JsonKey(name: 'customers_by_nationality')
    required final Map<String, int> customersByNationality,
    @JsonKey(name: 'customers_by_channel')
    required final Map<String, int> customersByChannel,
    @JsonKey(name: 'customers_by_gender')
    required final Map<CustomerGender, int> customersByGender,
  }) = _$CustomerStatsImpl;

  factory _CustomerStats.fromJson(Map<String, dynamic> json) =
      _$CustomerStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_customers')
  int get totalCustomers;
  @override
  @JsonKey(name: 'new_customers')
  int get newCustomers;
  @override
  @JsonKey(name: 'returning_customers')
  int get returningCustomers;
  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'average_revenue_per_customer')
  double get averageRevenuePerCustomer;
  @override
  @JsonKey(name: 'customers_by_nationality')
  Map<String, int> get customersByNationality;
  @override
  @JsonKey(name: 'customers_by_channel')
  Map<String, int> get customersByChannel;
  @override
  @JsonKey(name: 'customers_by_gender')
  Map<CustomerGender, int> get customersByGender;

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerStatsImplCopyWith<_$CustomerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
