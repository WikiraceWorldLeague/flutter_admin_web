This app is linked to the debug service: ws://127.0.0.1:9872/9vfPSiT0Uuk=/ws
js_primitives.dart:28 supabase.supabase_flutter: INFO: ***** Supabase init completed ***** 
js_primitives.dart:28 🔍 Direct Supabase Client Created
js_primitives.dart:28 🔍 Starting getReservations...
js_primitives.dart:28 📊 Parameters: page=1, pageSize=20, status=null
js_primitives.dart:28 📊 Step 1: Fetching reservations...
js_primitives.dart:28 📊 Raw response: [{id: d18961a8-3e09-4b5f-bf0d-63229ad2716e, reservation_number: RES202506138350, reservation_date: 2024-01-15, start_time: 10:00:00, end_time: 13:00:00, guide_id: a021b62a-95cb-44f6-830c-4daea354f1a8, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: completed, special_notes: 피부 레이저 시술 동행, admin_memo: null, total_amount: 500000, commission_rate: 4.5, commission_amount: 22500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 95796e23-b208-4176-a7e7-e337f5669c74, reservation_number: RES202506135184, reservation_date: 2024-01-18, start_time: 14:00:00, end_time: 17:00:00, guide_id: be380825-20df-45e3-9cc4-1dcdf8db9835, clinic_id: 62bda6bf-5d49-4ee4-a355-b39aed42a43f, status: completed, special_notes: 코 성형 상담, admin_memo: null, total_amount: 300000, commission_rate: 4.5, commission_amount: 13500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 590938ed-cd10-4dfa-b405-c7fb2b352687, reservation_number: RES202506133912, reservation_date: 2024-01-20, start_time: 11:00:00, end_time: 14:00:00, guide_id: 2e0639ef-a67e-4ab2-8ce9-23f5e8d823de, clinic_id: bc676bdf-fdda-46a3-b69c-98ffc896f189, status: in_progress, special_notes: 여드름 치료, admin_memo: null, total_amount: 250000, commission_rate: 4.5, commission_amount: 11250, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: ade073cc-2fec-4df5-a683-549c40137915, reservation_number: RES202506131095, reservation_date: 2024-01-22, start_time: 15:00:00, end_time: 18:00:00, guide_id: 4943939e-4c31-4da7-8a58-98a095c8d7be, clinic_id: 4e0302ed-5fd1-46fe-8304-fdc3b31333a5, status: assigned, special_notes: 보톡스 시술, admin_memo: null, total_amount: 400000, commission_rate: 4.5, commission_amount: 18000, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 18688048-5648-4338-9b14-5ac2bef93c1f, reservation_number: RES202506132193, reservation_date: 2024-01-25, start_time: 09:00:00, end_time: 12:00:00, guide_id: null, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: pending_assignment, special_notes: 전체적인 피부 관리 상담, admin_memo: null, total_amount: 0, commission_rate: 4.5, commission_amount: 0, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-14T02:27:11.252812+00:00, customer_id: null, duration_minutes: 180}]
js_primitives.dart:28 📊 Response type: List<Map<String, dynamic>>
js_primitives.dart:28 📊 Response length: 5
js_primitives.dart:28 📊 Step 2: Converting to Reservation objects...
js_primitives.dart:28 📊 Processing item 0: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 0
js_primitives.dart:28 📊 Processing item 1: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 1
js_primitives.dart:28 📊 Processing item 2: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 2
js_primitives.dart:28 📊 Processing item 3: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 3
js_primitives.dart:28 📊 Processing item 4: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 4
js_primitives.dart:28 ✅ Successfully loaded 5 reservations
js_primitives.dart:28 🔍 Starting getGuideRecommendations for reservation: d18961a8-3e09-4b5f-bf0d-63229ad2716e
js_primitives.dart:28 ❌ Error in getGuideRecommendations: Exception: 예약을 찾을 수 없습니다
js_primitives.dart:28 ❌ Stack trace: dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 307:3               throw_
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 362:9  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 593:31                       <fn>
dart-sdk/lib/async/zone.dart 1849:54                                                      runUnary
dart-sdk/lib/async/future_impl.dart 208:18                                                handleValue
dart-sdk/lib/async/future_impl.dart 932:44                                                handleValueCallback
dart-sdk/lib/async/future_impl.dart 961:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 712:5                                                 [_completeWithValue]
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 503:7                        complete
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 570:12                       _asyncReturn
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 130:3  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
packages/postgrest/src/postgrest_builder.dart 403:27                                      <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
dart-sdk/lib/async/zone.dart 1854:54                                                      runBinary
dart-sdk/lib/async/future_impl.dart 223:22                                                handleError
dart-sdk/lib/async/future_impl.dart 944:46                                                handleError
dart-sdk/lib/async/future_impl.dart 965:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 730:5                                                 [_completeError]
dart-sdk/lib/async/future_impl.dart 816:7                                                 callback
dart-sdk/lib/async/schedule_microtask.dart 40:11                                          _microtaskLoop
dart-sdk/lib/async/schedule_microtask.dart 49:5                                           _startMicrotaskLoop
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 186:7                        <fn>

js_primitives.dart:28 🔍 Starting getGuideRecommendations for reservation: 95796e23-b208-4176-a7e7-e337f5669c74
js_primitives.dart:28 ❌ Error in getGuideRecommendations: Exception: 예약을 찾을 수 없습니다
js_primitives.dart:28 ❌ Stack trace: dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 307:3               throw_
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 362:9  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 593:31                       <fn>
dart-sdk/lib/async/zone.dart 1849:54                                                      runUnary
dart-sdk/lib/async/future_impl.dart 208:18                                                handleValue
dart-sdk/lib/async/future_impl.dart 932:44                                                handleValueCallback
dart-sdk/lib/async/future_impl.dart 961:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 712:5                                                 [_completeWithValue]
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 503:7                        complete
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 570:12                       _asyncReturn
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 130:3  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
packages/postgrest/src/postgrest_builder.dart 403:27                                      <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
dart-sdk/lib/async/zone.dart 1854:54                                                      runBinary
dart-sdk/lib/async/future_impl.dart 223:22                                                handleError
dart-sdk/lib/async/future_impl.dart 944:46                                                handleError
dart-sdk/lib/async/future_impl.dart 965:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 730:5                                                 [_completeError]
dart-sdk/lib/async/future_impl.dart 816:7                                                 callback
dart-sdk/lib/async/schedule_microtask.dart 40:11                                          _microtaskLoop
dart-sdk/lib/async/schedule_microtask.dart 49:5                                           _startMicrotaskLoop
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 186:7                        <fn>

js_primitives.dart:28 🔍 Starting getReservations...
js_primitives.dart:28 📊 Parameters: page=1, pageSize=20, status=null
js_primitives.dart:28 📊 Step 1: Fetching reservations...
js_primitives.dart:28 📊 Raw response: [{id: d18961a8-3e09-4b5f-bf0d-63229ad2716e, reservation_number: RES202506138350, reservation_date: 2024-01-15, start_time: 10:00:00, end_time: 13:00:00, guide_id: a021b62a-95cb-44f6-830c-4daea354f1a8, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: completed, special_notes: 피부 레이저 시술 동행, admin_memo: null, total_amount: 500000, commission_rate: 4.5, commission_amount: 22500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 95796e23-b208-4176-a7e7-e337f5669c74, reservation_number: RES202506135184, reservation_date: 2024-01-18, start_time: 14:00:00, end_time: 17:00:00, guide_id: be380825-20df-45e3-9cc4-1dcdf8db9835, clinic_id: 62bda6bf-5d49-4ee4-a355-b39aed42a43f, status: completed, special_notes: 코 성형 상담, admin_memo: null, total_amount: 300000, commission_rate: 4.5, commission_amount: 13500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 590938ed-cd10-4dfa-b405-c7fb2b352687, reservation_number: RES202506133912, reservation_date: 2024-01-20, start_time: 11:00:00, end_time: 14:00:00, guide_id: 2e0639ef-a67e-4ab2-8ce9-23f5e8d823de, clinic_id: bc676bdf-fdda-46a3-b69c-98ffc896f189, status: in_progress, special_notes: 여드름 치료, admin_memo: null, total_amount: 250000, commission_rate: 4.5, commission_amount: 11250, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: ade073cc-2fec-4df5-a683-549c40137915, reservation_number: RES202506131095, reservation_date: 2024-01-22, start_time: 15:00:00, end_time: 18:00:00, guide_id: 4943939e-4c31-4da7-8a58-98a095c8d7be, clinic_id: 4e0302ed-5fd1-46fe-8304-fdc3b31333a5, status: assigned, special_notes: 보톡스 시술, admin_memo: null, total_amount: 400000, commission_rate: 4.5, commission_amount: 18000, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 18688048-5648-4338-9b14-5ac2bef93c1f, reservation_number: RES202506132193, reservation_date: 2024-01-25, start_time: 09:00:00, end_time: 12:00:00, guide_id: null, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: pending_assignment, special_notes: 전체적인 피부 관리 상담, admin_memo: null, total_amount: 0, commission_rate: 4.5, commission_amount: 0, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-14T02:27:11.252812+00:00, customer_id: null, duration_minutes: 180}]
js_primitives.dart:28 📊 Response type: List<Map<String, dynamic>>
js_primitives.dart:28 📊 Response length: 5
js_primitives.dart:28 📊 Step 2: Converting to Reservation objects...
js_primitives.dart:28 📊 Processing item 0: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 0
js_primitives.dart:28 📊 Processing item 1: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 1
js_primitives.dart:28 📊 Processing item 2: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 2
js_primitives.dart:28 📊 Processing item 3: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 3
js_primitives.dart:28 📊 Processing item 4: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 4
js_primitives.dart:28 ✅ Successfully loaded 5 reservations
js_primitives.dart:28 🔍 Starting getReservations...
js_primitives.dart:28 📊 Parameters: page=1, pageSize=20, status=null
js_primitives.dart:28 📊 Step 1: Fetching reservations...
js_primitives.dart:28 📊 Raw response: [{id: d18961a8-3e09-4b5f-bf0d-63229ad2716e, reservation_number: RES202506138350, reservation_date: 2024-01-15, start_time: 10:00:00, end_time: 13:00:00, guide_id: a021b62a-95cb-44f6-830c-4daea354f1a8, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: completed, special_notes: 피부 레이저 시술 동행, admin_memo: null, total_amount: 500000, commission_rate: 4.5, commission_amount: 22500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 95796e23-b208-4176-a7e7-e337f5669c74, reservation_number: RES202506135184, reservation_date: 2024-01-18, start_time: 14:00:00, end_time: 17:00:00, guide_id: be380825-20df-45e3-9cc4-1dcdf8db9835, clinic_id: 62bda6bf-5d49-4ee4-a355-b39aed42a43f, status: completed, special_notes: 코 성형 상담, admin_memo: null, total_amount: 300000, commission_rate: 4.5, commission_amount: 13500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 590938ed-cd10-4dfa-b405-c7fb2b352687, reservation_number: RES202506133912, reservation_date: 2024-01-20, start_time: 11:00:00, end_time: 14:00:00, guide_id: 2e0639ef-a67e-4ab2-8ce9-23f5e8d823de, clinic_id: bc676bdf-fdda-46a3-b69c-98ffc896f189, status: in_progress, special_notes: 여드름 치료, admin_memo: null, total_amount: 250000, commission_rate: 4.5, commission_amount: 11250, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: ade073cc-2fec-4df5-a683-549c40137915, reservation_number: RES202506131095, reservation_date: 2024-01-22, start_time: 15:00:00, end_time: 18:00:00, guide_id: 4943939e-4c31-4da7-8a58-98a095c8d7be, clinic_id: 4e0302ed-5fd1-46fe-8304-fdc3b31333a5, status: assigned, special_notes: 보톡스 시술, admin_memo: null, total_amount: 400000, commission_rate: 4.5, commission_amount: 18000, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 18688048-5648-4338-9b14-5ac2bef93c1f, reservation_number: RES202506132193, reservation_date: 2024-01-25, start_time: 09:00:00, end_time: 12:00:00, guide_id: null, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: pending_assignment, special_notes: 전체적인 피부 관리 상담, admin_memo: null, total_amount: 0, commission_rate: 4.5, commission_amount: 0, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-14T02:27:11.252812+00:00, customer_id: null, duration_minutes: 180}]
js_primitives.dart:28 📊 Response type: List<Map<String, dynamic>>
js_primitives.dart:28 📊 Response length: 5
js_primitives.dart:28 📊 Step 2: Converting to Reservation objects...
js_primitives.dart:28 📊 Processing item 0: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 0
js_primitives.dart:28 📊 Processing item 1: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 1
js_primitives.dart:28 📊 Processing item 2: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 2
js_primitives.dart:28 📊 Processing item 3: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 3
js_primitives.dart:28 📊 Processing item 4: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 4
js_primitives.dart:28 ✅ Successfully loaded 5 reservations
js_primitives.dart:28 🔍 Starting getGuideRecommendations for reservation: 95796e23-b208-4176-a7e7-e337f5669c74
js_primitives.dart:28 ❌ Error in getGuideRecommendations: Exception: 예약을 찾을 수 없습니다
js_primitives.dart:28 ❌ Stack trace: dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 307:3               throw_
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 362:9  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 593:31                       <fn>
dart-sdk/lib/async/zone.dart 1849:54                                                      runUnary
dart-sdk/lib/async/future_impl.dart 208:18                                                handleValue
dart-sdk/lib/async/future_impl.dart 932:44                                                handleValueCallback
dart-sdk/lib/async/future_impl.dart 961:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 712:5                                                 [_completeWithValue]
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 503:7                        complete
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 570:12                       _asyncReturn
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 130:3  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
packages/postgrest/src/postgrest_builder.dart 403:27                                      <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
dart-sdk/lib/async/zone.dart 1854:54                                                      runBinary
dart-sdk/lib/async/future_impl.dart 223:22                                                handleError
dart-sdk/lib/async/future_impl.dart 944:46                                                handleError
dart-sdk/lib/async/future_impl.dart 965:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 730:5                                                 [_completeError]
dart-sdk/lib/async/future_impl.dart 816:7                                                 callback
dart-sdk/lib/async/schedule_microtask.dart 40:11                                          _microtaskLoop
dart-sdk/lib/async/schedule_microtask.dart 49:5                                           _startMicrotaskLoop
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 186:7                        <fn>

js_primitives.dart:28 🔍 Starting getReservations...
js_primitives.dart:28 📊 Parameters: page=1, pageSize=20, status=null
js_primitives.dart:28 📊 Step 1: Fetching reservations...
js_primitives.dart:28 📊 Raw response: [{id: d18961a8-3e09-4b5f-bf0d-63229ad2716e, reservation_number: RES202506138350, reservation_date: 2024-01-15, start_time: 10:00:00, end_time: 13:00:00, guide_id: a021b62a-95cb-44f6-830c-4daea354f1a8, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: completed, special_notes: 피부 레이저 시술 동행, admin_memo: null, total_amount: 500000, commission_rate: 4.5, commission_amount: 22500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 95796e23-b208-4176-a7e7-e337f5669c74, reservation_number: RES202506135184, reservation_date: 2024-01-18, start_time: 14:00:00, end_time: 17:00:00, guide_id: be380825-20df-45e3-9cc4-1dcdf8db9835, clinic_id: 62bda6bf-5d49-4ee4-a355-b39aed42a43f, status: completed, special_notes: 코 성형 상담, admin_memo: null, total_amount: 300000, commission_rate: 4.5, commission_amount: 13500, settlement_status: paid, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 590938ed-cd10-4dfa-b405-c7fb2b352687, reservation_number: RES202506133912, reservation_date: 2024-01-20, start_time: 11:00:00, end_time: 14:00:00, guide_id: 2e0639ef-a67e-4ab2-8ce9-23f5e8d823de, clinic_id: bc676bdf-fdda-46a3-b69c-98ffc896f189, status: in_progress, special_notes: 여드름 치료, admin_memo: null, total_amount: 250000, commission_rate: 4.5, commission_amount: 11250, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: ade073cc-2fec-4df5-a683-549c40137915, reservation_number: RES202506131095, reservation_date: 2024-01-22, start_time: 15:00:00, end_time: 18:00:00, guide_id: 4943939e-4c31-4da7-8a58-98a095c8d7be, clinic_id: 4e0302ed-5fd1-46fe-8304-fdc3b31333a5, status: assigned, special_notes: 보톡스 시술, admin_memo: null, total_amount: 400000, commission_rate: 4.5, commission_amount: 18000, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-13T12:25:21.534219+00:00, customer_id: null, duration_minutes: 180}, {id: 18688048-5648-4338-9b14-5ac2bef93c1f, reservation_number: RES202506132193, reservation_date: 2024-01-25, start_time: 09:00:00, end_time: 12:00:00, guide_id: null, clinic_id: ed11b471-8262-449e-9960-5256f50ff56b, status: pending_assignment, special_notes: 전체적인 피부 관리 상담, admin_memo: null, total_amount: 0, commission_rate: 4.5, commission_amount: 0, settlement_status: pending, assigned_at: null, assigned_by: null, created_at: 2025-06-13T12:25:21.534219+00:00, updated_at: 2025-06-14T02:27:11.252812+00:00, customer_id: null, duration_minutes: 180}]
js_primitives.dart:28 📊 Response type: List<Map<String, dynamic>>
js_primitives.dart:28 📊 Response length: 5
js_primitives.dart:28 📊 Step 2: Converting to Reservation objects...
js_primitives.dart:28 📊 Processing item 0: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 0
js_primitives.dart:28 📊 Processing item 1: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 1
js_primitives.dart:28 📊 Processing item 2: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 2
js_primitives.dart:28 📊 Processing item 3: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 3
js_primitives.dart:28 📊 Processing item 4: [id, reservation_number, reservation_date, start_time, end_time, guide_id, clinic_id, status, special_notes, admin_memo, total_amount, commission_rate, commission_amount, settlement_status, assigned_at, assigned_by, created_at, updated_at, customer_id, duration_minutes]
js_primitives.dart:28 ✅ Successfully converted item 4
js_primitives.dart:28 ✅ Successfully loaded 5 reservations
js_primitives.dart:28 🔍 Starting getGuideRecommendations for reservation: 95796e23-b208-4176-a7e7-e337f5669c74
js_primitives.dart:28 ❌ Error in getGuideRecommendations: Exception: 예약을 찾을 수 없습니다
js_primitives.dart:28 ❌ Stack trace: dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 307:3               throw_
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 362:9  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 593:31                       <fn>
dart-sdk/lib/async/zone.dart 1849:54                                                      runUnary
dart-sdk/lib/async/future_impl.dart 208:18                                                handleValue
dart-sdk/lib/async/future_impl.dart 932:44                                                handleValueCallback
dart-sdk/lib/async/future_impl.dart 961:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 712:5                                                 [_completeWithValue]
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 503:7                        complete
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 570:12                       _asyncReturn
packages/flutter_admin_web/features/reservations/data/reservations_repository.dart 130:3  <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
packages/postgrest/src/postgrest_builder.dart 403:27                                      <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23                       <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 597:5                        <fn>
dart-sdk/lib/async/zone.dart 1854:54                                                      runBinary
dart-sdk/lib/async/future_impl.dart 223:22                                                handleError
dart-sdk/lib/async/future_impl.dart 944:46                                                handleError
dart-sdk/lib/async/future_impl.dart 965:13                                                _propagateToListeners
dart-sdk/lib/async/future_impl.dart 730:5                                                 [_completeError]
dart-sdk/lib/async/future_impl.dart 816:7                                                 callback
dart-sdk/lib/async/schedule_microtask.dart 40:11                                          _microtaskLoop
dart-sdk/lib/async/schedule_microtask.dart 49:5                                           _startMicrotaskLoop
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 186:7                        <fn>