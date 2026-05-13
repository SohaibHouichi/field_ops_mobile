enum Gender {
  male(1),
  female(2);

  final int value;
  const Gender(this.value);

  static Gender fromInt(int value) {
    return Gender.values.firstWhere((e) => e.value == value);
  }

  static Gender fromString(String name) {
    return Gender.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
    );
  }

  // Gender → String
  @override
  String toString() => name; // "male" or "female"
}