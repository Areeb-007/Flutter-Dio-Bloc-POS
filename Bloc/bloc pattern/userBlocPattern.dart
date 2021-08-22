//TODO: imports
//TODO: List of Users
//TODO: Stream Controllers
//TODO: Stream Sink getters
//TODO: Constructor - add data; listen to changes
//TODO: Core Functions
//TODO: dispose

import 'dart:async';

import 'package:bloc_pattern/models/User.dart';
import 'package:dio/dio.dart';

class UserBloc {
  var dio;
  List<User> _userList = [
    User(1, '_username 1', '_email', '_contactNumber', '_qualification',
        '_password', 2100),
    User(2, '_usersname 2', '_email', '_contactNumber', '_qualification',
        '_password', 2101),
    User(3, '_usersname 3', '_email', '_contactNumber', '_qualification',
        '_password', 2107),
  ];
  final _userListStreamController = StreamController<List<User>>();
  final _userIncrementSalaryStreamController = StreamController<User>();
  final _userDecrementSalaryStreamController = StreamController<User>();

  Stream<List<User>> get userListStream => _userListStreamController.stream;
  StreamSink<List<User>> get userListStreamSink =>
      _userListStreamController.sink;
  StreamSink<User> get userIncrement =>
      _userIncrementSalaryStreamController.sink;
  StreamSink<User> get userDecrement =>
      _userDecrementSalaryStreamController.sink;

  void loadUpData() async {
    final response;
    try {
      //404
      response =
          await dio.get('https://localhost:44377/api/Employee/getEmployees');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        // print(e.response!.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.request);
        print(e.message);
      }
    }
  }

  UserBloc() {
    dio = Dio();
    loadUpData();
    _userListStreamController.add(_userList);
    _userIncrementSalaryStreamController.stream.listen(_increment);
    _userDecrementSalaryStreamController.stream.listen(_decrement);
  }

  void _increment(User user) {
    double salary = user.salary;
    double increment = salary * 0.20;
    _userList.where((element) => element.id == user.id).first.salary =
        increment + salary;
    userListStreamSink.add(_userList);
  }

  void _decrement(User user) {
    double salary = user.salary;
    double increment = salary * 0.20;
    _userList.where((element) => element.id == user.id).first.salary =
        increment - salary;
    userListStreamSink.add(_userList);
  }

  void dispose() {
    _userListStreamController.close();
    _userIncrementSalaryStreamController.close();
    _userDecrementSalaryStreamController.close();
  }
}
