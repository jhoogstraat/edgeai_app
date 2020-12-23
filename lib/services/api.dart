import 'package:obj_detect_board/models/ai_image.dart';

abstract class Api {
  const Api();
  Stream<AIImage> listen();
}
