import 'package:silent_chat/colors.dart';
import 'package:silent_chat/features/chat/widgets/chat_list.dart';
import 'package:silent_chat/features/chat/widgets/buttom_chat_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _initAgoraRtcEngine() async {
  await Permission.camera.request();
  await Permission.microphone.request();

  await AgoraRtcEngine.create(APP_ID);
  await AgoraRtcEngine.enableVideo();

  // Additional Agora setup...
}

const APP_ID =
    '92d678cd711b4114b139592a3f494d98'; // Replace with your actual App ID
const Token =
    '9022c97d07df47698541ba75dfe6bf1e'; // Replace with your actual token

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/Mobile_chatScreen';

  final String name;
  final String uid;
  const MobileChatScreen({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _initAgoraRtcEngine();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder(
          stream: ref.watch(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.data!.name),
                snapshot.data!.isOnline
                    ? const Text(
                        "Online.....",
                        style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue),
                      )
                    : const Text(
                        "Offline",
                        style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
              ],
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
            ),
          ),
          ButtomChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}
