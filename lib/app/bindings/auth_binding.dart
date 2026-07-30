import 'package:get/get.dart';

/// Auth binding — AuthController is already registered globally in InitialBinding
/// as a permanent singleton. No additional registration needed here.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is already permanent; registering it here would recreate
    // it on every login/register navigation, restarting _tryAutoLogin().
  }
}
