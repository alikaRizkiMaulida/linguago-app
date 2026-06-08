import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago_flutter/data/model/response/auth_response.dart';

class AuthLokalDatasource {
  // simpan data yg login
  Future<void> saveAuthData(AuthResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', data.toJson());
  }

  //remove data yg login
  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
  }

  //ambil data yg login
  Future<AuthResponseModel> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception('data auth tidak ditemukan');
    }
  }

  //cek apakah user udah login atau belum
  Future<bool> isLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey('auth_data');
  }
}
