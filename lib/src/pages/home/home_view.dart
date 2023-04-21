import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/contacts/contacts_view.dart';
import 'package:openim_demo/src/pages/conversation/conversation_view.dart';
import 'package:openim_demo/src/pages/mine/mine_view.dart';
import 'package:openim_demo/src/pages/wode/wode_logic.dart';
import 'package:openim_demo/src/pages/workbench/workbench_view.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/bottombar.dart';
import '../../routes/app_navigator.dart';
import '../community/community_logic.dart';
import '../plaza/plaza_view.dart';
import '../publish/publish_view.dart';
import '../shequ/shequ_view.dart';
import '../wode/index.dart';
import 'home_logic.dart';
import '../community/index.dart';


class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();
  final comlogic = Get.find<communitylogic>();
  final wodelogic = Get.find<wodeLogicdate>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Obx(() => Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: logic.index.value,
                    children: [
                      SheQuPage(),//广场
                      PageViewCommunity(),//广场
                      //PlazaPage(),//测试用广场
                      PublishPage(),//发布
                      ConversationPage(),//会话
                      //ContactsPage(),//通讯录
                      //WorkbenchPage(),//工作台
                      PageViewMine(),//我的
                      //MinePage(),
                    ],
                  ),
                ),
                BottomBar(
                  index: logic.index.value,
                  items: [
                    BottomBarItem(
                      selectedImgRes: ImageRes.ic_star_sel,
                      unselectedImgRes: ImageRes.ic_star_nor,
                      label: StrRes.starPage,
                      imgWidth: 24.w,
                      imgHeight: 25.h,
                      unselectedStyle:TextStyle(fontSize:8),
                      selectedStyle:TextStyle(fontSize:8,fontWeight: FontWeight.bold),
                      onClick: (i) => logic.switchTab(i),
                      count: logic.wechatMoments.value,
                    ),
                    BottomBarItem(
                      selectedImgRes: ImageRes.ic_plaza_sel,
                      unselectedImgRes: ImageRes.ic_plaza_nor,
                      label: StrRes.plazapage,
                      imgWidth: 24.w,
                      imgHeight: 25.h,
                      unselectedStyle:TextStyle(fontSize:8),
                      selectedStyle:TextStyle(fontSize:8,fontWeight: FontWeight.bold),
                      onClick: (i) => logic.switchTab(i),
                      count: logic.wechatMoments.value,
                    ),
                    BottomBarItem(
                      selectedImgRes: ImageRes.ic_publish_nor,
                      unselectedImgRes: ImageRes.ic_publish_sel,
                      label: StrRes.publish,
                      imgWidth: 24.w,
                      imgHeight: 25.h,
                      unselectedStyle:TextStyle(fontSize:8),
                      selectedStyle:TextStyle(fontSize:8,fontWeight: FontWeight.bold),
                      onClick: (i) => AppNavigator.startMyPublish(),
                    ),
                    BottomBarItem(
                      selectedImgRes: ImageRes.ic_chat_sel,
                      unselectedImgRes: ImageRes.ic_chat_nor,
                      label: StrRes.chat,
                      imgWidth: 24.w,
                      imgHeight: 25.h,
                      unselectedStyle:TextStyle(fontSize:8),
                      selectedStyle:TextStyle(fontSize:8,fontWeight: FontWeight.bold),
                      onClick: (i) => logic.switchTab(i),
                      count: logic.unreadMsgCount.value,
                    ),
                    BottomBarItem(
                      selectedImgRes: ImageRes.ic_wode_sel,
                      unselectedImgRes: ImageRes.ic_wode_nor,
                      label: StrRes.mine,
                      imgWidth: 24.w,
                      imgHeight: 25.h,
                      unselectedStyle:TextStyle(fontSize:8),
                      selectedStyle:TextStyle(fontSize:8,fontWeight: FontWeight.bold),
                      onClick: (i) => logic.switchTab(i),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      //FocusManager.instance.primaryFocus?.unfocus();
      print("点击空白处 关闭软键盘");
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
