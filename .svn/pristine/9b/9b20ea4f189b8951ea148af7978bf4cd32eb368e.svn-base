//
//  quick_start_page.dart
//  zego-express-example-topics-flutter
//
//  Created by Patrick Fu on 2020/12/04.
//  Copyright © 2020 Zego. All rights reserved.
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quick_start_logic.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quickutils/keycenter.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quickutils/token_helper.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quickutils/user_id_helper.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quickutils/zego_config.dart';
import 'package:openim_demo/src/pages/chat/QuickStart/quick_start/quickutils/zego_log_view.dart';
import 'package:zego_express_engine/zego_express_engine.dart';


class QuickStartVideoPage extends StatefulWidget {
  @override
  _QuickStartVideoPageState createState() => _QuickStartVideoPageState();
}

class _QuickStartVideoPageState extends State<QuickStartVideoPage> {
  final String _roomID = '1234';

  late int _previewViewID;
  late int _playViewID;
  Widget? _previewViewWidget;
  Widget? _playViewWidget;
  bool _switch = false;//视频界面切换
  bool _isMute = false;//是否静音
  bool _isOutward = false;//是否外放
  bool _isVideo = false;//是否是接收 视频通话
  var _Videoparameter;

  bool _isEngineActive = false;
  ZegoRoomState _roomState = ZegoRoomState.Disconnected;
  ZegoPublisherState _publisherState = ZegoPublisherState.NoPublish;
  ZegoPlayerState _playerState = ZegoPlayerState.NoPlay;

  TextEditingController _publishingStreamIDController = TextEditingController();
  TextEditingController _playingStreamIDController = TextEditingController();

  final mylogc = Get.find<quickStartLogic>();

  @override
  void initState() {
    print("----chushihua");
    super.initState();
    _previewViewID = -1;
    _playViewID = -1;
    _switch = false;//视频界面切换
    _isMute = false;//是否静音
    _isOutward = false;////是否外放
    _isVideo = false;

    _Videoparameter = mylogc.parameterVideo;
    print(_Videoparameter["data"]);//是房间号
    print(_Videoparameter["extension"]);//别人ID号
    print(_Videoparameter["description"]);//标识

    if(_Videoparameter["description"] == "tuisongVideo"){
      print("进入推送");
      _publishingStreamIDController.text = mylogc.getMySelfUserID();//房间是我的，推送是我，只有推流是我 房间号和推流一样ID一样
      _playingStreamIDController.text = _Videoparameter["extension"];//接收别人，传过来的是 别人的ID号

    }else if(_Videoparameter["description"] == "jieshou"){
      print("进入接收");
      _publishingStreamIDController.text = mylogc.getMySelfUserID();//房间不是我，推送是我，只有推流是我
      _playingStreamIDController.text = _Videoparameter["data"];//接收别人，房间号就是别人的ID

    }else if(_Videoparameter["description"] == "guaduan"){
      print("进入其他");
      destroyEngine();
      return Navigator.pop(context);
    }

    if(_Videoparameter["description"] == "tuisongVideo" ||  _Videoparameter["description"] == "jieshou") {
      ZegoExpressEngine.getVersion()
          .then((value) => ZegoLog().addLog('🌞 SDK Version: $value'));

      setZegoEventCallback();

      print("---------------->>>视频通话初始化");

      //延迟1秒
      Timer(Duration(milliseconds: 50), () {
        createEngine(); //创建引擎

        if(_Videoparameter["description"] == "tuisongVideo"){
          _isVideo = false;
          loginRoom(); //加入房间
        }else{
          _isVideo = true;
        }

        ZegoExpressEngine.instance.muteMicrophone(false);
        ZegoExpressEngine.instance.setAudioRouteToSpeaker(false); //不外放
        ZegoExpressEngine.instance.enableAEC(true);
        ZegoExpressEngine.instance.enableTransientANS(true);
        ZegoExpressEngine.instance.enableANS(true);
      });
    }
  }



  // MARK: 界面布局
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[viewsWidget(), _isVideo? _bottomToolBar():_bottomToolBar2()],
        ),
      ),
    );
  }



  ///底部的菜单栏--挂断
  Widget _bottomToolBar2() {
    //在中央
    return Container(
      alignment: Alignment.bottomCenter,
      //竖直方向相隔48
      padding: EdgeInsets.symmetric(vertical: 48),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //是否静音按钮
          RawMaterialButton(
            //点击事件
            onPressed: () {
              setState(() {
                _isMute = !_isMute;
              });
              ZegoExpressEngine.instance.muteMicrophone(_isMute);//不静音
            },

            child: new Icon(
              _isMute ? Icons.mic_off : Icons.mic ,
              color: _isMute ? Colors.blueAccent : Colors.white ,
              size: 25.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: _isMute? Colors.white : Colors.blueAccent ,
            padding: const EdgeInsets.all(12.0),
          ),

          //挂断按钮
          RawMaterialButton(
            onPressed: () {
                destroyEngine();
                return Navigator.pop(context);
            },
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 28.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),

          //是否外放
          RawMaterialButton(
            onPressed: () {
              setState(() {
                _isOutward = !_isOutward;
              });
              ZegoExpressEngine.instance.setAudioRouteToSpeaker(_isOutward);//是否外放
            },
            child: new Icon(
              _isOutward ? Icons.leak_add_sharp : Icons.leak_remove,
              color: _isOutward ? Colors.white : Colors.blueAccent,
              size: 25.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: _isOutward? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }




  ///底部的菜单栏--接收
  Widget _bottomToolBar() {
    //在中央
    return Container(
      alignment: Alignment.bottomCenter,
      //竖直方向相隔48
      padding: EdgeInsets.symmetric(vertical: 48),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //接收按钮
          RawMaterialButton(
            onPressed: () {
                setState(() {
                  _isVideo = !_isVideo;
                });
                loginRoom();
            },
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 28.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor:Colors.green,
            padding: const EdgeInsets.all(15.0),
          ),


          SizedBox(width: 50),

          //挂断按钮
          RawMaterialButton(
            onPressed: () {
              var param = Map();
              param["Flag"] ="guaduan";//房间号

              OpenIM.iMManager.messageManager.typingStatusUpdate(
                userID: _Videoparameter["data"]!,
                msgTip: json.encode(param),
              );
              destroyEngine();
              return Navigator.pop(context);
            },

            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 28.0,
            ),

            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor:Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),

        ],
      ),
    );
  }



  ///视频界面
  Widget viewsWidget() {
    return Stack(
          children: [
            Center(
              child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100,
                height: 130,
                margin: EdgeInsets.only(right: 10.w,top: 30.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _switch = !_switch;
                    });
                  },
                  child: Center(
                        child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                  ),
                ),
              ),
            ),
          ]
    );
  }



  Widget _renderLocalPreview() {
   return Container(
      width: double.infinity,
      color: Colors.black,
      child: _playViewWidget,
    );
  }

  Widget _renderRemoteVideo() {
    return Container(
        width: double.infinity,
        color: Colors.black,
        child: _previewViewWidget,
      );
  }


  // ///语音通话界面
  // Widget _viewAudio() {
  //   return Positioned(//在中间显示对方id
  //     top: 110,
  //     left: 30,
  //     right: 30,
  //     child: Container(
  //       height: 260,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: Column(
  //               children: [
  //                 Text("名字",style:TextStyle(color: Colors.white,fontSize: 25) ),
  //                 Container(
  //                   alignment: Alignment.center,
  //                   width: 140,
  //                   height: 140,
  //                   child: ClipOval(
  //                     child: AvatarView(
  //                       size: 140.h,
  //                       url: "https://c-ssl.duitang.com/uploads/blog/202106/09/20210609081952_51ef5.jpg",
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    clearPreviewView();
    clearPlayView();

    clearZegoEventCallback();
    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine();

    ZegoLog().addLog('🏳️ Destroy ZegoExpressEngine');

    super.dispose();
  }

  // MARK: - Step 1: CreateEngine

  void createEngine() {
    ZegoEngineProfile profile = ZegoEngineProfile(
        KeyCenter.instance.appID, ZegoConfig.instance.scenario,
        enablePlatformView: ZegoConfig.instance.enablePlatformView,
        appSign: kIsWeb ? null : KeyCenter.instance.appSign);
    ZegoExpressEngine.createEngineWithProfile(profile);

    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, userList) {
      print("房间用户更新");
      print(userList.length);
      userList.forEach((e) {
        var userID = e.userID;
        var userName = e.userName;
        ZegoLog().addLog(
            '🚩 🚪 Room user update, roomID: $roomID, updateType: $updateType userID: $userID userName: $userName');
      });

      if(updateType == ZegoUpdateType.Delete){
        destroyEngine();
        Navigator.pop(context);
      }
      print("创建引擎");
    };

    ZegoExpressEngine.onPlayerVideoSizeChanged = (streamID, width, height) {
      ZegoLog().addLog(
          'onPlayerVideoSizeChanged streamID: $streamID size:${width}x${height}');
    };
    ZegoExpressEngine.onRoomTokenWillExpire = (roomid, expiretime) async {
      var token = await TokenHelper.instance.getToken(roomid);
      ZegoExpressEngine.instance.renewToken(roomid, token);
      ZegoLog().addLog(
          '🚩 🚪 Room Token Will Expire, roomID: $roomid, expiretime: $expiretime');
    };
    // Notify View that engine state changed
    setState(() => _isEngineActive = true);

    ZegoLog().addLog('🚀 Create ZegoExpressEngine');
  }

  // MARK: - Step 2: LoginRoom

  void loginRoom() async {
    // Instantiate a ZegoUser object
    ZegoUser user =
    ZegoUser(UserIdHelper.instance.userID, UserIdHelper.instance.userName);

    // ZegoLog().addLog('🚪 Start login room, roomID: $_Videoparameter["data"]');
    ZegoRoomConfig config = ZegoRoomConfig.defaultConfig();
    config.isUserStatusNotify = true;
    if (kIsWeb) {
      config.token = await TokenHelper.instance.getToken(_Videoparameter["data"]);
    }
    // Login Room
    ZegoExpressEngine.instance.loginRoom(_Videoparameter["data"], user, config: config);
    print("进入房间");
  }

  void logoutRoom() {
    // Logout room will automatically stop publishing/playing stream.
    //
    // But directly logout room without destroying the [PlatformView]
    // or [TextureRenderer] may cause a memory leak.
    ZegoExpressEngine.instance.logoutRoom(_Videoparameter["data"]);
    // ZegoLog().addLog('🚪 logout room, roomID: $_Videoparameter["data"]');

    clearPreviewView();
    clearPlayView();
    print("退出房间");
  }

  // MARK: - Step 3: StartPublishingStream
  ///推送数据流
  void startPublishingStream(String streamID) async {

    void _startPreview(int viewID) {
      ZegoCanvas canvas = ZegoCanvas.view(viewID);
      ZegoExpressEngine.instance.startPreview(canvas: canvas);
    }

    void _startPublishingStream(String streamID) {
      ZegoExpressEngine.instance.startPublishingStream(streamID);
      Future.delayed(Duration(seconds: 1), () {
        ZegoExpressEngine.instance.setStreamExtraInfo('ceshi');
      });
    }

    print("推送数据流");
    print(streamID);
    print("${_previewViewID}");
    if (_previewViewID == -1) {
      print("开始推送画面和流数据3");
      _previewViewWidget =
      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        print("开始推送画面和流数据1");
        _previewViewID = viewID;
        _startPreview(viewID);
        _startPublishingStream(streamID);
      }, key: ValueKey(DateTime.now()));

      setState(() {});
    } else {
      print("开始推送画面和流数据2");
      _startPreview(_previewViewID);
      _startPublishingStream(streamID);
    }
  }

  void stopPublishingStream() {
    ZegoExpressEngine.instance.stopPublishingStream();
    ZegoExpressEngine.instance.stopPreview();
  }

  // MARK: - Step 4: StartPlayingStream
  ///接收数据流
  void startPlayingStream(String streamID) async {
    void _startPlayingStream(int viewID, String streamID) {
      ZegoCanvas canvas = ZegoCanvas.view(viewID);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
      ZegoLog().addLog(
          '📥 Start playing stream, streamID: $streamID, viewID: $viewID');
    }

    if (_playViewID == -1) {
      _playViewWidget =
      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        _playViewID = viewID;
        _startPlayingStream(viewID, streamID);
      }, key: ValueKey(DateTime.now()));
      setState(() {});
    } else {
      print("开始接收画面和流数据");
      _startPlayingStream(_playViewID, streamID);
    }
  }

  void stopPlayingStream(String streamID) {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }

  // MARK: - Exit

  void destroyEngine() async {
    clearPreviewView();
    clearPlayView();
    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine();

    ZegoLog().addLog('🏳️ Destroy ZegoExpressEngine');

    // Notify View that engine state changed
    setState(() {
      _isEngineActive = false;
      _roomState = ZegoRoomState.Disconnected;
      _publisherState = ZegoPublisherState.NoPublish;
      _playerState = ZegoPlayerState.NoPlay;
    });

    print("销毁引擎");
  }

  // MARK: - Zego Event
  ///状态回调
  void setZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      // ZegoLog().addLog(
      //     '🚩 🚪 Room state update, state: $state, errorCode: $errorCode, roomID: $roomID');
      setState(() => _roomState = state);
      print("状态回调-推送流");
      startPublishingStream(mylogc.getMySelfUserID());
    };

    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      // ZegoLog().addLog(
      //     '🚩 📤 Publisher state update, state: $state, errorCode: $errorCode, streamID: $streamID');
      setState(() => _publisherState = state);
      if(_Videoparameter["description"] == "tuisongVideo"){

        print("状态回调-tuisongVideo");
        startPlayingStream(_Videoparameter["extension"]);

      }else if(_Videoparameter["description"] == "jieshou"){
        print("状态回调-jieshou");
        startPlayingStream(_Videoparameter["data"]);
      }
    };

    ZegoExpressEngine.onPlayerStateUpdate = (String streamID,
        ZegoPlayerState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      // ZegoLog().addLog(
      //     '🚩 📥 Player state update, state: $state, errorCode: $errorCode, streamID: $streamID');
      setState(() => _playerState = state);
    };
  }

  void clearZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPlayerStateUpdate = null;
  }

  void clearPreviewView() {
    // Developers should destroy the [CanvasView] after
    // [stopPublishingStream] or [stopPreview] to release resource and avoid memory leaks
    if (_previewViewID != -1) {
      ZegoExpressEngine.instance.destroyCanvasView(_previewViewID);
      _previewViewID = -1;
    }
  }

  void clearPlayView() {
    // Developers should destroy the [CanvasView]
    // after [stopPlayingStream] to release resource and avoid memory leaks
    if (_playViewID != -1) {
      ZegoExpressEngine.instance.destroyCanvasView(_playViewID);
      _playViewID = -1;
    }
  }


  Widget stepOneCreateEngineWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step1:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(children: [
          Column(
            children: [
              Text('AppID: ${KeyCenter.instance.appID}',
                  style: TextStyle(fontSize: 10)),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: CupertinoButton.filled(
              child: Text(
                _isEngineActive ? '✅ CreateEngine' : 'CreateEngine',
                style: TextStyle(fontSize: 14.0),
              ),
              onPressed: createEngine,
              padding: EdgeInsets.all(10.0),
            ),
          )
        ]),
        Divider(),
      ],
    );
  }

  Widget stepTwoLoginRoomWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step2:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(children: [
        Column(
          children: [
            Text('RoomID: ${mylogc.getVideoRoomID()}', style: TextStyle(fontSize: 10)),
            Text('UserID: ${UserIdHelper.instance.userID}',
                style: TextStyle(fontSize: 10)),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _roomState == ZegoRoomState.Connected
                  ? '✅ LoginRoom'
                  : 'LoginRoom',
              style: TextStyle(fontSize: 14.0),
            ),
            onPressed: _roomState == ZegoRoomState.Disconnected
                ? loginRoom
                : logoutRoom,
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }

  Widget stepThreeStartPublishingStreamWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step3:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Row(children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: TextField(
            enabled: _publisherState == ZegoPublisherState.NoPublish,
            controller: _publishingStreamIDController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                isDense: true,
                labelText: 'Publish StreamID:',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 14.0),
                hintText: 'Please enter streamID',
                hintStyle: TextStyle(color: Colors.black26, fontSize: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0e88eb)))),
          ),
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _publisherState == ZegoPublisherState.Publishing
                  ? '✅ StartPublishing'
                  : 'StartPublishing',
              style: TextStyle(fontSize: 14.0),
            ),
            onPressed: _publisherState == ZegoPublisherState.NoPublish
                ? () {
              startPublishingStream(
                  _publishingStreamIDController.text.trim());
            }
                : () {
              stopPublishingStream();
            },
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }

  Widget stepFourStartPlayingStreamWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step4:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Row(children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: TextField(
            enabled: _playerState == ZegoPlayerState.NoPlay,
            controller: _playingStreamIDController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                isDense: true,
                labelText: 'Play StreamID:',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 14.0),
                hintText: 'Please enter streamID',
                hintStyle: TextStyle(color: Colors.black26, fontSize: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0e88eb)))),
          ),
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _playerState != ZegoPlayerState.NoPlay
                  ? (_playerState == ZegoPlayerState.Playing
                  ? '✅ StopPlaying'
                  : '❌ StopPlaying')
                  : 'StartPlaying',
              style: TextStyle(fontSize: 14.0),
            ),
            onPressed: _playerState == ZegoPlayerState.NoPlay
                ? () {
              startPlayingStream(_playingStreamIDController.text.trim());
            }
                : () {
              stopPlayingStream(_playingStreamIDController.text.trim());
            },
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }
}
