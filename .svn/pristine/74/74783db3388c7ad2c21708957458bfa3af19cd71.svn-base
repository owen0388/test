import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_ion/flutter_ion.dart';
import 'package:community_material_icon/community_material_icon.dart';

import 'package:openim_demo/src/pages/chat/webrtc/ion_controller.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/chat/webrtc/meeting_logic.dart';
// import 'package:openim_demo/src/pages/call//utils/utils.dart';

class VideoRendererAdapter {
  String mid;
  bool local;
  RTCVideoRenderer? renderer;
  MediaStream stream;
  RTCVideoViewObjectFit _objectFit =
      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;

  VideoRendererAdapter._internal(this.mid, this.stream, this.local);

  static Future<VideoRendererAdapter> create(
      String mid, MediaStream stream, bool local) async {
    var renderer = VideoRendererAdapter._internal(mid, stream, local);
    await renderer.setupSrcObject();
    return renderer;
  }

  setupSrcObject() async {
    if (renderer == null) {
      renderer = new RTCVideoRenderer();
      await renderer?.initialize();
    }
    renderer?.srcObject = stream;
    if (local) {
      _objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
    }
  }

  switchObjFit() {
    _objectFit =
        (_objectFit == RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)
            ? RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
            : RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
  }

  RTCVideoViewObjectFit get objFit => _objectFit;

  set objectFit(RTCVideoViewObjectFit objectFit) {
    _objectFit = objectFit;
  }

  dispose() async {
    if (renderer != null) {
      print('dispose for texture id ' + renderer!.textureId.toString());
      renderer?.srcObject = null;
      await renderer?.dispose();
      renderer = null;
    }
  }
}

class BoxSize {
  BoxSize({required this.width, required this.height});

  double width;
  double height;
}

class MeetingView extends StatefulWidget {
  @override
  State<MeetingView> createState() => _MeetingView();
}

// ignore: must_be_immutable
class _MeetingView extends State<MeetingView> {
  final controller = Get.find<MeetingLogic>();
  List<VideoRendererAdapter> get remoteVideos => controller.remoteVideos;

  VideoRendererAdapter? get localVideo => controller.localVideo;

  final double localWidth = 114.0;
  final double localHeight = 72.0;
  String dropdownValue = 'Simulcast';
  BoxSize localVideoBoxSize(Orientation orientation) {
    return BoxSize(
      width: (orientation == Orientation.portrait) ? localHeight : localWidth,
      height: (orientation == Orientation.portrait) ? localWidth : localHeight,
    );
  }

  Widget _buildMajorVideo() {
    return Obx(() {
      if (remoteVideos.isEmpty) {
        return Image.asset(
          'assets/images/loading.jpg',
          fit: BoxFit.cover,
        );
      }
      var adapter = remoteVideos[0];
      return GestureDetector(
          onDoubleTap: () {
            adapter.switchObjFit();
          },
          child: RTCVideoView(adapter.renderer!,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain));
    });
  }

  Widget _buildVideoList() {
    return Obx(() {
      if (remoteVideos.length <= 1) {
        return Container();
      }
      return ListView(
          scrollDirection: Axis.horizontal,
          children:
              remoteVideos.getRange(1, remoteVideos.length).map((adapter) {
            adapter.objectFit =
                RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
            return _buildMinorVideo(adapter);
          }).toList());
    });
  }

  Widget _buildLocalVideo(Orientation orientation) {
    return Obx(() {
      if (localVideo == null) {
        return Container();
      }
      var size = localVideoBoxSize(orientation);
      return SizedBox(
          width: size.width,
          height: size.height,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            child: GestureDetector(
                onTap: () {
                  controller.switchCamera();
                },
                onDoubleTap: () {
                  localVideo?.switchObjFit();
                },
                child: RTCVideoView(localVideo!.renderer!,
                    objectFit: localVideo!.objFit)),
          ));
    });
  }

  Widget _buildMinorVideo(VideoRendererAdapter adapter) {
    return SizedBox(
      width: 120,
      height: 90,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: GestureDetector(
            onTap: () => controller.swapAdapter(adapter),
            onDoubleTap: () => adapter.switchObjFit(),
            child: RTCVideoView(adapter.renderer!, objectFit: adapter.objFit)),
      ),
    );
  }

  //Leave current video room

  Widget _buildLoading() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Waiting for others to join...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //tools
  List<Widget> _buildTools() {
    return <Widget>[
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller.simulcast.value
                    ? CommunityMaterialIcons.video_off
                    : CommunityMaterialIcons.video,
                color: controller.simulcast.value ? Colors.red : Colors.white,
              )),
          onPressed: controller.turnCamera,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller.cameraOff.value
                    ? CommunityMaterialIcons.video_off
                    : CommunityMaterialIcons.video,
                color: controller.cameraOff.value ? Colors.red : Colors.white,
              )),
          onPressed: controller.turnCamera,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Icon(
            CommunityMaterialIcons.video_switch,
            color: Colors.white,
          ),
          onPressed: controller.switchCamera,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller.microphoneOff.value
                    ? CommunityMaterialIcons.microphone_off
                    : CommunityMaterialIcons.microphone,
                color:
                    controller.microphoneOff.value ? Colors.red : Colors.white,
              )),
          onPressed: controller.turnMicrophone,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller.speakerOn.value
                    ? CommunityMaterialIcons.volume_high
                    : CommunityMaterialIcons.speaker_off,
                color: Colors.white,
              )),
          onPressed: controller.switchSpeaker,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Icon(
            CommunityMaterialIcons.phone_hangup,
            color: Colors.red,
          ),
          onPressed: controller.hangUp,
        ),
      ),
      SizedBox(
          width: 36,
          height: 36,
          child: DropdownButton<String>(
              items: <String>['f', 'h', 'q'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? layer) {
                print(layer);
                List<Subscription> infos = [];
                for (var track in controller.trackEvent!.tracks) {
                  print(
                      "track.id=${track.id} track.kind=${track.kind} track.layer=${track.layer}");
                  if (layer == track.layer && track.kind == 'video') {
                    infos.add(Subscription(
                        trackId: track.id,
                        mute: false,
                        subscribe: true,
                        layer: layer.toString()));
                  }

                  if (track.kind == 'audio') {
                    infos.add(Subscription(
                        trackId: track.id,
                        mute: false,
                        subscribe: true,
                        layer: layer.toString()));
                  }
                }

                for (var i in infos) {
                  print(
                      "i.trackId=${i.trackId} i.layer=${i.layer} i.mute=${i.mute} i.subscribe=${i.subscribe}");
                }
                Get.find<IonController>().rtc!.subscribe(infos);
              },
              icon: Icon(
                CommunityMaterialIcons.picture_in_picture_top_right_outline,
                color: Colors.white,
              ))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return SafeArea(
        child: Scaffold(
            key: controller.scaffoldkey,
            body: Container(
              color: Colors.black87,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              child: _buildMajorVideo(),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 48,
                            child: Container(
                              child: _buildLocalVideo(orientation),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 48,
                            height: 90,
                            child: Container(
                              margin: EdgeInsets.all(6.0),
                              child: _buildVideoList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() =>
                      (remoteVideos.isEmpty) ? _buildLoading() : Container()),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 48,
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 48,
                          margin: EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _buildTools(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 48,
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(0.0),
                          child: Center(
                            child: Obx(() => Text(
                                  'ION Conference [${controller.rid.value}]',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.people,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            //Chat message
                            IconButton(
                              icon: Icon(
                                Icons.chat_bubble_outline,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
