import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:podcast/core/dependency/path.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:podcast/core/network/connection_checker.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/basic/error_response_model.dart';
import 'package:podcast/utils/logger/logger.dart';

final log = logger(ApiClient);

typedef ServerResponse<T> = Future<Either<ErrorResponseModel, T>>;

Map<String, String> basicHeaderInfo() {
  return {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
}

Future<Map<String, String>> bearerHeaderInfo() async {
  DBHelper dbHelper = serviceLocator();
  final token = await dbHelper.getToken();
  print(token);
  return {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
}

String noInternetConnection = "No internet connection.!";

ConnectionChecker connectionChecker = serviceLocator();

class ApiClient {
  //=========================== Get method ======================

  Future<Response> get(
      {required String url,
      bool isBasic = false,
      int duration = 30,
      bool showResult = false,
      BuildContext? context}) async {
    /// ======================- Check Internet ===================

    if (!await (connectionChecker.isConnected)) {
      log.i(
          '|📍📍📍|-----------------[[ GET ]] Internet Error $url -----------------|📍📍📍|');
      return Response(statusCode: 503, statusText: noInternetConnection);
    }

    if (showResult) {
      log.i(
          '|📍📍📍|----------------- [[ GET ]] method details start -----------------|📍📍📍|');
      log.i(url);
    }

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log.d("Body => ${response.body}");
        log.d("Status Code => ${response.statusCode}");

        log.i(
            '|📒📒📒|-----------------[[ GET ]] method response end -----------------|📒📒📒|');
      }

      var body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      toastMessage(message: 'Error Alert on Socket Exception');
      return const Response(
          body: {},
          statusCode: 400,
          statusText: 'Error Alert on Socket Exception');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return const Response(
          body: {}, statusCode: 400, statusText: 'Time out exception');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());
      if (context != null && context.mounted) {
        // context.pushNamed(RoutePath.errorScreen);
      }
      return const Response(
          body: {},
          statusCode: 400,
          statusText: 'Error Alert Client Exception');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {}, statusCode: 400, statusText: "Something went wrong");
    }
  }

  //========================== Post Method =======================
  Future<Response> post(
      {required String url,
      bool isBasic = false,
      required Map<String, dynamic> body,
      int duration = 30,
      bool showResult = true}) async {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        log.i(
            '|📍📍📍|-----------------[[ POST ]] Internet Issue $url ----$body-----------------|📍📍📍|');
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ POST ]] method details start -----------------|📍📍📍|');

        log.i("URL => $url");

        log.i("Body => $body");
      }

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log.i("response.body => ${response.body}");
      }

      log.i("response.statusCode => ${response.statusCode}");

      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      toastMessage(message: 'Error Alert on Socket Exception');
      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return Response(
          body: {}, statusCode: 400, statusText: 'Time out exception $url');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return Response(
          body: {},
          statusCode: 400,
          statusText: 'client exception hitted $url');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  Future<Response> patch(
      {required String url,
      bool isBasic = false,
      Map<String, dynamic>? body,
      int duration = 30,
      bool showResult = false}) async {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        log.i(
            '|📍📍📍|-----------------[[ PATCH ]] Internet Error $url -----------------|📍📍📍|');
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ PATCH ]] method details start -----------------|📍📍📍|');

        log.i("URL => $url");

        log.i("Body => $body");
      }

      final response = await http
          .patch(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log.i("response.body => ${response.body}");
        log.i("response.statusCode => ${response.statusCode}");
        log.i(
            '|📒📒📒|-----------------[[ PATCH ]] method response end --------------------|📒📒📒|');
      }

      body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return Response(
          body: {}, statusCode: 400, statusText: 'Time out exception $url');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return Response(
          body: {},
          statusCode: 400,
          statusText: 'client exception hitted $url');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  // Param get method
  Future<Map<String, dynamic>?> paramGet(
      {String? url,
      bool? isBasic,
      Map<String, String>? body,
      int code = 200,
      int duration = 15,
      bool showResult = false}) async {
    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method Details Start -----------------|📍📍📍|');

    log.i("##body given --> ");

    if (showResult) {
      log.i(body);
    }

    log.i("##url list --> $url");

    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method details ended ** ---------------|📍📍📍|');

    try {
      final response = await http
          .get(
            Uri.parse(url!).replace(queryParameters: body),
            headers: isBasic! ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(const Duration(seconds: 15));

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response Start---------------|📒📒📒|');

      if (showResult) {
        log.i(response.body.toString());
      }

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response End **-----------------|📒📒📒|');

      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('Time out exception$url');

      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('#url->$url||#body -> $body');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return null;
    }
  }

  Future<Response> multipartRequest(
      {required String url,
      required String reqType,
      bool isBasic = false,
      Map<String, String>? body,
      required List<MultipartBody> multipartBody,
      Function(double progress)? onProgress,
      bool showResult = true}) async {
    try {
      /// Check Internet Connection
      if (!await (connectionChecker.isConnected)) {
        log.i(
            '|📍📍📍|-----------------[[ MULTIPART ]] Internet Error $url -----------------|📍📍📍|');
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ MULTIPART $reqType]] method details start -----------------|📍📍📍|');
        log.i("===> URL => $url");
        log.i("====> body => $body");
      }

      final request = http.MultipartRequest(
        reqType,
        Uri.parse(url),
      )
        ..fields.addAll(body ?? {})
        ..headers.addAll(
          isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
        );

      if (multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          if (element.file.path.isEmpty) {
            continue;
          }
          debugPrint("path : ${element.file.path}");

          var mimeType = lookupMimeType(element.file.path);

          debugPrint("MimeType================$mimeType");

          try {
            var multipartImg = await http.MultipartFile.fromPath(
              element.key,
              element.file.path,
              contentType: MediaType.parse(mimeType!),
            );

            request.files.add(multipartImg);
          } catch (e) {
            debugPrint("Error adding file: $e");
          }
        }
      }

      // Debug: Print total files
      debugPrint('Files added to request: ${request.files.length}');

      // Send request and track progress while uploading
      final streamedResponse = await request.send();

      final totalBytes = streamedResponse.contentLength;
      int bytesUploaded = 0;

      // Debug: Log content length
      print('Total bytes to upload: $totalBytes');

      if (totalBytes == null || totalBytes <= 0) {
        print('Content length is invalid. Cannot track progress.');
      }

      final responseStream = streamedResponse.stream.transform<List<int>>(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            bytesUploaded += data.length;
            if (onProgress != null && totalBytes != null && totalBytes > 0) {
              double progress = bytesUploaded / totalBytes;
              onProgress(progress); // Report progress
              print('Progress: ${(progress * 100).toStringAsFixed(2)}%');
            }
            sink.add(data); // Forward data
          },
          handleError: (error, stackTrace, sink) {
            print('Stream error: $error');
            sink.addError(error, stackTrace);
          },
          handleDone: (sink) {
            print('Stream completed');
            sink.close();
          },
        ),
      );

      // Get the final response from the stream after upload completes
      final response = await http.Response.fromStream(
        http.StreamedResponse(responseStream, streamedResponse.statusCode),
      );

      // Debug response body
      print('Response body: ${response.body}');
      print('Status code: ${streamedResponse.statusCode}');

      if (showResult) {
        log.i("===> Response Body => ${response.body}");
        log.i("===> Status Code =>${response.statusCode}");
        log.i(
            '|📒📒📒|-----------------[[ MULTIPART $reqType ]] method response end --------------------|📒📒📒|');
      }

      var decodeBody = jsonDecode(response.body);
      return Response(
        body: decodeBody,
        statusCode: response.statusCode,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert Timeout Exception 🐞🐞🐞');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      return const Response(
          body: {}, statusCode: 400, statusText: 'client exception hitted');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  // Delete method
  Future<Response> delete(
      {String? url,
      bool isBasic = false,
      int code = 200,
      bool isLogout = false,
      int duration = 15,
      bool showResult = false}) async {
    log.i(
        '|📍📍📍|-----------------[[ DELETE ]] method details start-----------------|📍📍📍|');

    if (!await (connectionChecker.isConnected)) {
      log.i(
          '|📍📍📍|-----------------[[ DELETE ]] Internet Error $url -----------------|📍📍📍|');
      return Response(statusCode: 503, statusText: noInternetConnection);
    }
    log.i(url);

    log.i(
        '|📍📍📍|-----------------[[ DELETE ]] method details end ------------------|📍📍📍|');

    try {
      var headers = isBasic ? basicHeaderInfo() : await bearerHeaderInfo();

      log.i(headers);

      final response = await http
          .delete(
            Uri.parse(url!),
            headers: headers,
          )
          .timeout(Duration(seconds: duration));

      log.i(
          '|📒📒📒|----------------- [[ DELETE ]] method response start-----------------|📒📒📒|');

      if (showResult) {
        log.i(response.body.toString());
      }

      log.i(response.statusCode);

      log.i(
          '|📒📒📒|----------------- [[ DELETE ]] method response start-----------------|📒📒📒|');

      if (response.statusCode == code) {
        return Response(
          body: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        return Response(
          body: jsonDecode(response.body),
          statusCode: response.statusCode,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞',
        );
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('Time out exception$url');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  Future<Response> put(
      {required String url,
      bool isBasic = false,
      Map<String, dynamic>? body,
      int code = 200,
      int duration = 15,
      bool showResult = false}) async {
    try {
      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details start-----------------|📍📍📍|');

      log.i(url);
      if (!await (connectionChecker.isConnected)) {
        log.i(
            '|📍📍📍|-----------------[[ PUT ]] Internet Error $url -----------------|📍📍📍|');
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      log.i(body);

      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details end ------------|📍📍📍|');

      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response start-----------------|📒📒📒|');

      if (showResult) {
        log.i(response.body);
      }

      log.i(response.statusCode);

      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response End -----------------|📒📒📒|');

      if (response.statusCode == code) {
        final data = jsonDecode(response.body);
        return Response(
            body: data, statusCode: response.statusCode, statusText: 'Success');
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        return Response(
            body: jsonDecode(response.body),
            statusCode: response.statusCode,
            statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(body: {}, statusCode: 400, statusText: 'Success');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('Time out exception$url');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('unlisted catch error received');

      log.e(e.toString());

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }
}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}
