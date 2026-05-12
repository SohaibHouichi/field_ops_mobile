import 'dart:convert';
import 'package:field_ops/features/auth/data/models/login_response_model.dart';
import '../../../../core/helpers/shared_pref_helper.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(LoginResponseModel user);
  Future<LoginResponseModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(LoginResponseModel user) async {
    await SharedPrefHelper.setSecuredString(
      LocalStorageKeys.accessToken,
      user.accessToken,
    );
    await SharedPrefHelper.setData(LocalStorageKeys.userId, user.userId);
    await SharedPrefHelper.setData(LocalStorageKeys.username, user.username);
    await SharedPrefHelper.setData(LocalStorageKeys.email, user.email);
    await SharedPrefHelper.setData(LocalStorageKeys.role, user.role);
    await SharedPrefHelper.setData(
      LocalStorageKeys.tenantInfo,
      jsonEncode(user.tenantInfo.toJson()),
    );
  }

  @override
  Future<LoginResponseModel?> getCachedUser() async {
    final token = await SharedPrefHelper.getSecuredString(LocalStorageKeys.accessToken);
    if (token.isEmpty) return null;
    final userId   = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
    final username = await SharedPrefHelper.getString(LocalStorageKeys.username);
    final email    = await SharedPrefHelper.getString(LocalStorageKeys.email);
    final role     = await SharedPrefHelper.getString(LocalStorageKeys.role);
    final tenantJson = await SharedPrefHelper.getString(LocalStorageKeys.tenantInfo);

    if (username.isEmpty || email.isEmpty || tenantJson.isEmpty) return null;

    return LoginResponseModel.fromJson({
      'userId': userId,
      'username': username,
      'email': email,
      'role': role,
      'accessToken': token,
      'tenantInfo': jsonDecode(tenantJson),
    });
  }

  @override
  Future<void> clearUser() async {
    await SharedPrefHelper.removeSecuredData(LocalStorageKeys.accessToken);
    await SharedPrefHelper.removeData(LocalStorageKeys.userId);
    await SharedPrefHelper.removeData(LocalStorageKeys.username);
    await SharedPrefHelper.removeData(LocalStorageKeys.email);
    await SharedPrefHelper.removeData(LocalStorageKeys.role);
    await SharedPrefHelper.removeData(LocalStorageKeys.tenantInfo);
  }
}