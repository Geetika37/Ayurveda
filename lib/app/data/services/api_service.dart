import 'dart:io';
import 'dart:developer';
import 'package:ayurvedaapp/app/core/utils/storageutil.dart';
import 'package:ayurvedaapp/app/core/utils/toasts.dart';
import 'package:ayurvedaapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class ApiService {
  late final dio.Dio _dio;

  ApiService() {
    _dio = dio.Dio(
      dio.BaseOptions(
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
      ),
    );
    _dio.interceptors.add(_AuthInterceptor());
  }

  postRequest({
    required String url,
    required Map<String, dynamic> data,
    bool navigateToLogin = true,
  }) => _sendRequest('POST', url, data: data, requiresAuth: false);

  getRequest(String url, {bool requiresAuth = false}) =>
      _sendRequest('GET', url, requiresAuth: requiresAuth);

  deleteRequest(String url, {Map<String, dynamic>? data}) =>
      _sendRequest('DELETE', url, data: data, requiresAuth: false);

  multipartRequest({
    required String url,
    required Map<String, dynamic> data,
    required File file,
    required String fileKey,
  }) => _sendRequest(
    'POST',
    url,
    data: data,
    file: file,
    fileKey: fileKey,
    requiresAuth: false,
  );

  authPostRequest({required String url, required Map<String, dynamic> data}) =>
      _sendRequest('POST', url, data: data, requiresAuth: true);

  authGetRequest({required String url}) =>
      _sendRequest('GET', url, requiresAuth: true);

  authDeleteRequest({required String url, Map<String, dynamic>? data}) =>
      _sendRequest('DELETE', url, data: data, requiresAuth: true);

  authMultipartRequest({
    required String url,
    required Map<String, dynamic> data,
    required File file,
    required String fileKey,
  }) => _sendRequest(
    'POST',
    url,
    data: data,
    file: file,
    fileKey: fileKey,
    requiresAuth: true,
  );

  Future<Map<String, dynamic>?> authMultipartRequestWithFiles({
    required String url,
    required Map<String, dynamic> data,
    required Map<String, File> files,
  }) async {
    try {
      log('Data: $data');

      final formData = dio.FormData();

      data.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            formData.fields.add(MapEntry('$key[]', item.toString()));
          }
        } else if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      for (var entry in files.entries) {
        String fileName = entry.value.path.split('/').last;
        formData.files.add(
          MapEntry(
            entry.key,
            await dio.MultipartFile.fromFile(
              entry.value.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          extra: {'requiresAuth': true},
        ),
      );

      log('Response status: ${response.statusCode}');

      return {
        'statusCode': response.statusCode,
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? 'No message provided',
        'data': response.data['data'] ?? [],
      };
    } on dio.DioException catch (e) {
      _handleDioError(e, url);
      return {
        'statusCode': e.response?.statusCode ?? 500,
        'success': false,
        'message': 'An error occurred during the request',
        'data': [],
      };
    } catch (e) {
      log('Error: $e');
      _showError('An unexpected error occurred');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'An unexpected error occurred',
        'data': [],
      };
    }
  }

  Future<Map<String, dynamic>?> authMultipleImagesUpload({
    required String url,
    required Map<String, dynamic> data,
    required List<File> images,
  }) async {
    try {
      final formData = dio.FormData.fromMap(data);

      for (var image in images) {
        formData.files.add(
          MapEntry('images[]', await dio.MultipartFile.fromFile(image.path)),
        );
      }

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {'Content-Type': 'multipart/form-data'},
          extra: {'requiresAuth': true},
        ),
      );

      return _handleResponse(response, url);
    } on dio.DioException catch (e) {
      return _handleDioError(e, url);
    } catch (e) {
      _showError('An unexpected error occurred');
      log('Error: $e');
      return null;
    }
  }

  _sendRequest(
    String method,
    String url, {
    Map<String, dynamic>? data,
    bool requiresAuth = false,
    File? file,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Set headers based on request type
      Map<String, String> headers = {'Accept': 'application/json'};

      // Only set Content-Type for non-GET requests
      if (method != 'GET') {
        headers['Content-Type'] = 'application/x-www-form-urlencoded';
      }

      final options = dio.Options(
        method: method,
        extra: {'requiresAuth': requiresAuth},
        headers: headers,
      );

      log('Data: $data');
      debugPrint('Url : $url');
      log('data : $data');

      dio.Response response;
      if (file != null && fileKey != null) {
        final formData = dio.FormData.fromMap({
          ...?data,
          fileKey: await dio.MultipartFile.fromFile(file.path),
        });
        options.headers!['Content-Type'] = 'multipart/form-data';
        response = await _dio.request(
          url,
          data: formData,
          options: options,
          queryParameters: queryParameters,
        );
      } else if (method == 'GET') {
        // For GET requests, use query parameters instead of body data
        Map<String, dynamic>? allQueryParams = {};
        if (queryParameters != null) {
          allQueryParams.addAll(queryParameters);
        }
        if (data != null) {
          allQueryParams.addAll(data);
        }

        response = await _dio.request(
          url,
          options: options,
          queryParameters: allQueryParams.isNotEmpty ? allQueryParams : null,
        );
      } else {
        // For POST/PUT/DELETE requests, convert data to form-encoded format
        String? formData;
        if (data != null) {
          formData =
              Uri(
                queryParameters: data.map((k, v) => MapEntry(k, v.toString())),
              ).query;
        }
        response = await _dio.request(
          url,
          data: formData,
          options: options,
          queryParameters: queryParameters,
        );
      }
      log('Response status code: ${response.statusCode}');
      return _handleResponse(response, url);
    } on dio.DioException catch (e) {
      return _handleDioError(e, url);
    } catch (e) {
      log('Error: $e');
      _showError('An unexpected error occurred');
      log('Error: $e');

      return null;
    }
  }

  _handleResponse(dio.Response response, String url) {
    try {
      log('Response data: ${response.data}');
      log('Response status: ${response.statusCode}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          log('Response success field: ${data['success']}');
          log('Response status field: ${data['status']}');

          if (data['success'] == true ||
              data['status'] == 'success' ||
              data['status'] == true) {
            // For login endpoint, return the entire response data as it contains token and user details
            return data['data'] ?? data;
          } else {
            log(
              'API returned success=false: ${data['message'] ?? 'No message'}',
            );
            _showError(data['message'] ?? 'Operation failed', forceShow: true);
            return null;
          }
        } else {
          log('Response is not a Map: ${response.data}');
          return response.data;
        }
      } else {
        _showError('Operation was not successful', forceShow: true);
      }
      return null;
    } catch (e) {
      log('Error parsing response: $e');
      _showError('Error processing response: $e', forceShow: true);
      return null;
    }
  }

  _handleDioError(
    dio.DioException error,
    String url, {
    bool navigateToLogin = true,
  }) async {
    String errorMessage;
    log('Dio error type: ${error.type}');
    log('Dio error: ${error.response?.data}');
    log('Dio error status code: ${error.response?.statusCode}');
    log(
      'Dio error message: ${error.response?.data is Map ? error.response?.data['message'] : error.message}',
    );
    log('Request URL: $url');
    log('Request headers: ${error.requestOptions.headers}');

    if (error.response?.statusCode == 401) {
      errorMessage =
          error.response?.data['message'] ??
          'Authentication failed: Please login again';
      await StorageUtil.clearAll();
      if (navigateToLogin) {
        Future.microtask(() => Get.offAllNamed(Routes.LOGIN));
      }
    } else {
      switch (error.type) {
        case dio.DioExceptionType.connectionTimeout:
        case dio.DioExceptionType.sendTimeout:
        case dio.DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timed out. Please try again or Restart.';
          break;
        case dio.DioExceptionType.connectionError:
          errorMessage =
              'Connection failed. Please check your internet connection.';
          break;
        case dio.DioExceptionType.badResponse:
          if (error.response?.data is Map) {
            errorMessage =
                (error.response?.data['message']?.toString() ??
                    error.response?.data['data']?.toString()) ??
                'Unknown error';
          } else if (error.response?.data is String) {
            errorMessage =
                error.response?.data ??
                error.response?.data['data']?.toString();
          } else {
            errorMessage = 'Server error: ${error.response?.statusCode}';
          }
          break;
        case dio.DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          break;
        default:
          errorMessage = 'An unexpected error occurred';
      }
    }
    _showError(errorMessage);

    return null;
  }

  void _showError(String message, {bool forceShow = false}) {
    if (forceShow) {
      Get.closeAllSnackbars();
    }
    Toasts.showError(message);
  }
}

class _AuthInterceptor extends dio.Interceptor {
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    if (options.extra['requiresAuth'] == true) {
      final token = await StorageUtil.getBearerToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }
}
