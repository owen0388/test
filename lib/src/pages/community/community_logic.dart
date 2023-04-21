import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../common/apis.dart';
import '../community/page_view/recommend/index.dart';

class communitylogic extends GetxController {
  final imLogic = Get.find<IMController>();
  var friendCircleNum = 0.obs;
  var friendCirclePages = 0;
  List friendCircleList = [].obs;
  var applicationList = <FriendApplicationInfo>[].obs;
  var canSeeMore = false.obs;

  @override
  void onInit() {
    super.onInit();

    ///初始化时获取朋友圈列表
    getCommunityList();
    getGuanZhuList();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // setState(() {
    //   MockLike.clear();
    //   items = MockLike.get();
    // });
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if (items.length > 60) {
    //   _refreshController.loadNoData();
    // }

    // setState(() {
    //   items = MockLike.get();
    // });
    refreshController.loadComplete();
  }

  ///获取第一列表 朋友圈数据
  void getCommunityList() async {
    try {
      var tmpDate = await Apis.getWechatMomentsList(
          uid: imLogic.userInfo.value.userID,
          token: DataPersistence.getLoginCertificate()?.token,
          pagesNum: 1);

      ///保存数据
      print("获取第一列表 朋友圈数据");
      // print(tmpDate.communityList);
      friendCircleList = tmpDate.communityList;
      friendCircleNum.value = int.tryParse(tmpDate.showNumber.toString()) ?? 0;
      friendCirclePages = int.tryParse(tmpDate.currentPage.toString()) ?? 0;
      update();
    } catch (e) {
      print('getCommunityList e: $e');
    }
  }

  ///获取新的列表 朋友圈数据
  void updateCommunityList(var pagsIdx) async {
    try {
      var tmpDate = await Apis.getWechatMomentsList(
          uid: imLogic.userInfo.value.userID,
          token: DataPersistence.getLoginCertificate()?.token,
          pagesNum: pagsIdx);

      ///保存数据
      print("获取新的列表 朋友圈数据");
      // print(tmpDate.communityList);
      for (int i = 0; i < tmpDate.communityList.length; i++) {
        friendCircleList.add(tmpDate.communityList[i]);
      }
      update();
    } catch (e) {
      print('updateCommunityList e: $e');
    }
  }

  ///获取某一个朋友圈数据通过朋友圈ID
  void getDateByMomentsID(String? workMomentID) async {
    try {
      Map<String, dynamic> tmpDate = await Apis.get_Date_By_MomentsID_req(
          workMomentID: workMomentID,
          token: DataPersistence.getLoginCertificate()?.token);

      ///保存数据
      print("获取某一个朋友圈数据通过朋友圈ID");
      for (int i = 0; i < friendCircleList.length; i++) {
        if (friendCircleList[i]["workMomentID"] ==
            tmpDate["data"]["workMoment"]["workMomentID"]) {
          print("找到相同的ID");
          friendCircleList[i] = tmpDate["data"]["workMoment"];
        }
      }
      update();
    } catch (e) {
      print('getDateByMomentsID e: $e');
    }
  }

  ///获取评论列表
  // void getCommentListDate(var uid) async {
  //   try {
  //     var tmpDate = await Apis.get_CommentListDate_req(content: imLogic.userInfo.value.userID, token: DataPersistence.getLoginCertificate()?.token,replyUserID:imLogic.userInfo.value.userID);
  //     ///保存数据
  //     print("获取评论列表");
  //
  //   }catch (e) {
  //     print('getCommentListDate e: $e');
  //   }
  // }

  ///发表一个评论
  void publistOneComment(String? textDate, String? workMomentID) async {
    try {
      print(textDate);
      print(workMomentID);
      var tmpDate = await Apis.publist_OneComment_req(
          content: textDate,
          operationID: imLogic.userInfo.value.userID,
          replyUserID: imLogic.userInfo.value.userID,
          workMomentID: workMomentID,
          token: DataPersistence.getLoginCertificate()?.token);

      ///保存数据
      print("发表一个评论");

      getDateByMomentsID(workMomentID);
    } catch (e) {
      print('publistOneComment e: $e');
    }
  }

  ///点赞一个评论
  void praiseOneComment(String? textDate, String? workMomentID) async {
    try {
      print(textDate);
      print(workMomentID);
      var tmpDate = await Apis.praise_OneComment_req(
          content: textDate,
          operationID: imLogic.userInfo.value.userID,
          replyUserID: imLogic.userInfo.value.userID,
          workMomentID: workMomentID,
          token: DataPersistence.getLoginCertificate()?.token);

      ///保存数据
      print("点赞一个评论");

      getDateByMomentsID(workMomentID);
    } catch (e) {
      print('praiseOneComment e: $e');
    }
  }

  ///关注一个用户
  void careOneCommentReq(String? careUserID) async {
    //发送关注请求
    OpenIM.iMManager.friendshipManager
        .addFriend(uid: careUserID.toString(), reason: "他/她关注了您)");
    getGuanZhuList();
  }

  ///取消关注一个用户
  void CancelCareOneCommentReq(String? careUserID) async {
    //取消关注请求
    for (var i = 0; i <= applicationList.length - 1; i++) {
      if (applicationList[i].toUserID == careUserID) {
        applicationList.removeAt(i);
      }
    }

    //删除元素
    print("-----------------------------");
    print(applicationList);

    // OpenIM.iMManager.friendshipManager.refuseFriendApplication(uid:careUserID.toString());
  }

  ///获取关注列表
  Future<List<FriendApplicationInfo>> getGuanZhuList() async {
    var list =
        await OpenIM.iMManager.friendshipManager.getSendFriendApplicationList();
    applicationList
      ..clear()
      ..addAll(list /*.map((e) => e)*/);
    canSeeMore.value = list.length > 4;
    print("获取关注列表");
    // print(applicationList[0].toJson());
    return applicationList;
  }
}
