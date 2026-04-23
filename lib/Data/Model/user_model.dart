
class UserModel {
  int? step;
  String? token;
  String? loginType;
  String? userRole;
  bool? isLogin;

  UserModel({
    this.step,
    this.token,
    this.loginType,
    this.userRole,
    this.isLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    step: json["step"],
    token: json["token"],
    loginType: json["type"],
    userRole: json["role"],
    isLogin: json["islogin"],
  );

  Map<String, dynamic> toJson() => {
    "step": step,
    "token": token,
    "type": loginType,
    "role": userRole,
    "islogin": isLogin,
  };

  void clear() {
    step = null;
    token = null;
    loginType = null;
    isLogin = null;
    userRole = null;
  }

}
