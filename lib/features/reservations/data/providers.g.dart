// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'030d2674e436003df5091f0a3ca9f0a898282aed';

/// See also [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$reservationsRepositoryHash() =>
    r'cbb2a05dc85e3283615d5b3cdc9f2843e243e534';

/// See also [reservationsRepository].
@ProviderFor(reservationsRepository)
final reservationsRepositoryProvider =
    AutoDisposeProvider<ReservationsRepository>.internal(
      reservationsRepository,
      name: r'reservationsRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReservationsRepositoryRef =
    AutoDisposeProviderRef<ReservationsRepository>;
String _$reservationsHash() => r'cd81c8e85d7304e7c8d40ee23c70734d317df84b';

/// See also [reservations].
@ProviderFor(reservations)
final reservationsProvider =
    AutoDisposeFutureProvider<List<Reservation>>.internal(
      reservations,
      name: r'reservationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReservationsRef = AutoDisposeFutureProviderRef<List<Reservation>>;
String _$reservationStatsHash() => r'4fd256b1d4b0c82bf006c51c6ecfcb590e4750d2';

/// See also [reservationStats].
@ProviderFor(reservationStats)
final reservationStatsProvider =
    AutoDisposeFutureProvider<ReservationStats>.internal(
      reservationStats,
      name: r'reservationStatsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReservationStatsRef = AutoDisposeFutureProviderRef<ReservationStats>;
String _$reservationHash() => r'38255f290fab8fbc7f78ec464e699c419caee2e3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [reservation].
@ProviderFor(reservation)
const reservationProvider = ReservationFamily();

/// See also [reservation].
class ReservationFamily extends Family<AsyncValue<Reservation?>> {
  /// See also [reservation].
  const ReservationFamily();

  /// See also [reservation].
  ReservationProvider call(String id) {
    return ReservationProvider(id);
  }

  @override
  ReservationProvider getProviderOverride(
    covariant ReservationProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reservationProvider';
}

/// See also [reservation].
class ReservationProvider extends AutoDisposeFutureProvider<Reservation?> {
  /// See also [reservation].
  ReservationProvider(String id)
    : this._internal(
        (ref) => reservation(ref as ReservationRef, id),
        from: reservationProvider,
        name: r'reservationProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$reservationHash,
        dependencies: ReservationFamily._dependencies,
        allTransitiveDependencies: ReservationFamily._allTransitiveDependencies,
        id: id,
      );

  ReservationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Reservation?> Function(ReservationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReservationProvider._internal(
        (ref) => create(ref as ReservationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Reservation?> createElement() {
    return _ReservationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReservationRef on AutoDisposeFutureProviderRef<Reservation?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReservationProviderElement
    extends AutoDisposeFutureProviderElement<Reservation?>
    with ReservationRef {
  _ReservationProviderElement(super.provider);

  @override
  String get id => (origin as ReservationProvider).id;
}

String _$clinicsHash() => r'4c3a8e4cafc68ef2b81358f350926b8da4a2cf57';

/// See also [clinics].
@ProviderFor(clinics)
final clinicsProvider = AutoDisposeFutureProvider<List<Clinic>>.internal(
  clinics,
  name: r'clinicsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clinicsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClinicsRef = AutoDisposeFutureProviderRef<List<Clinic>>;
String _$serviceTypesHash() => r'069b84d5792fc727718957f1468162c0a1e8c00b';

/// See also [serviceTypes].
@ProviderFor(serviceTypes)
final serviceTypesProvider =
    AutoDisposeProvider<List<ServiceTypeEnum>>.internal(
      serviceTypes,
      name: r'serviceTypesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$serviceTypesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServiceTypesRef = AutoDisposeProviderRef<List<ServiceTypeEnum>>;
String _$guideRecommendationsHash() =>
    r'1d684d3a86123e3bd223f49e5c834b14297f4b5b';

/// See also [guideRecommendations].
@ProviderFor(guideRecommendations)
const guideRecommendationsProvider = GuideRecommendationsFamily();

/// See also [guideRecommendations].
class GuideRecommendationsFamily
    extends Family<AsyncValue<List<GuideRecommendation>>> {
  /// See also [guideRecommendations].
  const GuideRecommendationsFamily();

  /// See also [guideRecommendations].
  GuideRecommendationsProvider call(String reservationId) {
    return GuideRecommendationsProvider(reservationId);
  }

  @override
  GuideRecommendationsProvider getProviderOverride(
    covariant GuideRecommendationsProvider provider,
  ) {
    return call(provider.reservationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'guideRecommendationsProvider';
}

/// See also [guideRecommendations].
class GuideRecommendationsProvider
    extends AutoDisposeFutureProvider<List<GuideRecommendation>> {
  /// See also [guideRecommendations].
  GuideRecommendationsProvider(String reservationId)
    : this._internal(
        (ref) =>
            guideRecommendations(ref as GuideRecommendationsRef, reservationId),
        from: guideRecommendationsProvider,
        name: r'guideRecommendationsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$guideRecommendationsHash,
        dependencies: GuideRecommendationsFamily._dependencies,
        allTransitiveDependencies:
            GuideRecommendationsFamily._allTransitiveDependencies,
        reservationId: reservationId,
      );

  GuideRecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.reservationId,
  }) : super.internal();

  final String reservationId;

  @override
  Override overrideWith(
    FutureOr<List<GuideRecommendation>> Function(
      GuideRecommendationsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuideRecommendationsProvider._internal(
        (ref) => create(ref as GuideRecommendationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        reservationId: reservationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GuideRecommendation>> createElement() {
    return _GuideRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuideRecommendationsProvider &&
        other.reservationId == reservationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reservationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GuideRecommendationsRef
    on AutoDisposeFutureProviderRef<List<GuideRecommendation>> {
  /// The parameter `reservationId` of this provider.
  String get reservationId;
}

class _GuideRecommendationsProviderElement
    extends AutoDisposeFutureProviderElement<List<GuideRecommendation>>
    with GuideRecommendationsRef {
  _GuideRecommendationsProviderElement(super.provider);

  @override
  String get reservationId =>
      (origin as GuideRecommendationsProvider).reservationId;
}

String _$searchResultsHash() => r'a808775a3f6bfc13a48e45b8b6a91de86f6dd24f';

/// See also [searchResults].
@ProviderFor(searchResults)
final searchResultsProvider =
    AutoDisposeFutureProvider<PaginatedReservations>.internal(
      searchResults,
      name: r'searchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchResultsRef = AutoDisposeFutureProviderRef<PaginatedReservations>;
String _$activeFilterHash() => r'f14e863e10f064163a908794505a27cf79ce6cba';

/// See also [activeFilter].
@ProviderFor(activeFilter)
final activeFilterProvider = AutoDisposeProvider<ReservationFilters>.internal(
  activeFilter,
  name: r'activeFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveFilterRef = AutoDisposeProviderRef<ReservationFilters>;
String _$filteredReservationsHash() =>
    r'c5c13bd4778a29f2702cca815d7af16ca7656a0a';

/// See also [filteredReservations].
@ProviderFor(filteredReservations)
final filteredReservationsProvider =
    AutoDisposeFutureProvider<PaginatedReservations>.internal(
      filteredReservations,
      name: r'filteredReservationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredReservationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredReservationsRef =
    AutoDisposeFutureProviderRef<PaginatedReservations>;
String _$todayReservationsHash() => r'0ed48e243e556d2474db0a6fb52d14ebdeb55d96';

/// See also [todayReservations].
@ProviderFor(todayReservations)
final todayReservationsProvider =
    AutoDisposeFutureProvider<List<Reservation>>.internal(
      todayReservations,
      name: r'todayReservationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$todayReservationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayReservationsRef = AutoDisposeFutureProviderRef<List<Reservation>>;
String _$upcomingReservationsHash() =>
    r'5d29394e75cdb8b821704f581225e6ce77f2f69b';

/// See also [upcomingReservations].
@ProviderFor(upcomingReservations)
final upcomingReservationsProvider =
    AutoDisposeFutureProvider<List<Reservation>>.internal(
      upcomingReservations,
      name: r'upcomingReservationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$upcomingReservationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingReservationsRef =
    AutoDisposeFutureProviderRef<List<Reservation>>;
String _$createReservationHash() => r'db5a5b9eaea52e27ef4d2f956be73671c3f93f3c';

/// See also [createReservation].
@ProviderFor(createReservation)
const createReservationProvider = CreateReservationFamily();

/// See also [createReservation].
class CreateReservationFamily extends Family<AsyncValue<Reservation>> {
  /// See also [createReservation].
  const CreateReservationFamily();

  /// See also [createReservation].
  CreateReservationProvider call(CreateReservationRequestNew request) {
    return CreateReservationProvider(request);
  }

  @override
  CreateReservationProvider getProviderOverride(
    covariant CreateReservationProvider provider,
  ) {
    return call(provider.request);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createReservationProvider';
}

/// See also [createReservation].
class CreateReservationProvider extends AutoDisposeFutureProvider<Reservation> {
  /// See also [createReservation].
  CreateReservationProvider(CreateReservationRequestNew request)
    : this._internal(
        (ref) => createReservation(ref as CreateReservationRef, request),
        from: createReservationProvider,
        name: r'createReservationProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$createReservationHash,
        dependencies: CreateReservationFamily._dependencies,
        allTransitiveDependencies:
            CreateReservationFamily._allTransitiveDependencies,
        request: request,
      );

  CreateReservationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final CreateReservationRequestNew request;

  @override
  Override overrideWith(
    FutureOr<Reservation> Function(CreateReservationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateReservationProvider._internal(
        (ref) => create(ref as CreateReservationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Reservation> createElement() {
    return _CreateReservationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateReservationProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateReservationRef on AutoDisposeFutureProviderRef<Reservation> {
  /// The parameter `request` of this provider.
  CreateReservationRequestNew get request;
}

class _CreateReservationProviderElement
    extends AutoDisposeFutureProviderElement<Reservation>
    with CreateReservationRef {
  _CreateReservationProviderElement(super.provider);

  @override
  CreateReservationRequestNew get request =>
      (origin as CreateReservationProvider).request;
}

String _$reservationFilterNotifierHash() =>
    r'86d336550b42f6fd60268249f6f9fd93c3787a5e';

/// See also [ReservationFilterNotifier].
@ProviderFor(ReservationFilterNotifier)
final reservationFilterNotifierProvider = AutoDisposeNotifierProvider<
  ReservationFilterNotifier,
  ReservationFilters
>.internal(
  ReservationFilterNotifier.new,
  name: r'reservationFilterNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reservationFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReservationFilterNotifier = AutoDisposeNotifier<ReservationFilters>;
String _$reservationPageHash() => r'f6d575aa75ecfdf983d9584d1be0b9f405aa6c88';

/// See also [ReservationPage].
@ProviderFor(ReservationPage)
final reservationPageProvider =
    AutoDisposeNotifierProvider<ReservationPage, int>.internal(
      ReservationPage.new,
      name: r'reservationPageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationPageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationPage = AutoDisposeNotifier<int>;
String _$reservationPageSizeHash() =>
    r'8611b387efbc2c3f7b40d4fc433dd38e17b55099';

/// See also [ReservationPageSize].
@ProviderFor(ReservationPageSize)
final reservationPageSizeProvider =
    AutoDisposeNotifierProvider<ReservationPageSize, int>.internal(
      ReservationPageSize.new,
      name: r'reservationPageSizeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationPageSizeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationPageSize = AutoDisposeNotifier<int>;
String _$reservationFormHash() => r'cb52dabdde858037ac086a5b4bb6a4cec7e0d7cc';

/// See also [ReservationForm].
@ProviderFor(ReservationForm)
final reservationFormProvider =
    AutoDisposeNotifierProvider<ReservationForm, AsyncValue<void>>.internal(
      ReservationForm.new,
      name: r'reservationFormProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationFormHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationForm = AutoDisposeNotifier<AsyncValue<void>>;
String _$selectedReservationHash() =>
    r'85e406929c97983b7635944375a68397e33db16c';

/// See also [SelectedReservation].
@ProviderFor(SelectedReservation)
final selectedReservationProvider =
    AutoDisposeNotifierProvider<SelectedReservation, Reservation?>.internal(
      SelectedReservation.new,
      name: r'selectedReservationProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedReservationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedReservation = AutoDisposeNotifier<Reservation?>;
String _$searchQueryHash() => r'257de54425dafeed9025e6757617bca324dde03f';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$reservationDateHash() => r'7ee8260ebfdd1e5e0158983337f574d9f47dfbbe';

/// See also [ReservationDate].
@ProviderFor(ReservationDate)
final reservationDateProvider =
    AutoDisposeNotifierProvider<ReservationDate, DateTime?>.internal(
      ReservationDate.new,
      name: r'reservationDateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationDateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationDate = AutoDisposeNotifier<DateTime?>;
String _$startTimeHash() => r'8294999638bbdd2a5a611461c01315e24ec63877';

/// See also [StartTime].
@ProviderFor(StartTime)
final startTimeProvider =
    AutoDisposeNotifierProvider<StartTime, DateTime?>.internal(
      StartTime.new,
      name: r'startTimeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$startTimeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StartTime = AutoDisposeNotifier<DateTime?>;
String _$reservationDurationHash() =>
    r'4667ffd1b742431d331e1a666cbf0788a5bdaacf';

/// See also [ReservationDuration].
@ProviderFor(ReservationDuration)
final reservationDurationProvider =
    AutoDisposeNotifierProvider<ReservationDuration, int>.internal(
      ReservationDuration.new,
      name: r'reservationDurationProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationDurationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationDuration = AutoDisposeNotifier<int>;
String _$selectedClinicHash() => r'c613cafe6ad3ba6be71f6a4f3da084b5650f11bb';

/// See also [SelectedClinic].
@ProviderFor(SelectedClinic)
final selectedClinicProvider =
    AutoDisposeNotifierProvider<SelectedClinic, Clinic?>.internal(
      SelectedClinic.new,
      name: r'selectedClinicProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedClinicHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedClinic = AutoDisposeNotifier<Clinic?>;
String _$selectedGuideHash() => r'ab001548d5eb0d0bd58fb502c14605fb126df360';

/// See also [SelectedGuide].
@ProviderFor(SelectedGuide)
final selectedGuideProvider =
    AutoDisposeNotifierProvider<SelectedGuide, ReservationGuide?>.internal(
      SelectedGuide.new,
      name: r'selectedGuideProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedGuideHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedGuide = AutoDisposeNotifier<ReservationGuide?>;
String _$selectedServiceTypesHash() =>
    r'faeaf3b07973a5b1de856846ecfd7aeb74317da7';

/// See also [SelectedServiceTypes].
@ProviderFor(SelectedServiceTypes)
final selectedServiceTypesProvider = AutoDisposeNotifierProvider<
  SelectedServiceTypes,
  List<ServiceTypeEnum>
>.internal(
  SelectedServiceTypes.new,
  name: r'selectedServiceTypesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedServiceTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedServiceTypes = AutoDisposeNotifier<List<ServiceTypeEnum>>;
String _$reservationNotesHash() => r'4ed5cb98c998618f042ad0bbdbf45d019d84e0dc';

/// See also [ReservationNotes].
@ProviderFor(ReservationNotes)
final reservationNotesProvider =
    AutoDisposeNotifierProvider<ReservationNotes, String>.internal(
      ReservationNotes.new,
      name: r'reservationNotesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reservationNotesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReservationNotes = AutoDisposeNotifier<String>;
String _$customersHash() => r'df4646dae6c00a9d23a18409e4fd5f59316ccef7';

/// See also [Customers].
@ProviderFor(Customers)
final customersProvider =
    AutoDisposeNotifierProvider<Customers, List<CustomerRequest>>.internal(
      Customers.new,
      name: r'customersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Customers = AutoDisposeNotifier<List<CustomerRequest>>;
String _$statusFilterHash() => r'aa046135b95a472dd29b286001fa62e98c22933d';

/// See also [StatusFilter].
@ProviderFor(StatusFilter)
final statusFilterProvider =
    AutoDisposeNotifierProvider<StatusFilter, ReservationStatus?>.internal(
      StatusFilter.new,
      name: r'statusFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$statusFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StatusFilter = AutoDisposeNotifier<ReservationStatus?>;
String _$clinicFilterHash() => r'cc5db7f490ca7388fcdb3b825ec6ce17c40c4077';

/// See also [ClinicFilter].
@ProviderFor(ClinicFilter)
final clinicFilterProvider =
    AutoDisposeNotifierProvider<ClinicFilter, Clinic?>.internal(
      ClinicFilter.new,
      name: r'clinicFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$clinicFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClinicFilter = AutoDisposeNotifier<Clinic?>;
String _$serviceTypeFilterHash() => r'5876349e2f6e55e555c80b7f2f9506ae2e10331a';

/// See also [ServiceTypeFilter].
@ProviderFor(ServiceTypeFilter)
final serviceTypeFilterProvider =
    AutoDisposeNotifierProvider<ServiceTypeFilter, ServiceTypeEnum?>.internal(
      ServiceTypeFilter.new,
      name: r'serviceTypeFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$serviceTypeFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServiceTypeFilter = AutoDisposeNotifier<ServiceTypeEnum?>;
String _$dateFromFilterHash() => r'c3a23da4d8693d78f12a205646dbabda81f9db77';

/// See also [DateFromFilter].
@ProviderFor(DateFromFilter)
final dateFromFilterProvider =
    AutoDisposeNotifierProvider<DateFromFilter, DateTime?>.internal(
      DateFromFilter.new,
      name: r'dateFromFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dateFromFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DateFromFilter = AutoDisposeNotifier<DateTime?>;
String _$dateToFilterHash() => r'91f0460df0604b0d4143f66e4c6d9c099d4fb4ca';

/// See also [DateToFilter].
@ProviderFor(DateToFilter)
final dateToFilterProvider =
    AutoDisposeNotifierProvider<DateToFilter, DateTime?>.internal(
      DateToFilter.new,
      name: r'dateToFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dateToFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DateToFilter = AutoDisposeNotifier<DateTime?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
