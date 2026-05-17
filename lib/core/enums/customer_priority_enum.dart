
enum CustomerPriority {
  low(1),
  normal(2),
  high(3),
  unknown(-1);

  final int value;
  const CustomerPriority(this.value);

  static CustomerPriority fromInt(int v) => switch (v) {
        1 => low,
        2 => normal,
        3 => high,
        _ => unknown,
      };
}