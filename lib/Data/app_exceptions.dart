

import '../shared/widgets/vendor_widgets/pref_utils.dart';

class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// class InternetException extends AppExceptions {
//   InternetException([String? message]) : super(message, 'No internet');
// }

// class RequestTimeOut extends AppExceptions {
//   RequestTimeOut([String? message]) : super(message, 'Request Time out');
// }

// class ServerException extends AppExceptions {
//   ServerException([String? message]) : super(message, 'Internal server error');
// }

// class InvalidUrlException extends AppExceptions {
//   InvalidUrlException([String? message]) : super(message, 'Invalid Url');
// }

class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, '');
}

// UserPreference userPreference = UserPreference();

class UnauthenticatedException extends AppExceptions {
  UnauthenticatedException([String? message]) : super(message, "Authenticated Expired") {
    PrefUtils prefUtils = PrefUtils();
    // UserModel userModel = UserModel();
     prefUtils.logout();
    // if(userModel.step != null || userModel.loginType != null  || userModel.token != null){
    //   Utils.showToast("Your Session is Expired Please Re-login");
    // }
  }
}
