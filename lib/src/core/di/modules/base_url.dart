import 'package:injectable/injectable.dart';

abstract class BaseUrl {
  String get url;
}

@prod
@Injectable(as: BaseUrl)
class ProdBaseUrl implements BaseUrl {
  @override
  String get url => 'https://cms.teta.so:9840';
}

