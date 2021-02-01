import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/_demoData/users.dart';
import 'package:streamchat/model/userModel.dart';
import 'package:streamchat/repository/chatRepo.dart';
import 'package:streamchat/repository/streamChat.dart';
import 'package:streamchat/repository/userRepo.dart';
import 'package:streamchat/view/widgets/screenLoading.dart';
import 'package:streamchat/viewModel/viewModel.dart';

import 'chattingScreen.dart';

class ChatListScreen extends StatelessWidget {
  final users = DemoUsers.users.where((element) =>
  element.id != ViewModel.currentUser.id).toList();
  @override
  Widget build(BuildContext context) {

    String imageLink = '';

    return Obx(()=>IsScreenLoading(
      screenLoading: ViewModel.appLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: (){
                SConfig.client.disconnect(clearUser: true);
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
              /*DrawerHeader(
                child: TextFormField(
                  initialValue: ViewModel.currentUser.name,
                  onFieldSubmitted: (value) async{
                    UserRepo.updateUser(null, value);
                  },
                ),
              ),
              DrawerHeader(
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: UserRepo.getImage(),
                        builder: (_,snapShot){
                          if(snapShot.connectionState == ConnectionState.done){
                            imageLink = snapShot.data;
                            return Image.network(
                              snapShot.data,
                              height: 200,
                              width: 150,
                            );
                          }else{
                            return Text('Working');
                          }
                        },
                      ),
                      FlatButton(onPressed: () async {
                        ViewModel.screenLoading(true);
                        await UserRepo.updateUser(imageLink,null);
                        ViewModel.screenLoading(false);
                      }, child: Text('Set image'))
                    ],
                  )
              ),*/
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 50),
                itemCount: users.length,
                itemBuilder: (_, index) {
                  UserModel user = users[index];
                  return GestureDetector(
                    onTap: () async {
                      /// chat with user
                      Channel channel = await ChatRepo.createChat(
                          user.id + ViewModel.currentUser.id, user.id);
                      Get.to(ChattingScreen(channel: channel));

                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                        child: Text(
                            user.id
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  'List to Chat',
                  style: TextStyle(
                      fontSize: 24
                  ),
                )
            ),
            Expanded(
              flex: 9,
              child: ChannelsBloc(
                child: ChannelListView(
                  pagination: PaginationParams(limit: 20),
                  filter: {
                    'members': {
                      '\$in': [ViewModel.currentUser.id]
                    }
                  },
                  /*channelPreviewBuilder: (_, channel) => StreamBuilder<Map<String, dynamic>>(
                    stream: channel.extraDataStream,
                    initialData: channel.extraData,
                    builder: (context, snapshot) {
                      String title;
                      if (snapshot.data['name'] == null &&
                          channel.state.members.length == 2) {
                        final otherMember = channel.state.members
                            .firstWhere((member) => member.user.id != ViewModel.currentUser.id);
                        title = otherMember.user.name;
                      } else {
                        title = snapshot.data['name'] ?? channel.id;
                      }

                      return Text(
                        title.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),*/
                  sort: [SortOption('last_message_at')],
                  onChannelTap: (channel, _) => Get.to(ChattingScreen(channel: channel)),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
