import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naik_e/Data%20Layer/Data%20Models/User.dart';
import 'package:naik_e/UI%20Layer/Widgets/Dialouge.dart';

class DioServices {
  late Dio _dio;
  late BuildContext _context;
  String message = '';
  late String _token;
  final String LOGIN_USER_PATH = '/login';
  final String LOGIN_FAKE_API_TESTING = 'https://reqres.in//api/login';
  final String REGISTER_USER_PATH = '/register';
  final String mujtabaApiUrl = 'http://192.168.18.118:3000/areeb';
  //-------------------------------- Constructor ----------------------------------//

  DioServices() {
    _dio = Dio(BaseOptions(
        baseUrl: 'http://192.168.18.118:3000', connectTimeout: 30000));

    initializeInterceptors();
  }

  //-------------------------------- Interceptors ----------------------------------//

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(

        // Error Interceptor

        onError: (error, handler) {
      print('On Error Called from the Interceptors');
      // print('Error : ' + error.message.toString());

      // print(error.error);
      // apiResponse.error = true;
      // apiResponse.errorMessage = error.message.toString();
      switch (error.type) {
        case DioErrorType.cancel:
          message = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          message = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          message =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          message = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          print(error.response!.data);
          message =
              _handleError(error.response!.statusCode, error.response!.data);
          break;
        case DioErrorType.sendTimeout:
          message = "Send timeout in connection with API server";
          break;
        default:
          message = "Something went wrong";
          break;
      }

      return handler.next(error);
    },

        // Request Interceptor

        onRequest: (request, handler) {
      print('On Request Called from the Interceptors');
      print('Request Path : ' + request.path);
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      request.headers = headers;
      return handler.next(request);
    },

        // Response Interceptor

        onResponse: (response, handler) {
      print('On Response Called from the Interceptors');
      print('Response data : ' + response.data.toString());
      return handler.next(response);
    }));
  }

  //-------------------------------- Handle Error --------------------------------//
  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Request Failed';
      case 401:
        return 'Bad Request';
      case 403:
        return error["error"];
      case 404:
        return error["error"] == null ? 'Not Found' : error['error'];
      case 500:
        return 'Internal server error';
      case 502:
        return error["error"];
      default:
        return 'Oops something went wrong';
    }
  }
  //-------------------------------- Login User ----------------------------------//

  Future<bool> loginUser(User user, BuildContext context) async {
    _context = context;

    bool status = false;
    try {
      // var formData =
      //     FormData.fromMap({'email': user.email, 'password': user.password});
      Map<String, dynamic> data = {
        "user": {"email": user.email, "password": user.password}
      };

      print(data);
      Response response =
          await _dio.post(_dio.options.baseUrl + LOGIN_USER_PATH, data: data);

      print(response.data);
      print(response.data['token']);
      // _token = response.data['token'];

      // apiResponse.data = _token;
      // apiResponse.error = false;
      // apiResponse.errorMessage = '';
      status = true;
    } on DioError catch (_) {
      print('Landed on the login catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
      status = false;
    }
    return status;
  }

  //-------------------------------- Register User ----------------------------------//
  Future<bool> registerUser(User user, BuildContext context) async {
    _context = context;
    bool status = false;
    try {
      Map<String, dynamic> data = {
        "user": {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "password": user.password,
          "phone": user.contactNumber,
          "gender": user.gender,
          "dateOfBirth":
              DateFormat('yyyy-MM-dd HH:mm:ss').format(user.dateOfBirth),
        },
      };

      Response response = await _dio
          .post(_dio.options.baseUrl + REGISTER_USER_PATH, data: data);
      print(response.data);

      // sleep(const Duration(seconds: 5));
      status = true;
    } on DioError catch (_) {
      print('Landed on the sigunUp catch part');
      showTheAlertErrorDialog(_context, 'Error', message);
    }
    return status;
  }
}
