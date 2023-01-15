import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:teta_cms/src/di/injector.config.dart';

///Get the Service locator instance
final getIt = GetIt.I;

/// Flag is initialized
bool diInitialized = false;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: false,
  asExtension: false,
)

/// This method configures the service locator framework. Should be called only once.
Future configureDependencies(final Environment environment) async {
  // ignore: await_only_futures
  await $initGetIt(getIt, environment: environment.name);
}
