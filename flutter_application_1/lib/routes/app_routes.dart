import '../screens/input_screen.dart';
import '../screens/main_screen.dart';
import '../screens/splash_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static final routes = {
    RouteNames.splashScreen: (context) => const SplashScreen(),
    RouteNames.mainScreen: (context) => const MainScreen(),
    RouteNames.inputScreen: (context) => const InputScreen(),
  };
}
