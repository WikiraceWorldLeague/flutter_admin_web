lib/features/reservations/presentation/pages/reservations_page.dart:570:30: Error: Member not found: 'pending'.
      case ReservationStatus.pending:
                             ^^^^^^^
lib/features/reservations/data/reservations_repository.dart:304:37: Error: Member not found: 'pending'.
        'status': ReservationStatus.pending.dbValue,
                                    ^^^^^^^
lib/features/reservations/presentation/pages/reservations_page.dart:569:13: Error: The type 'ReservationStatus' is not exhaustively matched by
the switch cases since it doesn't match 'ReservationStatus.pendingAssignment'.
 - 'ReservationStatus' is from 'package:flutter_admin_web/features/reservations/domain/reservation_models.dart'
 ('lib/features/reservations/domain/reservation_models.dart').
Try adding a default case or cases that match 'ReservationStatus.pendingAssignment'.
    switch (status) {
            ^