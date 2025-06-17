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

CustomerFilters _$CustomerFiltersFromJson(Map<String, dynamic> json) {
  return _CustomerFilters.fromJson(json);
}

/// @nodoc
mixin _$CustomerFilters {
  String? get name => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  bool? get isBooker => throw _privateConstructorUsedError;
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  CommunicationChannel? get communicationChannel =>
      throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  double? get minPaymentAmount => throw _privateConstructorUsedError;
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
    String? name,
    String? nationality,
    CustomerGender? gender,
    bool? isBooker,
    String? acquisitionChannel,
    CommunicationChannel? communicationChannel,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String? searchQuery,
    double? minPaymentAmount,
    double? maxPaymentAmount,
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
    Object? name = freezed,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? isBooker = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? searchQuery = freezed,
    Object? minPaymentAmount = freezed,
    Object? maxPaymentAmount = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            isBooker:
                freezed == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool?,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as CommunicationChannel?,
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
            searchQuery:
                freezed == searchQuery
                    ? _value.searchQuery
                    : searchQuery // ignore: cast_nullable_to_non_nullable
                        as String?,
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
    String? name,
    String? nationality,
    CustomerGender? gender,
    bool? isBooker,
    String? acquisitionChannel,
    CommunicationChannel? communicationChannel,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String? searchQuery,
    double? minPaymentAmount,
    double? maxPaymentAmount,
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
    Object? name = freezed,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? isBooker = freezed,
    Object? acquisitionChannel = freezed,
    Object? communicationChannel = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? searchQuery = freezed,
    Object? minPaymentAmount = freezed,
    Object? maxPaymentAmount = freezed,
  }) {
    return _then(
      _$CustomerFiltersImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        isBooker:
            freezed == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool?,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as CommunicationChannel?,
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
        searchQuery:
            freezed == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                    as String?,
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
    this.name,
    this.nationality,
    this.gender,
    this.isBooker,
    this.acquisitionChannel,
    this.communicationChannel,
    this.createdAfter,
    this.createdBefore,
    this.searchQuery,
    this.minPaymentAmount,
    this.maxPaymentAmount,
  });

  factory _$CustomerFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerFiltersImplFromJson(json);

  @override
  final String? name;
  @override
  final String? nationality;
  @override
  final CustomerGender? gender;
  @override
  final bool? isBooker;
  @override
  final String? acquisitionChannel;
  @override
  final CommunicationChannel? communicationChannel;
  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  final String? searchQuery;
  @override
  final double? minPaymentAmount;
  @override
  final double? maxPaymentAmount;

  @override
  String toString() {
    return 'CustomerFilters(name: $name, nationality: $nationality, gender: $gender, isBooker: $isBooker, acquisitionChannel: $acquisitionChannel, communicationChannel: $communicationChannel, createdAfter: $createdAfter, createdBefore: $createdBefore, searchQuery: $searchQuery, minPaymentAmount: $minPaymentAmount, maxPaymentAmount: $maxPaymentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerFiltersImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.minPaymentAmount, minPaymentAmount) ||
                other.minPaymentAmount == minPaymentAmount) &&
            (identical(other.maxPaymentAmount, maxPaymentAmount) ||
                other.maxPaymentAmount == maxPaymentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    nationality,
    gender,
    isBooker,
    acquisitionChannel,
    communicationChannel,
    createdAfter,
    createdBefore,
    searchQuery,
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
    final String? name,
    final String? nationality,
    final CustomerGender? gender,
    final bool? isBooker,
    final String? acquisitionChannel,
    final CommunicationChannel? communicationChannel,
    final DateTime? createdAfter,
    final DateTime? createdBefore,
    final String? searchQuery,
    final double? minPaymentAmount,
    final double? maxPaymentAmount,
  }) = _$CustomerFiltersImpl;

  factory _CustomerFilters.fromJson(Map<String, dynamic> json) =
      _$CustomerFiltersImpl.fromJson;

  @override
  String? get name;
  @override
  String? get nationality;
  @override
  CustomerGender? get gender;
  @override
  bool? get isBooker;
  @override
  String? get acquisitionChannel;
  @override
  CommunicationChannel? get communicationChannel;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  String? get searchQuery;
  @override
  double? get minPaymentAmount;
  @override
  double? get maxPaymentAmount;

  /// Create a copy of CustomerFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerFiltersImplCopyWith<_$CustomerFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  double? get age => throw _privateConstructorUsedError;
  String? get passportName => throw _privateConstructorUsedError;
  String? get passportLastName => throw _privateConstructorUsedError;
  String? get passportFirstName => throw _privateConstructorUsedError;
  bool get isBooker => throw _privateConstructorUsedError;
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  String? get booker => throw _privateConstructorUsedError;
  String? get customerNote => throw _privateConstructorUsedError;
  CommunicationChannel? get communicationChannel =>
      throw _privateConstructorUsedError;
  String? get channelAccount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
    String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? passportName = freezed,
    Object? passportLastName = freezed,
    Object? passportFirstName = freezed,
    Object? isBooker = null,
    Object? acquisitionChannel = freezed,
    Object? booker = freezed,
    Object? customerNote = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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
            birthDate:
                freezed == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            age:
                freezed == age
                    ? _value.age
                    : age // ignore: cast_nullable_to_non_nullable
                        as double?,
            passportName:
                freezed == passportName
                    ? _value.passportName
                    : passportName // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportLastName:
                freezed == passportLastName
                    ? _value.passportLastName
                    : passportLastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportFirstName:
                freezed == passportFirstName
                    ? _value.passportFirstName
                    : passportFirstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            isBooker:
                null == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            booker:
                freezed == booker
                    ? _value.booker
                    : booker // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerNote:
                freezed == customerNote
                    ? _value.customerNote
                    : customerNote // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as CommunicationChannel?,
            channelAccount:
                freezed == channelAccount
                    ? _value.channelAccount
                    : channelAccount // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
    String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? passportName = freezed,
    Object? passportLastName = freezed,
    Object? passportFirstName = freezed,
    Object? isBooker = null,
    Object? acquisitionChannel = freezed,
    Object? booker = freezed,
    Object? customerNote = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CustomerImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
        birthDate:
            freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        age:
            freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as double?,
        passportName:
            freezed == passportName
                ? _value.passportName
                : passportName // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportLastName:
            freezed == passportLastName
                ? _value.passportLastName
                : passportLastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportFirstName:
            freezed == passportFirstName
                ? _value.passportFirstName
                : passportFirstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        isBooker:
            null == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        booker:
            freezed == booker
                ? _value.booker
                : booker // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerNote:
            freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as CommunicationChannel?,
        channelAccount:
            freezed == channelAccount
                ? _value.channelAccount
                : channelAccount // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl({
    this.id,
    required this.name,
    this.nationality,
    this.gender,
    this.birthDate,
    this.age,
    this.passportName,
    this.passportLastName,
    this.passportFirstName,
    this.isBooker = true,
    this.acquisitionChannel,
    this.booker,
    this.customerNote,
    this.communicationChannel,
    this.channelAccount,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String? nationality;
  @override
  final CustomerGender? gender;
  @override
  final DateTime? birthDate;
  @override
  final double? age;
  @override
  final String? passportName;
  @override
  final String? passportLastName;
  @override
  final String? passportFirstName;
  @override
  @JsonKey()
  final bool isBooker;
  @override
  final String? acquisitionChannel;
  @override
  final String? booker;
  @override
  final String? customerNote;
  @override
  final CommunicationChannel? communicationChannel;
  @override
  final String? channelAccount;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, nationality: $nationality, gender: $gender, birthDate: $birthDate, age: $age, passportName: $passportName, passportLastName: $passportLastName, passportFirstName: $passportFirstName, isBooker: $isBooker, acquisitionChannel: $acquisitionChannel, booker: $booker, customerNote: $customerNote, communicationChannel: $communicationChannel, channelAccount: $channelAccount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.passportName, passportName) ||
                other.passportName == passportName) &&
            (identical(other.passportLastName, passportLastName) ||
                other.passportLastName == passportLastName) &&
            (identical(other.passportFirstName, passportFirstName) ||
                other.passportFirstName == passportFirstName) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.booker, booker) || other.booker == booker) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.channelAccount, channelAccount) ||
                other.channelAccount == channelAccount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nationality,
    gender,
    birthDate,
    age,
    passportName,
    passportLastName,
    passportFirstName,
    isBooker,
    acquisitionChannel,
    booker,
    customerNote,
    communicationChannel,
    channelAccount,
    createdAt,
    updatedAt,
  );

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
    required final String name,
    final String? nationality,
    final CustomerGender? gender,
    final DateTime? birthDate,
    final double? age,
    final String? passportName,
    final String? passportLastName,
    final String? passportFirstName,
    final bool isBooker,
    final String? acquisitionChannel,
    final String? booker,
    final String? customerNote,
    final CommunicationChannel? communicationChannel,
    final String? channelAccount,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  String? get nationality;
  @override
  CustomerGender? get gender;
  @override
  DateTime? get birthDate;
  @override
  double? get age;
  @override
  String? get passportName;
  @override
  String? get passportLastName;
  @override
  String? get passportFirstName;
  @override
  bool get isBooker;
  @override
  String? get acquisitionChannel;
  @override
  String? get booker;
  @override
  String? get customerNote;
  @override
  CommunicationChannel? get communicationChannel;
  @override
  String? get channelAccount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerInput _$CustomerInputFromJson(Map<String, dynamic> json) {
  return _CustomerInput.fromJson(json);
}

/// @nodoc
mixin _$CustomerInput {
  String get name => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  CustomerGender? get gender => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  double? get age => throw _privateConstructorUsedError;
  String? get passportName => throw _privateConstructorUsedError;
  String? get passportLastName => throw _privateConstructorUsedError;
  String? get passportFirstName => throw _privateConstructorUsedError;
  bool get isBooker => throw _privateConstructorUsedError;
  String? get acquisitionChannel => throw _privateConstructorUsedError;
  String? get booker => throw _privateConstructorUsedError;
  String? get customerNote => throw _privateConstructorUsedError;
  CommunicationChannel? get communicationChannel =>
      throw _privateConstructorUsedError;
  String? get channelAccount => throw _privateConstructorUsedError;
  String? get customerCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get purchaseCode => throw _privateConstructorUsedError;
  String? get reservationId => throw _privateConstructorUsedError;

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
    String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    String? customerCode,
    String? phone,
    String? purchaseCode,
    String? reservationId,
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
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? passportName = freezed,
    Object? passportLastName = freezed,
    Object? passportFirstName = freezed,
    Object? isBooker = null,
    Object? acquisitionChannel = freezed,
    Object? booker = freezed,
    Object? customerNote = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? customerCode = freezed,
    Object? phone = freezed,
    Object? purchaseCode = freezed,
    Object? reservationId = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            birthDate:
                freezed == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            age:
                freezed == age
                    ? _value.age
                    : age // ignore: cast_nullable_to_non_nullable
                        as double?,
            passportName:
                freezed == passportName
                    ? _value.passportName
                    : passportName // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportLastName:
                freezed == passportLastName
                    ? _value.passportLastName
                    : passportLastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            passportFirstName:
                freezed == passportFirstName
                    ? _value.passportFirstName
                    : passportFirstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            isBooker:
                null == isBooker
                    ? _value.isBooker
                    : isBooker // ignore: cast_nullable_to_non_nullable
                        as bool,
            acquisitionChannel:
                freezed == acquisitionChannel
                    ? _value.acquisitionChannel
                    : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                        as String?,
            booker:
                freezed == booker
                    ? _value.booker
                    : booker // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerNote:
                freezed == customerNote
                    ? _value.customerNote
                    : customerNote // ignore: cast_nullable_to_non_nullable
                        as String?,
            communicationChannel:
                freezed == communicationChannel
                    ? _value.communicationChannel
                    : communicationChannel // ignore: cast_nullable_to_non_nullable
                        as CommunicationChannel?,
            channelAccount:
                freezed == channelAccount
                    ? _value.channelAccount
                    : channelAccount // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerCode:
                freezed == customerCode
                    ? _value.customerCode
                    : customerCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            purchaseCode:
                freezed == purchaseCode
                    ? _value.purchaseCode
                    : purchaseCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationId:
                freezed == reservationId
                    ? _value.reservationId
                    : reservationId // ignore: cast_nullable_to_non_nullable
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
    String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    String? customerCode,
    String? phone,
    String? purchaseCode,
    String? reservationId,
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
    Object? name = null,
    Object? nationality = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? passportName = freezed,
    Object? passportLastName = freezed,
    Object? passportFirstName = freezed,
    Object? isBooker = null,
    Object? acquisitionChannel = freezed,
    Object? booker = freezed,
    Object? customerNote = freezed,
    Object? communicationChannel = freezed,
    Object? channelAccount = freezed,
    Object? customerCode = freezed,
    Object? phone = freezed,
    Object? purchaseCode = freezed,
    Object? reservationId = freezed,
  }) {
    return _then(
      _$CustomerInputImpl(
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
        birthDate:
            freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        age:
            freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as double?,
        passportName:
            freezed == passportName
                ? _value.passportName
                : passportName // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportLastName:
            freezed == passportLastName
                ? _value.passportLastName
                : passportLastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        passportFirstName:
            freezed == passportFirstName
                ? _value.passportFirstName
                : passportFirstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        isBooker:
            null == isBooker
                ? _value.isBooker
                : isBooker // ignore: cast_nullable_to_non_nullable
                    as bool,
        acquisitionChannel:
            freezed == acquisitionChannel
                ? _value.acquisitionChannel
                : acquisitionChannel // ignore: cast_nullable_to_non_nullable
                    as String?,
        booker:
            freezed == booker
                ? _value.booker
                : booker // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerNote:
            freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                    as String?,
        communicationChannel:
            freezed == communicationChannel
                ? _value.communicationChannel
                : communicationChannel // ignore: cast_nullable_to_non_nullable
                    as CommunicationChannel?,
        channelAccount:
            freezed == channelAccount
                ? _value.channelAccount
                : channelAccount // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerCode:
            freezed == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        purchaseCode:
            freezed == purchaseCode
                ? _value.purchaseCode
                : purchaseCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationId:
            freezed == reservationId
                ? _value.reservationId
                : reservationId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInputImpl implements _CustomerInput {
  const _$CustomerInputImpl({
    required this.name,
    this.nationality,
    this.gender,
    this.birthDate,
    this.age,
    this.passportName,
    this.passportLastName,
    this.passportFirstName,
    this.isBooker = true,
    this.acquisitionChannel,
    this.booker,
    this.customerNote,
    this.communicationChannel,
    this.channelAccount,
    this.customerCode,
    this.phone,
    this.purchaseCode,
    this.reservationId,
  });

  factory _$CustomerInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInputImplFromJson(json);

  @override
  final String name;
  @override
  final String? nationality;
  @override
  final CustomerGender? gender;
  @override
  final DateTime? birthDate;
  @override
  final double? age;
  @override
  final String? passportName;
  @override
  final String? passportLastName;
  @override
  final String? passportFirstName;
  @override
  @JsonKey()
  final bool isBooker;
  @override
  final String? acquisitionChannel;
  @override
  final String? booker;
  @override
  final String? customerNote;
  @override
  final CommunicationChannel? communicationChannel;
  @override
  final String? channelAccount;
  @override
  final String? customerCode;
  @override
  final String? phone;
  @override
  final String? purchaseCode;
  @override
  final String? reservationId;

  @override
  String toString() {
    return 'CustomerInput(name: $name, nationality: $nationality, gender: $gender, birthDate: $birthDate, age: $age, passportName: $passportName, passportLastName: $passportLastName, passportFirstName: $passportFirstName, isBooker: $isBooker, acquisitionChannel: $acquisitionChannel, booker: $booker, customerNote: $customerNote, communicationChannel: $communicationChannel, channelAccount: $channelAccount, customerCode: $customerCode, phone: $phone, purchaseCode: $purchaseCode, reservationId: $reservationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInputImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.passportName, passportName) ||
                other.passportName == passportName) &&
            (identical(other.passportLastName, passportLastName) ||
                other.passportLastName == passportLastName) &&
            (identical(other.passportFirstName, passportFirstName) ||
                other.passportFirstName == passportFirstName) &&
            (identical(other.isBooker, isBooker) ||
                other.isBooker == isBooker) &&
            (identical(other.acquisitionChannel, acquisitionChannel) ||
                other.acquisitionChannel == acquisitionChannel) &&
            (identical(other.booker, booker) || other.booker == booker) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.communicationChannel, communicationChannel) ||
                other.communicationChannel == communicationChannel) &&
            (identical(other.channelAccount, channelAccount) ||
                other.channelAccount == channelAccount) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.purchaseCode, purchaseCode) ||
                other.purchaseCode == purchaseCode) &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    nationality,
    gender,
    birthDate,
    age,
    passportName,
    passportLastName,
    passportFirstName,
    isBooker,
    acquisitionChannel,
    booker,
    customerNote,
    communicationChannel,
    channelAccount,
    customerCode,
    phone,
    purchaseCode,
    reservationId,
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
    required final String name,
    final String? nationality,
    final CustomerGender? gender,
    final DateTime? birthDate,
    final double? age,
    final String? passportName,
    final String? passportLastName,
    final String? passportFirstName,
    final bool isBooker,
    final String? acquisitionChannel,
    final String? booker,
    final String? customerNote,
    final CommunicationChannel? communicationChannel,
    final String? channelAccount,
    final String? customerCode,
    final String? phone,
    final String? purchaseCode,
    final String? reservationId,
  }) = _$CustomerInputImpl;

  factory _CustomerInput.fromJson(Map<String, dynamic> json) =
      _$CustomerInputImpl.fromJson;

  @override
  String get name;
  @override
  String? get nationality;
  @override
  CustomerGender? get gender;
  @override
  DateTime? get birthDate;
  @override
  double? get age;
  @override
  String? get passportName;
  @override
  String? get passportLastName;
  @override
  String? get passportFirstName;
  @override
  bool get isBooker;
  @override
  String? get acquisitionChannel;
  @override
  String? get booker;
  @override
  String? get customerNote;
  @override
  CommunicationChannel? get communicationChannel;
  @override
  String? get channelAccount;
  @override
  String? get customerCode;
  @override
  String? get phone;
  @override
  String? get purchaseCode;
  @override
  String? get reservationId;

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
  int get totalCustomers => throw _privateConstructorUsedError;
  int get totalBookers => throw _privateConstructorUsedError;
  int get totalCompanions => throw _privateConstructorUsedError;
  int get maleCustomers => throw _privateConstructorUsedError;
  int get femaleCustomers => throw _privateConstructorUsedError;
  double get averageAge => throw _privateConstructorUsedError;
  int get newCustomers => throw _privateConstructorUsedError;
  int get returningCustomers => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

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
    int totalCustomers,
    int totalBookers,
    int totalCompanions,
    int maleCustomers,
    int femaleCustomers,
    double averageAge,
    int newCustomers,
    int returningCustomers,
    double totalRevenue,
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
    Object? totalBookers = null,
    Object? totalCompanions = null,
    Object? maleCustomers = null,
    Object? femaleCustomers = null,
    Object? averageAge = null,
    Object? newCustomers = null,
    Object? returningCustomers = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _value.copyWith(
            totalCustomers:
                null == totalCustomers
                    ? _value.totalCustomers
                    : totalCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            totalBookers:
                null == totalBookers
                    ? _value.totalBookers
                    : totalBookers // ignore: cast_nullable_to_non_nullable
                        as int,
            totalCompanions:
                null == totalCompanions
                    ? _value.totalCompanions
                    : totalCompanions // ignore: cast_nullable_to_non_nullable
                        as int,
            maleCustomers:
                null == maleCustomers
                    ? _value.maleCustomers
                    : maleCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            femaleCustomers:
                null == femaleCustomers
                    ? _value.femaleCustomers
                    : femaleCustomers // ignore: cast_nullable_to_non_nullable
                        as int,
            averageAge:
                null == averageAge
                    ? _value.averageAge
                    : averageAge // ignore: cast_nullable_to_non_nullable
                        as double,
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
    int totalCustomers,
    int totalBookers,
    int totalCompanions,
    int maleCustomers,
    int femaleCustomers,
    double averageAge,
    int newCustomers,
    int returningCustomers,
    double totalRevenue,
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
    Object? totalBookers = null,
    Object? totalCompanions = null,
    Object? maleCustomers = null,
    Object? femaleCustomers = null,
    Object? averageAge = null,
    Object? newCustomers = null,
    Object? returningCustomers = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _$CustomerStatsImpl(
        totalCustomers:
            null == totalCustomers
                ? _value.totalCustomers
                : totalCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        totalBookers:
            null == totalBookers
                ? _value.totalBookers
                : totalBookers // ignore: cast_nullable_to_non_nullable
                    as int,
        totalCompanions:
            null == totalCompanions
                ? _value.totalCompanions
                : totalCompanions // ignore: cast_nullable_to_non_nullable
                    as int,
        maleCustomers:
            null == maleCustomers
                ? _value.maleCustomers
                : maleCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        femaleCustomers:
            null == femaleCustomers
                ? _value.femaleCustomers
                : femaleCustomers // ignore: cast_nullable_to_non_nullable
                    as int,
        averageAge:
            null == averageAge
                ? _value.averageAge
                : averageAge // ignore: cast_nullable_to_non_nullable
                    as double,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerStatsImpl implements _CustomerStats {
  const _$CustomerStatsImpl({
    this.totalCustomers = 0,
    this.totalBookers = 0,
    this.totalCompanions = 0,
    this.maleCustomers = 0,
    this.femaleCustomers = 0,
    this.averageAge = 0.0,
    this.newCustomers = 0,
    this.returningCustomers = 0,
    this.totalRevenue = 0.0,
  });

  factory _$CustomerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalCustomers;
  @override
  @JsonKey()
  final int totalBookers;
  @override
  @JsonKey()
  final int totalCompanions;
  @override
  @JsonKey()
  final int maleCustomers;
  @override
  @JsonKey()
  final int femaleCustomers;
  @override
  @JsonKey()
  final double averageAge;
  @override
  @JsonKey()
  final int newCustomers;
  @override
  @JsonKey()
  final int returningCustomers;
  @override
  @JsonKey()
  final double totalRevenue;

  @override
  String toString() {
    return 'CustomerStats(totalCustomers: $totalCustomers, totalBookers: $totalBookers, totalCompanions: $totalCompanions, maleCustomers: $maleCustomers, femaleCustomers: $femaleCustomers, averageAge: $averageAge, newCustomers: $newCustomers, returningCustomers: $returningCustomers, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerStatsImpl &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.totalBookers, totalBookers) ||
                other.totalBookers == totalBookers) &&
            (identical(other.totalCompanions, totalCompanions) ||
                other.totalCompanions == totalCompanions) &&
            (identical(other.maleCustomers, maleCustomers) ||
                other.maleCustomers == maleCustomers) &&
            (identical(other.femaleCustomers, femaleCustomers) ||
                other.femaleCustomers == femaleCustomers) &&
            (identical(other.averageAge, averageAge) ||
                other.averageAge == averageAge) &&
            (identical(other.newCustomers, newCustomers) ||
                other.newCustomers == newCustomers) &&
            (identical(other.returningCustomers, returningCustomers) ||
                other.returningCustomers == returningCustomers) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCustomers,
    totalBookers,
    totalCompanions,
    maleCustomers,
    femaleCustomers,
    averageAge,
    newCustomers,
    returningCustomers,
    totalRevenue,
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
    final int totalCustomers,
    final int totalBookers,
    final int totalCompanions,
    final int maleCustomers,
    final int femaleCustomers,
    final double averageAge,
    final int newCustomers,
    final int returningCustomers,
    final double totalRevenue,
  }) = _$CustomerStatsImpl;

  factory _CustomerStats.fromJson(Map<String, dynamic> json) =
      _$CustomerStatsImpl.fromJson;

  @override
  int get totalCustomers;
  @override
  int get totalBookers;
  @override
  int get totalCompanions;
  @override
  int get maleCustomers;
  @override
  int get femaleCustomers;
  @override
  double get averageAge;
  @override
  int get newCustomers;
  @override
  int get returningCustomers;
  @override
  double get totalRevenue;

  /// Create a copy of CustomerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerStatsImplCopyWith<_$CustomerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
