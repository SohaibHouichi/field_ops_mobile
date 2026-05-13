

class UpdateCustomerParams {
  final String firstName;
  final String lastName;
  final String email;
  final int gender;
  final DateTime? birthDate;
  final String phoneNumber;
  final String addressId;
  final String note;
  UpdateCustomerParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    this.birthDate,
    required this.phoneNumber,
    required this.addressId,
    required this.note,
  });
}
