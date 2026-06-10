import 'dart:convert';
import 'package:linguago_flutter/core/constants/variable.dart';
import 'package:linguago_flutter/data/model/request/login_request_model.dart';
import 'package:linguago_flutter/data/model/response/auth_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  // Function to login
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel data,
  ) async {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: data.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // Function to register
  Future<Either<String, AuthResponseModel>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': name,
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
