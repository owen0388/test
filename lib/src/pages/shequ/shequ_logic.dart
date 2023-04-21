import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../common/apis.dart';
import '../../utils/data_persistence.dart';

class SheQuLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  var rtcRoomlist = [].obs; //房间列表
  var chatTextlist = [].obs; //文本消息列表
  // var sheQuGlobalList = [].obs; //成员列表
  RxList<ZegoUser> sheQuGlobalList = RxList<ZegoUser>([]);
  var rtcpageCount = 0;
  List<String> myTouXiangList = [];
  @override
  void onInit() {
    super.onInit();
  }

  ///获取自己的Userid
  String getMySelfUserID() {
    String myUserId = imLogic.userInfo.value.userID.toString();
    return myUserId;
  }

  ///获取自己的Userid
  String getMySelfNickName() {
    String NickName = imLogic.userInfo.value.nickname.toString();
    return NickName;
  }

  ///获取自己的头像
  String getMySelffaceURL() {
    String faceURL = imLogic.userInfo.value.faceURL.toString();
    return faceURL;
  }

  void getOtherUserInfo() async {
    try {
      await OpenIM.iMManager.userManager
          .getUsersInfo(uidList: myTouXiangList.toList())
          .then((value) {});
    } catch (e) {
      print('获取所有的房间 e: $e');
    }
  }

  ///创建房间
  void sheQuCreateRooms(String? title, String? describle) async {
    try {
      Map<String, dynamic> tmpDate = await Apis.get_shequ_createrooms_req(
          userID: imLogic.userInfo.value.userID,
          titletxt: title,
          describletxt: describle);

      rtcRoomlist.insert(0, tmpDate["data"]);

      IMWidget.showToast('创建成功');
      Get.back();
      // //下一页 获取新页面数据
      // SheQuGetAllRooms(rtcpageCount + 1);
    } catch (e) {
      print('创建房间 e: $e');
    }
  }

  ///获取所有的房间
  void sheQuGetAllRooms(int? mypageNumber) async {
    try {
      Map<String, dynamic> tmpDate =
          await Apis.get_shequ_allrooms_req(pageNumber: mypageNumber);

      // rtcRoomlist.value = RxList.from(tmpDate["data"]["rtcRooms"]);

      if (tmpDate["data"]["rtcRooms"].length == 0) {
        print("无数据了");
        return;
      }

      rtcRoomlist.insertAll(0, tmpDate["data"]["rtcRooms"]);
      print("获取所有的房间 $rtcRoomlist");
      print("${rtcRoomlist.length}");
      rtcpageCount = rtcpageCount + 1;
    } catch (e) {
      print('获取所有的房间 e: $e');
    }
  }
}
