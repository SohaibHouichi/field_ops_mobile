class LoginResponseDto {
  String token ; 
  int id ; 
  String role ; 

  LoginResponseDto({
    required this.token,
    required this.id , 
    required this.role,
  });

   factory LoginResponseDto.fromJson(Map<dynamic, dynamic> json) {
    return LoginResponseDto(
      token: json['userToken'],
      id: json['user']['id'],
      role: json['user']['role'],
    );
  }
}