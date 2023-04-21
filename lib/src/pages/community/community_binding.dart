import 'package:get/get.dart';
import 'community_logic.dart';


class PlazaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => communitylogic());
  }
}