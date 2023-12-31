import 'package:silent_chat/features/auth/controller/auth_controller.dart';
import 'package:silent_chat/features/chat/repository/chat_repository.dart';
import 'package:silent_chat/models/chat_contact_model.dart';
import 'package:silent_chat/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContactModel>> ChatContact() {
    print("This Controller funcion is called function is called");
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref.read(userDataProvider).whenData(
          (value) => {
            chatRepository.sendTextMessage(
              context: context,
              text: text,
              reciverUserId: recieverUserId,
              senderUser: value!,
            ),
          },
        );
  }
}
