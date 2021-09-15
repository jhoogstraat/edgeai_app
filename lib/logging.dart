import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

void initLogger() {
  Logger.root.level = Level.OFF; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class RiverpodLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    print('''didAddProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$value"
}''');
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) {
    print('''didDisposeProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
}''');
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''didUpdateProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
