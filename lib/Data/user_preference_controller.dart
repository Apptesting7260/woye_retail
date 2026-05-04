import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/widgets/vendor_widgets/print.dart';
import 'Model/user_model.dart';

class UserPreference {

  Future<bool> saveUser(UserModel responseModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', responseModel.token.toString());
    sp.setBool('isLogin', responseModel.isLogin!);
    sp.setInt('Step', responseModel.step!);
    sp.setString('loginType', responseModel.loginType!);
    sp.setString('role', responseModel.loginType!);
    debugPrint('token ===>>> ${sp.getString('token')}');
    debugPrint('TOKEN SAVED ===>>> ${sp.getString('token')}');
    debugPrint('TYPE SAVED ===>>> ${sp.getString('loginType')}');
    debugPrint('STEP SAVED ===>>> ${sp.getInt('Step')}');

    return true;
  }

  Future<void> saveStep(int step) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('Step', step);
  }
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  Future<void> saveIsLogin(bool isLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', isLogin);
  }
  Future<void> saveLoginType(String saveLoginType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginType', saveLoginType);
  }

  Future<UserModel> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    bool? isLogin = sp.getBool('isLogin');
    int? step = sp.getInt('Step');
    String? loginType = sp.getString('loginType');
    String? role = sp.getString('role');
    return UserModel(token: token, isLogin: isLogin, step: step, loginType: loginType,userRole: role);
  }

  Future<bool> saveUserRole(String role) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool success = await sp.setString("role", role.toLowerCase());
    pt("Saved Login Type (role) >>> $role");
    return success;
  }

  Future<bool> savePermissionsList(List<String>? permissions) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool success = await sp.setStringList("permissions", permissions ?? []);
    pt("Saved Login permissions >>> $permissions");
    return success;
  }

 static Future<List<String>> getPermissionsList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String>? savedPermissions = sp.getStringList("permissions");
    pt("Saved Login permissions >>> $savedPermissions");

    return savedPermissions ?? [];
  }


  static Future<String> getUserRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    pt("user role ${sp.getString('role')}");
    return sp.getString('role') ?? "";
  }

 static Future<String> getLoginType() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('loginType') ?? "";
  }

  Future<bool> removeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('Step');
    sp.remove('loginType');
    sp.remove('token');
    sp.remove('permissions');
    sp.clear();
    return true;
  }

  Future<Map<String, dynamic>> getPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    bool? isLogin = sp.getBool('isLogin');
    int? step = sp.getInt('Step');
    String? loginType = sp.getString('loginType');

    return {
      'token': token,
      'isLogin': isLogin,
      'step': step,
      'loginType': loginType,
    };
  }
}
