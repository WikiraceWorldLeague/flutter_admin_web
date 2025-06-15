Error: unable to find directory entry in pubspec.yaml:
C:\proj_cursor\flutter_admin_web\assets\images\
lib/features/reservations/data/reservations_repository.dart:417:15: Error: Type
'ServiceType' not found.
  Future<List<ServiceType>> getServiceTypes() async {
              ^^^^^^^^^^^
lib/features/reservations/presentation/pages/reservations_page.dart:822:10: Error: The
method 'updateStatus' isn't defined for the class 'ReservationFormNotifier'.
 - 'ReservationFormNotifier' is from
 'package:flutter_admin_web/features/reservations/data/providers.dart'
 ('lib/features/reservations/data/providers.dart').
Try correcting the name to the name of an existing method, or defining a method named 
'updateStatus'.
        .updateStatus(reservation.id, ReservationStatus.cancelled);
         ^^^^^^^^^^^^
lib/features/reservations/presentation/pages/reservations_page.dart:828:15: Error:    
This expression has type 'void' and can't be used.
          if (updatedReservation != null) {
              ^
lib/features/reservations/presentation/pages/reservations_page.dart:1017:10: Error:   
The method 'assignGuide' isn't defined for the class 'ReservationFormNotifier'.
 - 'ReservationFormNotifier' is from
 'package:flutter_admin_web/features/reservations/data/providers.dart'
 ('lib/features/reservations/data/providers.dart').
Try correcting the name to the name of an existing method, or defining a method named 
'assignGuide'.
        .assignGuide(reservation.id, guideId);
         ^^^^^^^^^^^
lib/features/reservations/presentation/pages/reservations_page.dart:1022:15: Error:   
This expression has type 'void' and can't be used.
          if (updatedReservation != null) {
              ^
lib/features/reservations/data/reservations_repository.dart:312:19: Error: The getter
'serviceTypeId' isn't defined for the class 'CreateReservationRequestNew'.
 - 'CreateReservationRequestNew' is from
 'package:flutter_admin_web/features/reservations/domain/reservation_models.dart'
 ('lib/features/reservations/domain/reservation_models.dart').
Try correcting the name to the name of an existing getter, or defining a getter or    
field named 'serviceTypeId'.
      if (request.serviceTypeId != null) {
                  ^^^^^^^^^^^^^
lib/features/reservations/data/reservations_repository.dart:315:38: Error: The getter 
'serviceTypeId' isn't defined for the class 'CreateReservationRequestNew'.
 - 'CreateReservationRequestNew' is from
 'package:flutter_admin_web/features/reservations/domain/reservation_models.dart'
 ('lib/features/reservations/domain/reservation_models.dart').
Try correcting the name to the name of an existing getter, or defining a getter or    
field named 'serviceTypeId'.
          'service_type_id': request.serviceTypeId,
                                     ^^^^^^^^^^^^^
lib/features/reservations/data/reservations_repository.dart:425:33: Error: The getter 
'ServiceType' isn't defined for the class 'ReservationsRepository'.
 - 'ReservationsRepository' is from
 'package:flutter_admin_web/features/reservations/data/reservations_repository.dart'
 ('lib/features/reservations/data/reservations_repository.dart').
Try correcting the name to the name of an existing getter, or defining a getter or    
field named 'ServiceType'.
      return data.map((json) => ServiceType.fromJson(json)).toList();
                                ^^^^^^^^^^^
Unhandled exception:
Unsupported operation: Unsupported invalid type InvalidType(<invalid>) (InvalidType). 
Encountered while compiling
file:///C:/proj_cursor/flutter_admin_web/lib/features/reservations/data/reservations_r
epository.dart, which contains the type: InterfaceType(List<<invalid>>).
#0      ProgramCompiler._typeCompilationError
(package:dev_compiler/src/kernel/compiler.dart:3471)
#1      ProgramCompiler._emitType (package:dev_compiler/src/kernel/compiler.dart:3439)
#2      ProgramCompiler._rewriteAsyncFunction
(package:dev_compiler/src/kernel/compiler.dart:3683)
#3      ProgramCompiler._emitFunction.<anonymous closure>
(package:dev_compiler/src/kernel/compiler.dart:3641)
#4      ProgramCompiler._withLetScope
(package:dev_compiler/src/kernel/compiler.dart:2779)
#5      ProgramCompiler._withCurrentFunction
(package:dev_compiler/src/kernel/compiler.dart:3775)
#6      ProgramCompiler._emitFunction
(package:dev_compiler/src/kernel/compiler.dart:3633)
#7      ProgramCompiler._emitMethodDeclaration.<anonymous closure>
(package:dev_compiler/src/kernel/compiler.dart:2330)
#8      ProgramCompiler._withMethodDeclarationContext
(package:dev_compiler/src/kernel/compiler.dart:3802)
#9      ProgramCompiler._emitMethodDeclaration
(package:dev_compiler/src/kernel/compiler.dart:2328)
#10     ProgramCompiler._emitClassMethods
(package:dev_compiler/src/kernel/compiler.dart:2269)
#11     ProgramCompiler._emitClassDeclaration
(package:dev_compiler/src/kernel/compiler.dart:1070)
#12     ProgramCompiler._emitClass
(package:dev_compiler/src/kernel/compiler.dart:1001)
#13     List.forEach (dart:core-patch/growable_array.dart:421)
#14     ProgramCompiler._emitLibrary
(package:dev_compiler/src/kernel/compiler.dart:940)
#15     List.forEach (dart:core-patch/growable_array.dart:421)
#16     ProgramCompiler.emitModule (package:dev_compiler/src/kernel/compiler.dart:629)
#17     IncrementalJavaScriptBundler.compile
(package:frontend_server/src/javascript_bundle.dart:246)
#18     FrontendCompiler.writeJavaScriptBundle
(package:frontend_server/frontend_server.dart:877)
<asynchronous suspension>
#19     FrontendCompiler.compile (package:frontend_server/frontend_server.dart:693)   
<asynchronous suspension>
#20     listenAndCompile.<anonymous closure>
(package:frontend_server/frontend_server.dart:1401)
<asynchronous suspension>
the Dart compiler exited unexpectedly.
Waiting for connection from debug service on Chrome...             14.3s
Failed to compile application.