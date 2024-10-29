import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:tradinity/core/di/remote_container.dart';
import 'package:tradinity/core/network/network_constants.dart';
import 'package:tradinity/core/utils/custom_logger.dart';

import '../network/network_client.dart';
import '../network/network_info.dart';
import 'domain_container.dart';

final sl = GetIt.I;

Future<void> initDI() async {
  sl.allowReassignment = true;
  await _initAPIKeyHelper();
  await _initDIOHelper();
  initRemoteDI();
  initDomainDI();


  //Custom Logger
  sl.registerLazySingleton(() => CustomLogger());

  // Network Client.
  sl.registerLazySingleton(() => NetworkClient(
        logger: sl(),
        dio: sl(),
      ));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

Future<void> _initDIOHelper() async {
  Dio _dio = Dio();

  BaseOptions baseOptions = BaseOptions(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      baseUrl: kBaseUrl,
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
      maxRedirects: 2);

  _dio.options = baseOptions;

  (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  _dio.interceptors.clear();

  if (sl.isRegistered<Dio>()) {
    await sl.unregister<Dio>();
  }

  sl.registerLazySingleton(() => _dio);
}

_initAPIKeyHelper() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Error loading .env file: $e");
  }
}
