class LoginRequestDto {
  String username ; 
  String password ; 

  LoginRequestDto({
    required this.username,
    required this.password
  });

  Map<String , dynamic> toJson() {
    return {
      "username" : username , 
      "password" : password
    };
  } 
  
}