import 'package:chat_app_state/model/user_model.dart';
import 'package:flutter/widgets.dart';

final appBrain = AppBrain();

class AppBrain {

  ValueNotifier<List<UserModel>> users = ValueNotifier([]);

}