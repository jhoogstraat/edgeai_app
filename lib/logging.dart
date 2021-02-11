import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

void setLogger() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class RiverpodLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase provider, Object value) {
    print('''didAddProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$value"
}''');
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    print('''didDisposeProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
}''');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object newValue) {
    print('''didUpdateProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
