import 'package:get/get_navigation/src/routes/get_route.dart';

import 'singup.dart';
import 'splash.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
  ];
}
