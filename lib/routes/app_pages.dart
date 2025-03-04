import 'package:get/get.dart';
import '../ui/views/home_screen.dart';
import '../ui/views/order_screen.dart';
import '../bindings/order_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.HOME, page: () => HomeScreen()),
    GetPage(name: AppRoutes.ORDER, page: () => OrderScreen(), binding: OrderBinding()),
  ];
}
