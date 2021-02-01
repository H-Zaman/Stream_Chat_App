import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/_demoData/users.dart';
import 'package:streamchat/helper/fcm.dart';
import 'package:streamchat/repository/chatRepo.dart';
import 'package:streamchat/repository/streamChat.dart';
import 'package:streamchat/view/chat/widgets/chatListTileWidget.dart';
import 'package:streamchat/view/general/loginScreen.dart';
import 'package:streamchat/view/widgets/screenLoading.dart';
import 'package:streamchat/viewModel/viewModel.dart';

import 'chattingScreen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  void initState() {
    super.initState();
    FCMHandler.init();
  }

  final users = DemoUsers.users.where((element) => element.id != ViewModel.currentUser.id).toList();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>IsScreenLoading(
      screenLoading: ViewModel.appLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ViewModel.currentUser.name,
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
          actions: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                ViewModel.currentUser.image
              ),
            ),
            TextButton(
              onPressed: (){
                SConfig.client.disconnect(clearUser: true);
                Get.offAll(LoginScreen());
              },
              child: Text(
                'Logout'
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Wrap(
                children: users.map((user) => ListTile(
                  onTap: () async {

                    ViewModel.screenLoading(true);

                    /// create a chat with the user
                    ///
                    /// if the chat already exist go to that chat
                    /// else create a new chat
                    Channel channel = await ChatRepo.createChat(
                        user.id + ViewModel.currentUser.id,
                        user.id
                    );

                    ViewModel.screenLoading(false);
                    Get.to(ChattingScreen(channel: channel));

                  },
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        user.image
                    ),
                  ),
                  title: Text(
                    user.name
                  ),
                  subtitle: Text(
                    user.id
                  ),
                )).toList(),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ChannelsBloc(
            child: ChannelListView(
              pagination: PaginationParams(limit: 20),

              /// making sure the chats only the user is in is shown
              filter: {
                'members': {
                  '\$in': [ViewModel.currentUser.id]
                }
              },
              /// when there is no chat builds this
              emptyBuilder: (_)=> Center(
                child: Text(
                  'You have no chats, start a chat with a friend <3'
                ),
              ),
              /// custom channel preview
              channelPreviewBuilder: (_, channel) => ChatTileWidget(channel: channel),
              sort: [SortOption('last_message_at')],
            ),
          ),
        )
      ),
    ));
  }
}
