class CurrentUser {
  String token;
  String emailID;
  String phone;
  String unitNo;
  String buildingName;
  bool isAdmin;

  CurrentUser(this.token, this.emailID, this.phone, this.unitNo,
      this.buildingName, this.isAdmin);

  CurrentUser.fromJson(Map<dynamic, dynamic> json)
      : token = json['token'],
        emailID = json['user_id'],
        phone = json['phoneNo'],
        unitNo = json['unitNo'],
        buildingName = json['buildingName'],
        isAdmin = json['isAdmin'];
}

class SecurityUserJson {
  String _name;
  String _unit;
  String _mobile;
  String _email;
  String _user;
  String _remarks;
  String _date;
  String _time;

  SecurityUserJson(this._name, this._unit, this._remarks, this._email,
      this._mobile, this._user, this._date, this._time);

  Map toJson() {
    return {
      'Name': _name.toString(),
      'Unit': _unit.toString(),
      'MobileNumber': _mobile.toString(),
      'user': _user.toString(),
      'Remarks': _remarks.toString(),
      'VisitorMailID': _email.toString(),
      'Date': _date.toString(),
      'Time': _time.toString(),
    };
  }
}

class UserJson {
  String _username;
  String _password;
  String _emailID;

  UserJson(this._username, this._password, this._emailID);

  Map toJson() {
    return {
      'username': _username.toString(),
      'password': _password.toString(),
      'email': _emailID.toString(),
    };
  }
}

class UserDtails {
  var _user;
  String _phoneNo;
  String _unitNo;
  String _buildingName;
  String _isAdmin;

  UserDtails(this._user, this._phoneNo, this._unitNo, this._buildingName,
      this._isAdmin);

  Map toJson() {
    return {
      'user': _user,
      'phoneNo': _phoneNo.toString(),
      'unitNo': _unitNo.toString(),
      'buildingName': _buildingName.toString(),
      'isAdmin': _isAdmin.toString(),
    };
  }
}

class UpdatePasswordDetails {
  String _currentpPassword;
  String _newPassword;
  String _confirmPassword;

  UpdatePasswordDetails(
      this._currentpPassword, this._newPassword, this._confirmPassword);

  Map toJson() {
    return {
      'Oldpassword': _currentpPassword.toString(),
      'NewPassword': _newPassword.toString(),
      'ConfirmPassword': _confirmPassword.toString(),
    };
  }
}

class ForgotPasswordemail {
  String _emailID;

  ForgotPasswordemail(this._emailID);

  Map toJson() {
    return {
      'email': _emailID.toString(),
    };
  }
}

class ForgotPasswordOTP {
  String _emailID;
  String _otp;
  String _newPassword;
  String _confirmPassword;

  ForgotPasswordOTP(
      this._emailID, this._otp, this._newPassword, this._confirmPassword);

  Map toJson() {
    return {
      'email': _emailID.toString(),
      'token': _otp.toString(),
      'new_password': _newPassword.toString(),
      'confirm_password': _confirmPassword.toString(),
    };
  }
}
