import 'package:get/get.dart';

import 'ion_controller.dart';
import 'meeting_logic.dart';

class MeetingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<IonController>(IonController());
    Get.lazyPut<MeetingLogic>(() => MeetingLogic());
  }
}
