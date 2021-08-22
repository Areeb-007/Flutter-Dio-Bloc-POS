class User {
  int _id;
  String _username;
  String _email;
  String _contactNumber;
  String _qualification;
  String _password;
  double _salary;

  User(this._id, this._username, this._email, this._contactNumber,
      this._qualification, this._password, this._salary);

  // setters

  set id(int id) {
    this._id = id;
  }

  set username(String username) {
    this._username = username;
  }

  set email(String email) {
    this._email = email;
  }

  set contactNumber(String contactNumber) {
    this._contactNumber = contactNumber;
  }

  set qualification(String qualification) {
    this._qualification = qualification;
  }

  set password(String password) {
    this._password = password;
  }

  set salary(double salary) {
    this._salary = salary;
  }

  //getters
  int get id => this._id;
  String get username => this._username;
  String get email => this._email;
  String get contactNumber => this._contactNumber;
  String get qualification => this._qualification;
  String get password => this._password;
  double get salary => this._salary;
}
