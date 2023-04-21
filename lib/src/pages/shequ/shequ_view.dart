import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openim_demo/src/pages/shequ/shequ_logic.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../common/Global.dart';
import '../../widgets/avatar_view.dart';
import '../../widgets/im_widget.dart';
import '../chat/QuickStart/quick_start/quickutils/keycenter.dart';
import '../chat/QuickStart/quick_start/quickutils/zego_config.dart';
import '../wcao/ui/theme.dart';

///------------------------------------------
///群聊社区
///------------------------------------------
class SheQuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("综合社区",
              style: TextStyle(
                color: WcaoTheme.base,
                fontSize: WcaoTheme.fsXl,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            chatRoom(context),
            // SizedBox(height: 10),
            // chatRoom(context),
            // SizedBox(height: 10),
            // chatRoom(context),
          ],
        ));
  }

  ///语聊房
  Widget chatRoom(BuildContext context) {
    //获取Logic
    Get.lazyPut(() => SheQuLogic());
    var mySheQulogc = Get.find<SheQuLogic>();

    //返回容器组件
    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10), // 上下左右间距都为10
      color: Colors.yellow,
      child: InkWell(
        child: Image.asset(
          'assets/zpic002.png',
          fit: BoxFit.fill,
        ),
        onTap: () {
          mySheQulogc.sheQuGetAllRooms(1);
          // 点击按钮时执行的操作
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => hottopicPage(),
            ),
          );
        },
        highlightColor: Colors.transparent, // 去掉选中效果
        splashColor: Colors.transparent, // 去掉水波纹效果
      ),
    );
  }
}

///------------------------------------------
/// 热门话题
///------------------------------------------
class hottopicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // //多房间模式
    // ZegoExpressEngine.setRoomMode(ZegoRoomMode.MultiRoom)
    //     .then((value) => createEngine());

    //获取Logic
    Get.lazyPut(() => SheQuLogic());
    var mySheQulogc = Get.find<SheQuLogic>();

    //构建界面
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // 隐藏默认的返回按钮
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              //清除房间列表
              mySheQulogc.rtcRoomlist.clear();
              //重置页数
              mySheQulogc.rtcpageCount = 0;
              //返回上一页面
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            '今日热点',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateRoomPage(),
                      fullscreenDialog: true,
                    ),
                  );
                })
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
            child: Obx(() => ListView.builder(
                  itemCount:
                      (mySheQulogc.rtcRoomlist.length / 2).ceil(), // 向上取整
                  itemBuilder: (BuildContext context, int index) {
                    int startIndex = index * 2; // 当前行的第一个数据的索引
                    int endIndex = startIndex + 2; // 当前行的最后一个数据的索引，不包括 endIndex
                    if (endIndex > mySheQulogc.rtcRoomlist.length) {
                      endIndex = mySheQulogc
                          .rtcRoomlist.length; // 最后一行不足2个数据，endIndex 为 7
                    }
                    //一行有2个数据
                    if (endIndex > startIndex + 1) {
                      // 否则返回包含两个 Container 的 Row
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 150,
                              // color: Colors.blue,
                              child: Center(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 200,
                                        child: Ink.image(
                                          image:
                                              AssetImage('assets/zpic005.png'),
                                          child: InkWell(
                                              onTap: () {
                                                //先获取数据
                                                Global.SheQuGlobalNum1 =
                                                    mySheQulogc.rtcRoomlist[
                                                        startIndex]['RoomID'];
                                                Global.SheQuGlobalNum2 =
                                                    mySheQulogc
                                                        .getMySelfUserID();
                                                Global.SheQuGlobalNum3 =
                                                    mySheQulogc
                                                        .getMySelfNickName();
                                                Global.SheQuGlobalNum5 =
                                                    mySheQulogc
                                                        .getMySelffaceURL();

                                                print(
                                                    "----------社区------------");
                                                print(Global.SheQuGlobalNum1);
                                                print(Global.SheQuGlobalNum2);
                                                print(Global.SheQuGlobalNum3);

                                                // 点击按钮时执行的操作
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiPersonChatPage(
                                                            roomid: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['RoomID'],
                                                            title: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['Title'],
                                                            desc: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['Describle']),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Column(children: [
                                                  Text(
                                                    mySheQulogc.rtcRoomlist
                                                                .length >
                                                            0
                                                        ? mySheQulogc
                                                                .rtcRoomlist[
                                                            startIndex]['Title']
                                                        : "",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(mySheQulogc
                                                      .rtcRoomlist[startIndex]
                                                          ['Describle']
                                                      .toString()),
                                                ]),
                                              )),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 150,
                              // color: Colors.green,
                              child: Center(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 200,
                                        child: Ink.image(
                                          image:
                                              AssetImage('assets/zpic005.png'),
                                          child: InkWell(
                                              onTap: () {
                                                //先获取数据
                                                Global.SheQuGlobalNum1 =
                                                    mySheQulogc.rtcRoomlist[
                                                            startIndex + 1]
                                                        ['RoomID'];
                                                Global.SheQuGlobalNum2 =
                                                    mySheQulogc
                                                        .getMySelfUserID();
                                                Global.SheQuGlobalNum3 =
                                                    mySheQulogc
                                                        .getMySelfNickName();
                                                Global.SheQuGlobalNum5 =
                                                    mySheQulogc
                                                        .getMySelffaceURL();

                                                print(
                                                    "----------社区------------");
                                                print(Global.SheQuGlobalNum1);
                                                print(Global.SheQuGlobalNum2);
                                                print(Global.SheQuGlobalNum3);

                                                // 点击按钮时执行的操作
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MultiPersonChatPage(
                                                        roomid: mySheQulogc
                                                                .rtcRoomlist[startIndex + 1]
                                                            ['RoomID'],
                                                        title: mySheQulogc
                                                                    .rtcRoomlist[
                                                                startIndex + 1]
                                                            ['Title'],
                                                        desc: mySheQulogc
                                                                    .rtcRoomlist[
                                                                startIndex + 1]
                                                            ['Describle']),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Column(children: [
                                                  Text(
                                                    mySheQulogc.rtcRoomlist
                                                                .length >
                                                            0
                                                        ? mySheQulogc
                                                                .rtcRoomlist[
                                                            startIndex +
                                                                1]['Title']
                                                        : "",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(mySheQulogc.rtcRoomlist[
                                                          startIndex + 1]
                                                          ['Describle']
                                                      .toString()),
                                                ]),
                                              )),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      //一行有1个数据，第二个数据没有
                      // 如果是最后一个 item，则返回一个包含两个 Expanded 的 Row
                      return Row(
                        children: [
                          Expanded(
                            flex: 1, // 设置 flex 值为 1，和前面的两列等宽
                            child: Container(
                              height: 150,
                              // color: Colors.blue,
                              child: Align(
                                alignment: Alignment.center,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 200,
                                        child: Ink.image(
                                          image:
                                              AssetImage('assets/zpic005.png'),
                                          child: InkWell(
                                              onTap: () {
                                                //先获取数据
                                                Global.SheQuGlobalNum1 =
                                                    mySheQulogc.rtcRoomlist[
                                                        startIndex]['RoomID'];
                                                Global.SheQuGlobalNum2 =
                                                    mySheQulogc
                                                        .getMySelfUserID();
                                                Global.SheQuGlobalNum3 =
                                                    mySheQulogc
                                                        .getMySelfNickName();
                                                Global.SheQuGlobalNum5 =
                                                    mySheQulogc
                                                        .getMySelffaceURL();

                                                print(
                                                    "----------社区------------");
                                                print(Global.SheQuGlobalNum1);
                                                print(Global.SheQuGlobalNum2);
                                                print(Global.SheQuGlobalNum3);

                                                // 点击按钮时执行的操作
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiPersonChatPage(
                                                            roomid: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['RoomID'],
                                                            title: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['Title'],
                                                            desc: mySheQulogc
                                                                        .rtcRoomlist[
                                                                    startIndex]
                                                                ['Describle']),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Column(children: [
                                                  Text(
                                                    mySheQulogc.rtcRoomlist
                                                                .length >
                                                            0
                                                        ? mySheQulogc
                                                                .rtcRoomlist[
                                                            startIndex]['Title']
                                                        : "",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(mySheQulogc
                                                      .rtcRoomlist[startIndex]
                                                          ['Describle']
                                                      .toString()),
                                                ]),
                                              )),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1, // 设置 flex 值为 1，和前面的两列等宽
                            child: Container(
                              height: 150,
                              width: 200,
                              // color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ))));
  }
}

///------------------------------------------
/// 多人语聊页面
///------------------------------------------
class MultiPersonChatPage extends StatefulWidget {
  const MultiPersonChatPage({Key? key, this.roomid, this.title, this.desc})
      : super(key: key);

  final String? roomid;
  final String? title;
  final String? desc;

  @override
  _MultiPersonChatPageState createState() => _MultiPersonChatPageState();
}

class _MultiPersonChatPageState extends State<MultiPersonChatPage> {
  //变量定义
  ZegoRoomState _roomState = ZegoRoomState.Disconnected;
  ZegoPublisherState _publisherState = ZegoPublisherState.NoPublish;
  ZegoPlayerState _playerState = ZegoPlayerState.NoPlay;
  String roomText = "";

  @override
  void initState() {
    // 在这里执行初始化操作
    super.initState();
    //第一进入房间
    Global.isFirstEnter = true;

    //设置监听
    setZegoEventCallback();

    //创建引擎
    createEngine().then((value) {
      //进入房间
      loginRoom(widget.roomid, Global.SheQuGlobalNum2, Global.SheQuGlobalNum3,
          Global.SheQuGlobalNum5);
    });
  }

  //标题输入框监听
  TextEditingController roomTextControllerText() {
    TextEditingController _controller = TextEditingController(
      text: "",
    );

    _controller.addListener(() {
      print(_controller.text);
      roomText = _controller.text;
      print("房间消息：" + roomText);
    });

    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    //获取Logic
    Get.lazyPut(() => SheQuLogic());
    var mySheQulogc = Get.find<SheQuLogic>();

    //构建界面
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // 隐藏默认的返回按钮
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              //第一进入房间 恢复初始值
              Global.isFirstEnter = true;
              //清空房间成员列表
              mySheQulogc.sheQuGlobalList.clear();
              //退出房间
              logoutRoom();
              //销毁引擎
              destroyEngine();
              //返回之前页面
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            '多人语聊',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.3,
                      maxChildSize: 0.8,
                      minChildSize: 0.3,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  '设置',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                children: List.generate(
                                  8,
                                  (index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '按钮${index + 1}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                child: Image.asset("assets/zpic004.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
              )),
              Positioned(
                top: 10,
                left: 2,
                child: Container(
                    width: 320,
                    height: 65,
                    // color: Colors.cyanAccent,
                    child: Text(
                      widget.title.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )),
              ),
              Positioned(
                top: 15,
                right: 3,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/9.png'),
                  radius: 25,
                ),
              ),
              Positioned(
                width: 348,
                top: 80,
                left: 2,
                height: 470,
                child: Container(
                  // color: Colors.white,
                  child: Obx(() => ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mySheQulogc.chatTextlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: AvatarView(
                                    size: 40.h,
                                    url: mySheQulogc.chatTextlist.length > 0
                                        ? mySheQulogc.chatTextlist[index]
                                            ['touxiang']
                                        : "",
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                    mySheQulogc.chatTextlist.length > 0
                                        ? mySheQulogc.chatTextlist[index]
                                            ['message']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12))
                              ],
                            ),
                          );
                        },
                      )),
                ),
              ),
              Positioned(
                right: 0,
                width: 60,
                top: 80,
                height: 415,
                child: Container(
                  // color: Colors.blue,
                  child: Obx(() => ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mySheQulogc.sheQuGlobalList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              child: Text((index + 1).toString()),
                            ),
                          );
                        },
                      )),
                ),
              ),
              Positioned(
                top: 415 + 100,
                right: 10,
                child: Text(
                  "${Global.SheQuGlobalNum4.toString()}人",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Positioned(
                width: 409,
                height: 40,
                bottom: 1,
                left: 2,
                child: Container(
                  color: Colors.grey,
                  child: TextField(
                    controller: roomTextControllerText(),
                    maxLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Positioned(
                width: 40,
                height: 40,
                bottom: 1,
                right: 1,
                child: Container(
                  // color: Colors.amberAccent,
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      print("发送");
                      ZegoExpressEngine.instance
                          .sendBroadcastMessage(
                              widget.roomid.toString(), roomText)
                          .then((value) {
                        if (value.errorCode == 0) {
                          Map<String, dynamic> messageListext = {};
                          int timestamp = DateTime.now().millisecondsSinceEpoch;
                          messageListext["messageID"] = value.messageID;
                          messageListext["message"] = roomText;
                          messageListext["fromUser"] = {
                            "userID": mySheQulogc.getMySelfUserID(),
                            "userName": mySheQulogc.getMySelfUserID()
                          };
                          messageListext["sendTime"] = timestamp;
                          messageListext["touxiang"] =
                              mySheQulogc.getMySelffaceURL();

                          mySheQulogc.chatTextlist.add(messageListext);
                          print("发送回调");
                          print(value.messageID);
                          print(value.toString());
                        }
                      });
                      // if (Global.isJingYin == true) {
                      //   Global.isJingYin = false;
                      //   ZegoExpressEngine.instance
                      //       .muteMicrophone(Global.isJingYin = false);
                      // } else {
                      //   Global.isJingYin = true;
                      //   ZegoExpressEngine.instance
                      //       .muteMicrophone(Global.isJingYin = true);
                      // }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

//创建引擎
  Future createEngine() async {
    print("创建引擎");
    ZegoEngineProfile profile = ZegoEngineProfile(
        KeyCenter.instance.appID, ZegoConfig.instance.scenario,
        enablePlatformView: ZegoConfig.instance.enablePlatformView,
        appSign: kIsWeb ? null : KeyCenter.instance.appSign);

    //创建引擎
    ZegoExpressEngine.createEngineWithProfile(profile);
    return true;
  }

  //销毁引擎
  void destroyEngine() async {
    print("销毁引擎");
    ZegoExpressEngine.destroyEngine();
  }

  //加入房间
  void loginRoom(String? myRoomID, String? myUserid, String? myUserName,
      String? faceURL) async {
    print("进入房间");
    print(Global.SheQuGlobalNum1);
    print(Global.SheQuGlobalNum2);
    print(Global.SheQuGlobalNum3);
    print(Global.SheQuGlobalNum5);

    // 创建用户对象
    ZegoUser user = ZegoUser(myUserid!, "${myUserName!}|${faceURL!}");
    ZegoRoomConfig config = ZegoRoomConfig.defaultConfig();
    config.isUserStatusNotify = true;

    // 开始登录房间
    ZegoExpressEngine.instance.loginRoom(myRoomID!, user, config: config);
  }

  //状态回调
  void setZegoEventCallback() async {
    //获取Logic
    Get.lazyPut(() => SheQuLogic());
    var mySheQulogc = Get.find<SheQuLogic>();

    //房间状态变化通知监听
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print("房间状态变化通知");
      print(roomID);
      print(state);
      print(errorCode);
      print(Global.SheQuGlobalNum2);
      print("打印1==$extendedData");

      if (ZegoRoomState.Connected == state) {
        //设置属性
        ZegoExpressEngine.instance.enableDebugAssistant(false);
        ZegoExpressEngine.instance.muteMicrophone(false);
        ZegoExpressEngine.instance.setAudioRouteToSpeaker(false); //不外放
        ZegoExpressEngine.instance.enableAEC(true);
        ZegoExpressEngine.instance.enableTransientANS(true);
        ZegoExpressEngine.instance.enableANS(true);

        //推流，目前是推自己的流ID，不是固定的流ID
        // startPublishingStream("${widget.roomid}_${Global.SheQuGlobalNum2}");
      }
    };

    //推流状态回调监听
    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      print("推流状态回调");
      print("推流状态回调-----");
      print("推流ID：$streamID");
      print(state);
      print("打印3==$extendedData");
    };

    //拉流状态变更回调监听
    ZegoExpressEngine.onPlayerStateUpdate = (String streamID,
        ZegoPlayerState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      print("拉流状态变更回调");
      print("拉流状态变更回调-----");
      print("拉流ID：$streamID");
      print(state);
      print("打印4==$extendedData");
    };

    //房间内其他用户增加或减少的回调通知监听
    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      print("房间内其他用户增加或减少的回调通知");
      print(roomID);
      print(updateType);
      print(userList.length);

      //房间有人进入add
      if (roomID == Global.SheQuGlobalNum1 &&
          updateType == ZegoUpdateType.Add) {
        //第一进入房间处理
        if (Global.isFirstEnter == true) {
          print("第一次进入房间");
          Global.isFirstEnter = false;
          mySheQulogc.sheQuGlobalList.assignAll(userList);

          //将自己放入列表中
          ZegoUser user = ZegoUser(mySheQulogc.getMySelfUserID(),
              "${mySheQulogc.getMySelfNickName()}|${mySheQulogc.getMySelffaceURL()}");
          List<ZegoUser> TempList = [];
          TempList[0].userID = user.userID;
          TempList[0].userName = user.userName;
          mySheQulogc.sheQuGlobalList.add(TempList[0]);
        } else {
          print("在房间里，没有离开过");
          mySheQulogc.sheQuGlobalList.addAll(userList);
          setState(() {
            Global.SheQuGlobalNum4 = Global.SheQuGlobalNum4 + 1;
          });
        }

        // startPlayingStream(Global.SheQuGlobalNum2);
        for (var i = 0; i < mySheQulogc.sheQuGlobalList.length; i++) {
          startPlayingStream(
              "${widget.roomid}_${mySheQulogc.sheQuGlobalList[i].userID}");
        }

        print("打印人物信息：");
        for (var i = 0; i < mySheQulogc.sheQuGlobalList.length; i++) {
          print(mySheQulogc.sheQuGlobalList[i].userID);
          print(mySheQulogc.sheQuGlobalList[i].userName);
          print("----------------");
        }
      }

      //房间有人离开Delete
      if (roomID == Global.SheQuGlobalNum1 &&
          updateType == ZegoUpdateType.Delete) {
        print("有人离开房间");
        for (var i = 0; i < mySheQulogc.sheQuGlobalList.length; i++) {
          if (mySheQulogc.sheQuGlobalList[i].userID == userList[0].userID) {
            mySheQulogc.sheQuGlobalList.removeAt(i);
          }
        }

        for (var i = 0; i < mySheQulogc.sheQuGlobalList.length; i++) {
          print("打印剩余成员信息：");
          print(mySheQulogc.sheQuGlobalList[i].userID);
          print(mySheQulogc.sheQuGlobalList[i].userName);
          print("----------------");
        }

        setState(() {
          Global.SheQuGlobalNum4 = Global.SheQuGlobalNum4 - 1;
        });
      }
    };

    //房间内当前在线用户数量回调监听
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = (String roomID, int count) {
      print("房间内当前在线用户数量回调");
      print(roomID);
      print(count);
      setState(() {
        Global.SheQuGlobalNum4 = count;
      });
    };

    ZegoExpressEngine.onIMRecvBroadcastMessage =
        (String roomID, List<ZegoBroadcastMessageInfo> messageList) {
      print("收到文本消息");
      print(roomID);
      print(messageList.length);

      for (var i = 0; i < messageList.length; i++) {
        print("打印收到文本消息：");
        print("----------------");

        //消息列表保存到本地
        Map<String, dynamic> messageListext = {};
        messageListext["messageID"] = messageList[i].messageID;
        messageListext["message"] = messageList[i].message;
        messageListext["fromUser"] = {
          "userID": messageList[i].fromUser.userID,
          "userName": messageList[i].fromUser.userName
        };
        messageListext["sendTime"] = messageList[i].sendTime;

        //切割字符串,保存头像信息
        String str = messageListext["fromUser"]["userName"];
        List<String> splitStr = str.split("|");
        print(splitStr[0]); // 李白
        print(splitStr[1]); // ic_avatar_05
        messageListext["touxiang"] = splitStr[1];

        // 查找相同的ID
        // for (var j = 0; j < mySheQulogc.chatTextlist.length; j++) {
        //   if (mySheQulogc.chatTextlist[j]["fromUser"]["userID"] ==
        //       messageList[i].fromUser.userID) {
        // 暂无处理
        // }
        // }

        mySheQulogc.chatTextlist.add(messageListext);
      }

      //获取人物信息
      // mySheQulogc.getOtherUserInfo();
    };
  }

  //推流
  void startPublishingStream(String streamID) async {
    print("推流start");
    // var config = ZegoPublisherConfig();
    // config.roomID = widget.roomid;

    return ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  //拉流
  void startPlayingStream(String streamID) async {
    print("拉流start");
    // var config = ZegoPlayerConfig.defaultConfig();
    // config.roomID = widget.roomid;

    return ZegoExpressEngine.instance.startPlayingStream(streamID);
  }

  //停止拉流
  void stopPlayingStream(String streamID) async {
    print("停止拉流");
    return ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }

  //清除回调监听
  void clearZegoEventCallback() async {
    print("清理监听");
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPlayerStateUpdate = null;
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = null;
  }

  //退出房间
  void logoutRoom() async {
    print("退出房间");
    //清理回调监听
    clearZegoEventCallback();
    //退出房间
    ZegoExpressEngine.instance.logoutRoom();
  }
}

///------------------------------------------
///创建语聊房间
///------------------------------------------

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  String titleText = "";
  String descText = "";

  //标题输入框监听
  TextEditingController titleControllerText() {
    TextEditingController _controller = TextEditingController(
      text: "",
    );

    _controller.addListener(() {
      print(_controller.text);
      titleText = _controller.text;
      print("标题输入内容：" + titleText);
    });

    return _controller;
  }

  //描述输入框监听
  TextEditingController descControllerText() {
    TextEditingController _controller = TextEditingController(
      text: "",
    );

    _controller.addListener(() {
      print(_controller.text);
      descText = _controller.text;
      print("描述输入内容：" + descText);
    });

    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    //获取Logic
    Get.lazyPut(() => SheQuLogic());
    var mySheQulogc = Get.find<SheQuLogic>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              //返回上一页面
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            '创建房间',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: titleControllerText(),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                  hintText: "房间标题",
                  // suffixIcon: Icon(Icons.send),
                  filled: true, //filled == true 时，fillColor 生效。
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(10), //边角为30
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey, //边线颜色为黄色
                      width: 2, //边线宽度为2
                    ),
                  )),
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  textBaseline: TextBaseline.alphabetic),
              onEditingComplete: () {
                if (titleText.length == 0) {
                  print('消息不能为空');
                  return;
                }
              },
              onTap: () {
                print("标题开始编辑");
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: descControllerText(),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                  hintText: "房间描述内容",
                  // suffixIcon: Icon(Icons.send),
                  filled: true, //filled == true 时，fillColor 生效。
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(10), //边角为30
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey, //边线颜色为黄色
                      width: 2, //边线宽度为2
                    ),
                  )),
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  textBaseline: TextBaseline.alphabetic),
              onEditingComplete: () {
                if (descText.length == 0) {
                  print('消息不能为空');
                  return;
                }
              },
              onTap: () {
                print("内容开始编辑");
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 200,
              child: TextButton(
                  onPressed: () {
                    print("确认创建");
                    if (descText == "" || titleText == "") {
                      IMWidget.showToast('标题或内容不能为空!');
                      return;
                    }
                    mySheQulogc.sheQuCreateRooms(
                      titleText,
                      descText,
                    );
                  },
                  style: ButtonStyle(
                    //背景颜色
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    //设置形状、圆角
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    //内边距
                    padding: MaterialStateProperty.all(
                        EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 3)),
                  ),
                  child: Text(
                    '确认创建',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
