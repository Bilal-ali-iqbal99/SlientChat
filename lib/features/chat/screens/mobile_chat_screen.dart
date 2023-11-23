import 'package:silent_chat/colors.dart';
import 'package:silent_chat/features/chat/screens/videoscreen.dart';
import 'package:silent_chat/features/chat/widgets/chat_list.dart';
import 'package:silent_chat/features/chat/widgets/buttom_chat_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/Mobile_chatScreen';

  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  _MobileChatScreenState createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  Future<void> initState() async {
    super.initState();
    await initAgora();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name;
    final uid = widget.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, VideoCallScreen.routeName);
              },
              icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverUserId: uid),
          ),
          ButtomChatField(recieverUserId: uid),
        ],
      ),
    );
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
