supabase.supabase_flutter: INFO: ***** Supabase init completed ***** 
══╡ EXCEPTION CAUGHT BY GESTURE ╞═══════════════════════════════════════════════════════════════════
The following assertion was thrown while handling a gesture:
Assertion failed:
file:///C:/Users/Hyper%20Connected/AppData/Local/Pub/Cache/hosted/pub.dev/go_router-14.8.1/lib/src/delegate.dart:162:7
currentConfiguration.isNotEmpty
"You have popped the last page off of the stack, there are no pages left to show"

When the exception was thrown, this was the stack:
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 307:3                        throw_
dart-sdk/lib/_internal/js_dev_runtime/private/profile.dart 117:39                                  assertFailed
packages/go_router/src/delegate.dart 162:28                                                        [_debugAssertMatchListNotEmpty]
packages/go_router/src/delegate.dart 183:5                                                         [_completeRouteMatch]
packages/go_router/src/delegate.dart 141:7                                                         [_handlePopPageWithRouteMatch]
packages/go_router/src/builder.dart 425:42                                                         [_handlePopPage]
packages/flutter/src/widgets/navigator.dart 5594:18                                                pop
packages/flutter_admin_web/features/reservations/presentation/pages/reservations_page.dart 802:18  [_showEditReservation]
packages/flutter_admin_web/features/reservations/presentation/pages/reservations_page.dart 791:27  <fn>
packages/flutter/src/material/ink_well.dart 1185:21                                                handleTap
packages/flutter/src/gestures/recognizer.dart 357:24                                               invokeCallback
packages/flutter/src/gestures/tap.dart 653:11                                                      handleTapUp
packages/flutter/src/gestures/tap.dart 307:5                                                       [_checkUp]
packages/flutter/src/gestures/tap.dart 240:7                                                       handlePrimaryPointer
packages/flutter/src/gestures/recognizer.dart 718:9                                                handleEvent
packages/flutter/src/gestures/pointer_router.dart 97:7                                             [_dispatch]
packages/flutter/src/gestures/pointer_router.dart 143:9                                            <fn>
dart-sdk/lib/_internal/js_dev_runtime/private/linked_hash_map.dart 21:7                            forEach
packages/flutter/src/gestures/pointer_router.dart 141:17                                           [_dispatchEventToRoutes]
packages/flutter/src/gestures/pointer_router.dart 131:7                                            route
packages/flutter/src/gestures/binding.dart 530:5                                                   handleEvent
packages/flutter/src/gestures/binding.dart 499:14                                                  dispatchEvent
packages/flutter/src/rendering/binding.dart 460:11                                                 dispatchEvent
packages/flutter/src/gestures/binding.dart 437:7                                                   [_handlePointerEventImmediately]
packages/flutter/src/gestures/binding.dart 394:5                                                   handlePointerEvent
packages/flutter/src/gestures/binding.dart 341:7                                                   [_flushPointerEventQueue]
packages/flutter/src/gestures/binding.dart 308:9                                                   [_handlePointerDataPacket]
lib/_engine/engine/platform_dispatcher.dart 1362:5                                                 invoke1
lib/_engine/engine/platform_dispatcher.dart 327:5                                                  invokeOnPointerDataPacket
lib/_engine/engine/pointer_binding.dart 411:30                                                     [_sendToFramework]
lib/_engine/engine/pointer_binding.dart 231:7                                                      onPointerData
lib/_engine/engine/pointer_binding.dart 1022:20                                                    <fn>
lib/_engine/engine/pointer_binding.dart 905:7                                                      <fn>
lib/_engine/engine/pointer_binding.dart 535:9                                                      loggedHandler
dart-sdk/lib/_internal/js_dev_runtime/patch/js_allow_interop_patch.dart 224:27                     _callDartFunctionFast1

Handler: "onTap"
Recognizer:
  TapGestureRecognizer#15ce5
════════════════════════════════════════════════════════════════════════════════════════════════════
Another exception was thrown: Assertion failed: file:///C:/sdk/flutter/packages/flutter/lib/src/widgets/navigator.dart:4078:12
