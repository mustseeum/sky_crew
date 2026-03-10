import 'package:get/get.dart';

/// Controls which bottom nav tab is selected.
class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}
