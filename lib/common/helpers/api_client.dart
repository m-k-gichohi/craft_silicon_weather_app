import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio();
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<Response> post(
      String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer $token"
          },
        ),
        data: data,
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      _handleGeneralException(e);
      rethrow;
    }
  }

  Future<Response> get(
      String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer $token"
          },
        ),
        data: data,
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      _handleGeneralException(e);
      rethrow;
    }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      // okotaPayLocator<NavigationService>()
      //     .showSnackBar(message: 'Request timed out.');
    } else if (e.type == DioExceptionType.badResponse) {
      // OKOTALogger.log(e);
      final errorResponse = e.response;
      if (errorResponse != null && errorResponse.data != null) {
        final errorMessage = errorResponse.data['mesage'];
        if (errorMessage != null) {
          // okotaPayLocator<NavigationService>().showSnackBar(
          //   message: errorMessage,
          //   backgroundColor: REDDISH,
          // );
        }
      }
    }
  }

  void _handleGeneralException(dynamic e) {
    // okotaPayLocator<NavigationService>()
    //     .showSnackBar(message: 'Error Uploading. Please retry');
  }
}
