import 'package:silent_chat/colors.dart';
import 'package:silent_chat/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/chat_controller.dart';
import '../../../models/chat_contact_model.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.watch(chatControllerProvider).ChatContact(),
          builder: (context, snapShot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapShot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var chatContactData = snapShot.data![index];
                return snapShot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 1),
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    chatContactData.lastMessage.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(chatContactData.profilePic),
                                  radius: 25,
                                ),
                                trailing: Text(
                                  chatContactData.timeSent.hour.toString() +
                                      ":" +
                                      chatContactData.timeSent.minute
                                          .toString(),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            //  indent: 80,
                            color: dividerColor,
                          )
                        ],
                      );
              },
            );
          }),
    );
  }
}
