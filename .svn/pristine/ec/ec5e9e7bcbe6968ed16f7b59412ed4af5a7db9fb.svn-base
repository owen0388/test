import 'package:get/get.dart';

import '../../../../core/controller/im_controller.dart';
import '../../chat_logic.dart';

class quickStartLogic extends GetxController {

  final imLogic = Get.find<IMController>();

  var roomid = "";
  var extension = "";
  var description = "";

  var parameterVideo;

  @override
  void onInit() {
    var arguments = Get.arguments;
    parameterVideo = arguments;

    print("#####-canshu");
    super.onInit();
  }


  ///获取自己的Userid
  String getMySelfUserID()
  {
    String myUserId = imLogic.userInfo.value.userID.toString();
    return myUserId;
  }

  ///获取别人的Userid
  String getVedioOtherUserID()
  {
    // String myUId = logicext.uid.toString();
    // return myUId;
    return "";
  }

  ///设定房间ID，为自己的UserID
  String getVideoRoomID(){
    String myUserId = imLogic.userInfo.value.userID.toString();
    return myUserId;
  }

}