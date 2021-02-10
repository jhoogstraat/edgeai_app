import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeViewModel with ChangeNotifier {}
