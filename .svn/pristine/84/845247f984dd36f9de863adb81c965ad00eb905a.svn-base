import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import '../../common/apis.dart';
import '../../common/mytools.dart';
import '../../core/controller/im_controller.dart';
import '../../models/publish_info.dart';
import '../../utils/data_persistence.dart';
import '../../widgets/im_widget.dart';
import '../community/community_logic.dart';
import '../home/home_logic.dart';

class PublishLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final logic = Get.find<HomeLogic>();
  final commlogic = Get.find<communitylogic>();
  var picNumber = 1.obs;
  late WechatMomentsInfo TmpInfo;

  List aaa = [];

  @override
  void onInit() {
    super.onInit();
  }

  String toJson(String text,List<String> picDate1,List<String> picDate2) {
    print("@@@@@@@@@@@@@@@");
    final Map<dynamic, dynamic> data = new Map<String, dynamic>();
    if(text.isEmpty == false){
      data['text'] = text;
    }else{
      data['text'] = " ";
    }
    data['picDate1'] = picDate1;//缩略图
    data['picDate2'] = picDate2;//原图

    print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
    // print(json.encode(data));
    return json.encode(data);
  }


  //上传图片，并发布
  void pubListFunc(String text,List<File> picDate) async {
    print("--------上传图片------");
    //图片标记
    int flagNum1 = 0;
    int flagNum2 = 0;

    //得到
    List<String> tmpList1 = [];
    List<String> tmpList2 = [];

    try {
        //先上传缩略图
        print("--------上传缩略图------");
        for(var i=0;i < picDate.length;i++){
          try{
            File? newFile = await compressAndGetPic(picDate[i]);
            var resp1 = await Apis.uploadOenImage(path:newFile!.path);
            var data1 = resp1.data;
            if(data1["errCode"] == 0){
              flagNum1 = flagNum1 + 1;
              tmpList1.add(data1["data"]["URL"]);
              print("--------1----{$i}");
              // print(data1);
              // print(flagNum1);
              // print(tmpList1);
              print("--------1----{$i}");
            }
          }catch (e) {
            print('uploadOenImage1 e: $e');
          }
        }


        //上传原图
        print("--------上传原图------");
        if(flagNum1 == picDate.length){
          for(var i=0;i < picDate.length;i++){
            try{
              var resp2 = await Apis.uploadOenImage(path:picDate[i].path);
              var data2 = resp2.data;
              if(data2["errCode"] == 0){
                flagNum2 = flagNum2 + 1;
                tmpList2.add(data2["data"]["URL"]);
                print("--------2-----{$i}");
                // print(data2);
                // print(flagNum2);
                // print(tmpList2);
                print("--------2-----{$i}");
              }
            }catch (e) {
              print('uploadOenImage2 e: $e');
            }
          }
        }


        if(flagNum1 == picDate.length && flagNum2 == picDate.length){
          try{
            print("--------转Json格式------");
            var contentJson = toJson(text,tmpList1,tmpList2);
            print("--------正式发布------");
            var data = await Apis.PublistOneWeChatMoments(
              uid: imLogic.userInfo.value.userID,
              myName: imLogic.userInfo.value.nickname,
              faceUrl: imLogic.userInfo.value.faceURL,
              content:contentJson.toString(),
              token: DataPersistence.getLoginCertificate()?.token,
            );
            if(data.errCode == 0){
              print("--------发布成功------");
              IMWidget.showToast("发布成功");
              try {
                commlogic.getCommunityList();/// 刷新朋友圈列表
                Get.back();///返回到之前界面
              }catch (e) {
                print('getCommunityList e: $e');
              }
            }else{
              print("--------发布失败------");
              IMWidget.showToast("发布失败");
            }
          }catch (e){
            print('PublistOneWeChatMoments e: $e');
          }
        }
    }catch (e) {
      print('pubListFunc e: $e');
    }
  }
}