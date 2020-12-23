import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/api_client.dart';

final apiProvider = Provider((ref) => ApiClient());
