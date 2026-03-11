import 'package:get/get.dart';

import '../bindings/auth_binding.dart';
import '../../presentation/bindings/fatigue_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/license_binding.dart';
import '../../presentation/bindings/logbook_binding.dart';
import '../../presentation/views/auth/login_view.dart';
import '../../presentation/views/auth/register_view.dart';
import '../../presentation/views/fatigue/fatigue_tracking_view.dart';
import '../../presentation/views/home/home_view.dart';
import '../../presentation/views/licenses/licenses_view.dart';
import '../../presentation/views/logbook/add_flight_view.dart';
import '../../presentation/views/logbook/flight_detail_view.dart';
import '../../presentation/views/logbook/logbook_view.dart';
import '../../presentation/views/profile/profile_view.dart';
import 'app_routes.dart';

/// Maps named routes to their view widgets and bindings.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.login;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.logbook,
      page: () => const LogbookView(),
      binding: LogbookBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addFlight,
      page: () => const AddFlightView(),
      binding: LogbookBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.flightDetail,
      page: () => const FlightDetailView(),
      binding: LogbookBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.licenses,
      page: () => const LicensesView(),
      binding: LicenseBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.fatigueTracking,
      page: () => const FatigueTrackingView(),
      binding: FatigueBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
