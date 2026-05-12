import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

//import '../helpers/constants.dart';
import '../helpers/shared_pref_helper.dart';

// Interceptor to dynamically add Authorization header
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token =
        await SharedPrefHelper.getSecuredString(LocalStorageKeys.accessToken);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // It's good practice to ensure Content-Type and Accept are set if not base options.
    // However, we'll set them as base options in DioGenerate.
    return handler.next(options);
  }
}

class DioGenerate {
  static Dio? _dio; // Renamed for convention
  DioGenerate._internal();

  // getDio can now be synchronous as token fetching is deferred to the interceptor
  static Dio getDio() {
    const Duration timeout = Duration(seconds: 600); // Use const
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(baseUrl: "http://fieldopsapi.runasp.net/api" )
      );
      _dio!
        ..options.connectTimeout = timeout
        ..options.receiveTimeout = timeout;

      // Web-specific configuration for UTF-8 encoding
      if (kIsWeb) {
        _dio!.options.responseType = ResponseType.json;
        _dio!.options.validateStatus = (status) {
          return status != null && status < 500;
        };
      }

      _setStaticHeaders(); // Sets non-dynamic headers
     _addDioInterceptors(); // Adds all interceptors including AuthInterceptor
    }
    return _dio!;
  }

  // Renamed and modified to set only static headers
  static void _setStaticHeaders() {
    if (kIsWeb) {
      // Web-specific headers for proper UTF-8 handling
      _dio!.options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        'Accept-Charset': 'utf-8',
        // Authorization header will be added by AuthInterceptor
      };
    } else {
      // Mobile headers
      _dio!.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Authorization header will be added by AuthInterceptor
      };
    }
  }

  // Renamed and modified to include AuthInterceptor
  static void _addDioInterceptors() {
     _dio!.interceptors
         .add(AuthInterceptor()); // Add our custom auth interceptor
    _dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true, // Good to log errors as well
    ));
  }
}
