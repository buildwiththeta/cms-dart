import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Dio Module
@module
abstract class DioModule {
  ///Dio Module
  Dio get dio => Dio();
}
