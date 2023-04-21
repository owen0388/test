import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/config.dart';
import 'package:openim_demo/src/pages/chat/webrtc/ion_controller.dart';
import 'package:openim_demo/src/pages/chat/webrtc/meeting_view.dart';
import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingLogic extends GetxController {
  final ionController = Get.find<IonController>();

  late SharedPreferences prefs;
  final videoRenderers = Rx<List<VideoRendererAdapter>>([]);
  LocalStream? localStream;

  Room? get room => ionController.room;

  RTC? get rtc => ionController.rtc;

  var cameraOff = false.obs;
  var microphoneOff = false.obs;
  var speakerOn = true.obs;
  GlobalKey<ScaffoldState>? scaffoldkey;
  var name = ''.obs;
  var rid = ''.obs;
  var simulcast = false.obs;
  TrackEvent? trackEvent;

  @override
  @mustCallSuper
  void onInit() async {
    super.onInit();

    // if (room == null || rtc == null) {
    //   print(":::ROOM or SFU is not initialized!:::");
    //   print("Goback to /login");
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Get.offNamed('/call/login');
    //     cleanUp();
    //   });
    //   return;
    // }
    connect("42365");
  }

  @override
  void onReady() {
    // var rid = Get.arguments;
    // if (rid) {
    //   connect(rid);
    // }
    super.onReady();
  }

  connect(String roomid) async {
    scaffoldkey = GlobalKey();

    prefs = await ionController.prefs();

    //if this client is hosted as a website, using https, the ion-backend has to be
    //reached via wss. So the address should be for example:
    //https://your-backend-address.com
    var host = Config.callServerIP;
    host = 'http://' + host + ':5551';
    //join room
    name.value = prefs.getString('displayname') ?? 'Guest';
    rid.value = roomid;

    //init sfu and biz clients
    ionController.setup(host: host, name: name.value, room: rid.value);

    rtc!.ontrack = (MediaStreamTrack track, RemoteStream stream) async {
      if (track.kind == 'video') {
        addAdapter(
            await VideoRendererAdapter.create(stream.id, stream.stream, false));
      }
    };

    room?.onJoin = (JoinResult) async {
      print("room.onJoin");
      try {
        //join SFU
        await ionController.joinRTC();

        var resolution = prefs.getString('resolution') ?? 'hd';
        var codec = prefs.getString('codec') ?? 'vp8';
        var simulcast = prefs.getBool('simulcast') ?? false;
        print('simulcast=${simulcast}');
        localStream = await LocalStream.getUserMedia(
            constraints: Constraints.defaults
              ..simulcast = simulcast
              ..resolution = resolution
              ..codec = codec
              ..simulcast = simulcast);
        rtc!.publish(localStream!);
        addAdapter(await VideoRendererAdapter.create(
            localStream!.stream.id, localStream!.stream, true));
      } catch (error) {
        print('publish err ${error.toString()}');
      }
      this.showSnackBar(":::Join success:::");
    };

    room?.onLeave = (String reason) {
      this.showSnackBar(":::Leave success:::");
    };

    room?.onPeerEvent = (PeerEvent event) {
      var name = event.peer.displayname;
      var state = '';
      switch (event.state) {
        case PeerState.NONE:
          break;
        case PeerState.JOIN:
          state = 'join';
          break;
        case PeerState.UPDATE:
          state = 'upate';
          break;
        case PeerState.LEAVE:
          state = 'leave';
          break;
      }
      this.showSnackBar(":::Peer [${event.peer.uid}:$name] $state:::");
    };

    rtc?.ontrackevent = (TrackEvent event) async {
      print("ontrackevent event.uid=${event.uid}");
      for (var track in event.tracks) {
        print(
            "ontrackevent track.id=${track.id} track.kind=${track.kind} track.layer=${track.layer}");
      }
      switch (event.state) {
        case TrackState.ADD:
          if (event.tracks.isNotEmpty) {
            var id = event.tracks[0].id;
            this.showSnackBar(":::track-add [$id]:::");
          }

          if (trackEvent == null) {
            print("trackEvent == null");
            trackEvent = event;
          }

          break;
        case TrackState.REMOVE:
          if (event.tracks.isNotEmpty) {
            var mid = event.tracks[0].stream_id;
            this.showSnackBar(":::track-remove [$mid]:::");
            removeAdapter(mid);
          }
          break;
        case TrackState.UPDATE:
          if (event.tracks.isNotEmpty) {
            var id = event.tracks[0].id;
            this.showSnackBar(":::track-update [$id]:::");
          }
          break;
      }
    };

    //connect to room and SFU
    await ionController.connect();

    ionController.joinROOM();
  }

  removeAdapter(String mid) {
    videoRenderers.value.removeWhere((element) => element.mid == mid);
    videoRenderers.update((val) {});
  }

  addAdapter(VideoRendererAdapter adapter) {
    videoRenderers.value.add(adapter);
    videoRenderers.update((val) {});
  }

  swapAdapter(adapter) {
    var index = videoRenderers.value
        .indexWhere((element) => element.mid == adapter.mid);
    if (index != -1) {
      var temp = videoRenderers.value.elementAt(index);
      videoRenderers.value[0] = videoRenderers.value[index];
      videoRenderers.value[index] = temp;
    }
  }

  //Switch speaker/earpiece
  switchSpeaker() {
    if (localVideo != null) {
      speakerOn.value = !speakerOn.value;
      MediaStreamTrack audioTrack = localVideo!.stream.getAudioTracks()[0];
      audioTrack.enableSpeakerphone(speakerOn.value);
      showSnackBar(
          ":::Switch to " + (speakerOn.value ? "speaker" : "earpiece") + ":::");
    }
  }

  VideoRendererAdapter? get localVideo {
    VideoRendererAdapter? renderrer;
    videoRenderers.value.forEach((element) {
      if (element.local) {
        renderrer = element;
        return;
      }
    });
    return renderrer;
  }

  List<VideoRendererAdapter> get remoteVideos {
    List<VideoRendererAdapter> renderers = ([]);
    videoRenderers.value.forEach((element) {
      if (!element.local) {
        renderers.add(element);
      }
    });
    return renderers;
  }

  //Switch local camera
  switchCamera() {
    if (localVideo != null && localVideo!.stream.getVideoTracks().length > 0) {
      Helper.switchCamera(localVideo!.stream.getVideoTracks()[0]);
      // localVideo?.stream.getVideoTracks()[0].switchCamera();
    } else {
      showSnackBar(":::Unable to switch the camera:::");
    }
  }

  //Open or close local video
  turnCamera() {
    if (localVideo != null && localVideo!.stream.getVideoTracks().length > 0) {
      var muted = !cameraOff.value;
      cameraOff.value = muted;
      localVideo?.stream.getVideoTracks()[0].enabled = !muted;
    } else {
      showSnackBar(":::Unable to operate the camera:::");
    }
  }

  //Open or close local audio
  turnMicrophone() {
    if (localVideo != null && localVideo!.stream.getAudioTracks().length > 0) {
      var muted = !microphoneOff.value;
      microphoneOff.value = muted;
      localVideo?.stream.getAudioTracks()[0].enabled = !muted;
      showSnackBar(":::The microphone is ${muted ? 'muted' : 'unmuted'}:::");
    } else {}
  }

  cleanUp() async {
    if (localVideo != null) {
      await localStream!.unpublish();
    }
    videoRenderers.value.forEach((item) async {
      var stream = item.stream;
      try {
        rtc!.close();
        await stream.dispose();
      } catch (error) {}
    });
    videoRenderers.value.clear();
    await ionController.close();
  }

  showSnackBar(String message) {
    print(message);
  }

  hangUp() {
    Get.dialog(AlertDialog(
        title: Text("Hangup"),
        content: Text("Are you sure to leave the room?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              "Hangup",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              cleanUp();
              Get.back();
              Get.back();
            },
          )
        ]));
  }
}
