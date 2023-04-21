import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../common/apis.dart';
import '../../core/controller/im_controller.dart';
import '../../utils/data_persistence.dart';
import '../../models/wode_info.dart';


class wodeLogicdate extends GetxController {
  final imLogic = Get.find<IMController>();
  var woDeNum = 0.obs;
  var woDePages = 0;
  List woDeList = [].obs;

  @override
  void onInit() {
    super.onInit();

    ///初始化时获取朋友圈列表
    getMyInfoListByUserID();
  }


  final RefreshController refreshController =
  RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }


  ///获取用户发表的朋友圈信息
  void getMyInfoListByUserID() async {
    try {
      var tmpDate = await Apis.get_Date_By_UserID_req(userID:imLogic.userInfo.value.userID,pagesNum: 1,token: DataPersistence.getLoginCertificate()?.token);
      ///保存数据
      print("获取用户发表的朋友圈信息");
      // print(tmpDate.woDeInfoList);
      woDeList = tmpDate.woDeInfoList;
      woDeNum.value = int.tryParse(tmpDate.showNumber.toString()) ?? 0;
      woDePages = int.tryParse(tmpDate.currentPage.toString()) ?? 0;
      update();
    }catch (e) {
      print('getDateByMomentsID e: $e');
    }
  }


  ///获取新的列表 朋友圈数据
  void updateMyInfoListByUserID(var pagsIdx) async {
    try {
      var tmpDate = await Apis.get_Date_By_UserID_req(userID: imLogic.userInfo.value.userID,pagesNum: pagsIdx,token: DataPersistence.getLoginCertificate()?.token);
      ///保存数据
      print("获取新的列表 朋友圈数据");
      print(tmpDate.woDeInfoList);
      for(int i = 0; i < tmpDate.woDeInfoList.length; i++) {
        woDeList.add(tmpDate.woDeInfoList[i]);
      }
      update();
    }catch (e) {
      print('updateCommunityList e: $e');
    }
  }

}