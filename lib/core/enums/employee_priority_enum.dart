enum EmployeePriority {
  low(1),
  medium(2),
  high(3),
  urgent(4),
  unknown(-1);

  final int value;
  const EmployeePriority(this.value);

  static EmployeePriority fromInt(int v) => switch (v) {
        1 => low,
        2 => medium,
        3 => high,
        4 => urgent,
        _ => unknown,
      };
}