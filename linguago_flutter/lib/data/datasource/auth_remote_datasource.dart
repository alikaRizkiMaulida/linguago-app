//ngehandling public function
import 'package:dartz/dartz.dart';
import 'package:linguago_flutter/core/constants/variable.dart';
import 'package:linguago_flutter/data/datasource/auth_lokal_datasource.dart';
import 'package:linguago_flutter/data/model/request/login_request.dart';
import 'package:linguago_flutter/data/model/response/auth_response.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel dataLogin,
  ) async {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: dataLogin.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  //untuk logout
  Future<Either<String, String>> logout() async {
    final authData = await AuthLokalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      return Right('Logout Berhasil');
    } else {
      return Left(response.body);
    }
  }
}
