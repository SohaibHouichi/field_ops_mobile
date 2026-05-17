enum ServiceRequestType {
  maintenance(1),
  repair(2),
  installation(3),
  inspection(4),
  other(5),
  unknown(-1);

  final int value;
  const ServiceRequestType(this.value);

  static ServiceRequestType fromInt(int v) => switch (v) {
        1 => maintenance,
        2 => repair,
        3 => installation,
        4 => inspection,
        5 => other,
        _ => unknown,
      };
}