import 'dart:io';
import 'package:bloc_implementation/src/helper/Exceptions/api_exceptions.dart';
import 'package:bloc_implementation/src/helper/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class ApiBaseHelper {
  final String _baseUrl = ApiEndpoint.BaseApi;

  Future<dynamic> get(String url) async {
    print('------------------ Api Get, url $_baseUrl$url');
    var _apiClient = Uri.parse(_baseUrl + url);
    var responseJson;
    try {
      final response = await http.get(_apiClient);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Connection');
      throw FetchDataException(message: 'No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        // print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            message:
                'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
