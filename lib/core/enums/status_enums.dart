enum ServiceRequestStatus {
  newRequest(1),
  accepted(2),
  rejected(3),
  scheduled(4),
  inProgress(5),
  onHold(6),
  completed(7),
  cancelled(8),
  unknown(-1);

  final int value;
  const ServiceRequestStatus(this.value);

  static ServiceRequestStatus fromInt(int v) => switch (v) {
        1 => newRequest,
        2 => accepted,
        3 => rejected,
        4 => scheduled,
        5 => inProgress,
        6 => onHold,
        7 => completed,
        8 => cancelled,
        _ => unknown,
      };
}