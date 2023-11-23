import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String uid;
  final String token;

  // You can add more parameters if needed, like a user ID or token

  VideoCallScreen(
      {Key? key,
      required this.channelName,
      required this.uid,
      required this.token})
      : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _agoraEngine;
  final _users = <int>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Center(
        child: Text('Video call with ${widget.channelName}'),
        // Here you will implement the actual video call UI using Agora SDK
      ),
    );
  }
}

Widget _renderLocalPreview() {
  return RtcLocalView.SurfaceView();
}

Widget _renderRemoteVideo() {
  return Positioned(
    right: 20,
    top: 20,
    width: 100,
    height: 150,
    child: _users.isNotEmpty
        ? RtcRemoteView.SurfaceView(uid: _users.first)
        : Container(),
  );
}

@override
void dispose() {
  // Dispose Agora engine to free up resources
  _agoraEngine.leaveChannel();
  _agoraEngine.destroy();
  super.dispose();
}
