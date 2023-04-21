import 'package:get/get.dart';
import 'package:openim_demo/src/pages/contacts/contacts_logic.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/pages/mine/mine_logic.dart';
import 'package:openim_demo/src/pages/wode/wode_logic.dart';
import 'package:openim_demo/src/pages/workbench/workbench_logic.dart';
import '../community/community_logic.dart';

import 'home_logic.dart';
import '../plaza/plaza_logic.dart';
import '../publish/publish_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => WorkbenchLogic());
    Get.lazyPut(() => PlazaLogic());
    Get.lazyPut(() => PublishLogic());
    Get.lazyPut(() => communitylogic());
    Get.lazyPut(() => wodeLogicdate());
  }
}
