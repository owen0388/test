import 'package:get/get.dart';
import '../community/community_logic.dart';
import 'publish_logic.dart';


class PublishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublishLogic());
    Get.lazyPut(() => communitylogic());
  }
}