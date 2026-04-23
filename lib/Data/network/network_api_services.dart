import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../components/internet_exception.dart';
import '../app_exceptions.dart';
import '../components/request_time_out.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  Future<dynamic> getApiWithoutToken(String url) async {
    // if (kDebugMode) {
    //   print(url);
    // }

    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": ""}).timeout(const Duration(seconds: 50));

      responseJson = returnResponse(response, url);
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> getApi(String url, String token) async {

    if (kDebugMode) {
      print("tocken@calling : ${token.toString()}");
      print("Get url@calling : ${url.toString()}");
      // print(url);
    }

    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        // "Authorization": "Bearer 3681|TpU1aTiYSTZg8TAewkRm8kAM4mci59cnodK5XkIb32fd0c6a"
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 50));

      responseJson = returnResponse(response, url);
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }


  Future<dynamic> getApiWithParams(String url, String token,{Map<String, dynamic>? queryParameters}) async {

    final uri = Uri.parse(url).replace(
      queryParameters: queryParameters?.map(
            (key, value) => MapEntry(key, value.toString()),
      ),
    );

    if (kDebugMode) {
      print("Token@calling : $token");
      print("Final URL with query: ${uri.toString()}");
    }

    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url).replace(queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      )), headers: {
        // "Authorization": "Bearer 3681|TpU1aTiYSTZg8TAewkRm8kAM4mci59cnodK5XkIb32fd0c6a",
        "Authorization": "Bearer $token",
        'Accept' : "application/json"
      }).timeout(const Duration(seconds: 50));

      responseJson = returnResponse(response, url);
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url, String token) async {
    // if (kDebugMode) {
    //   print(url);
    //   print(data);
    //
    //
    // }

    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("tocken@calling : ${token.toString()}");
        print("post url@calling : ${url.toString()}");
      }
      final response = await http
          .post(Uri.parse(url),
              headers: {
            // "Authorization": "Bearer 3681|TpU1aTiYSTZg8TAewkRm8kAM4mci59cnodK5XkIb32fd0c6a",
            "Authorization": "Bearer $token",
              }, body: data)
          .timeout(const Duration(seconds: 50));
      responseJson = returnResponse(response, url);
      if (kDebugMode) {
        print("data: $response");
      }
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }
    if (kDebugMode) {
      print("$responseJson");
    }
    return responseJson;
  }

  Future<dynamic> postApi2(var data, String url, String token) async {
    // if (kDebugMode) {
    //   print(url);
    //   print(data);
    // }

    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("tocken@calling : ${token.toString()}");
        print("post url@calling : ${url.toString()}");
      }
      final response = await http.post(Uri.parse(url),
          // headers: {"Authorization": "Bearer 3681|TpU1aTiYSTZg8TAewkRm8kAM4mci59cnodK5XkIb32fd0c6a",'Content-Type': 'application/json','Accept' : "application/json"}, body: data).timeout(const Duration(seconds: 50));
          headers: {"Authorization": "Bearer $token",'Content-Type': 'application/json','Accept' : "application/json"}, body: data).timeout(const Duration(seconds: 50));
      responseJson = returnResponse(response, url);
      if (kDebugMode) {
        print("data: $response");
      }
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }
    if (kDebugMode) {
      print("$responseJson");
    }
    return responseJson;
  }

  Future<dynamic> multipartApi({
    required String url,
    required String token,
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    dynamic responseJson;

    try {
      if (kDebugMode) {
        print("token@calling : $token");
        print("multipart url@calling : $url");
      }

      var request = http.MultipartRequest("POST", Uri.parse(url));

      /// Headers
      request.headers.addAll({
        // "Authorization": "Bearer 3681|TpU1aTiYSTZg8TAewkRm8kAM4mci59cnodK5XkIb32fd0c6a",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      /// Add normal form fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      /// Add files
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,        // field name
              entry.value.path, // file path
            ),
          );
        }
      }

      /// Send request
      var streamedResponse =
      await request.send().timeout(const Duration(seconds: 60));

      /// Convert to normal response
      final response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response, url);
    } on SocketException {
      throw InternetExceptionWidget(
        onPress: () {},
      );
    } on RequestTimeOut {
      throw RequestTimeOut(
        onPress: () {},
      );
    }

    if (kDebugMode) {
      print("Multipart Response => $responseJson");
    }

    return responseJson;
  }




  dynamic returnResponse(http.Response response, String url) {
    if (kDebugMode) {
      log("----------->>>>>>>>$url -----------------------------------status code- ${response.statusCode}");
      // print("response.statusCode ${response.statusCode}");
    }
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 422:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 403:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 302:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 404:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 409:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 503:
        throw UnauthenticatedException();
      case 500:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 405:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 501:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        throw FetchDataException(
            'Error occurred while communicating with server ${response.statusCode}');
      // default:
      //   dynamic responseJson = jsonDecode(response.body);
      //   return responseJson;
    }
  }
}
