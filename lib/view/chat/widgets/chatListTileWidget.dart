import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/helper/stringHelper.dart';
import 'package:streamchat/viewModel/viewModel.dart';

import '../chattingScreen.dart';

class ChatTileWidget extends StatefulWidget {
  final Channel channel;

  ChatTileWidget({
    @required this.channel
});

  @override
  _ChatTileWidgetState createState() => _ChatTileWidgetState();
}

class _ChatTileWidgetState extends State<ChatTileWidget> {

  bool openChat = false;

  Channel channel;

  @override
  void initState() {
    super.initState();
    channel = widget.channel;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(ChattingScreen(channel: channel)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(2,2),
                color: Colors.grey[300],
                blurRadius: 3,
                spreadRadius: 1
              )
            ]
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<Map<String, dynamic>>(                      /// chat from / channel name
                  stream: channel.extraDataStream,
                    initialData: channel.extraData,
                    builder: (_, snapshot){
                        String name;
                        if (snapshot.data['name'] == null &&
                            channel.state.members.length == 2) {
                          final otherMember = channel.state.members
                              .firstWhere((member) => member.user.id != ViewModel.currentUser.id);
                          name = otherMember.user.name;
                        } else {
                          name = snapshot.data['name'] ?? channel.id;
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                          color: Colors.blueAccent,
                          child: Text(
                            'Chat From : $name',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                    },
                  ),

                  StreamBuilder<DateTime>(                                    /// last message time or chat time
                    stream: channel.lastMessageAtStream,
                    initialData: channel.lastMessageAt,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }
                      final lastMessageAt = snapshot.data.toLocal();

                      String stringDate;
                      final now = DateTime.now();

                      if (now.year != lastMessageAt.year ||
                          now.month != lastMessageAt.month ||
                          now.day != lastMessageAt.day) {
                        stringDate = DateFormat('dd/MM/yyyy').format(lastMessageAt.toLocal());
                      } else {
                        stringDate = DateFormat().add_jm().format(lastMessageAt.toLocal());
                      }

                      return Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Row(
                          children: [
                            Text(
                              stringDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey
                              ),
                            ),

                            /// un-read message count
                            StreamBuilder<int>(
                              stream: channel.state.unreadCountStream,
                              initialData: channel.state.unreadCount,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.data == 0) {
                                  return SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: StreamChatTheme.of(context)
                                        .channelPreviewTheme
                                        .unreadCounterColor,
                                    radius: 8,
                                    child: Text(
                                      '${snapshot.data}',
                                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(                                          /// header builder
              backgroundColor: Colors.blueAccent,
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: channel.extraDataStream,
                  initialData: channel.extraData,
                  builder: (_, snapshot){
                    String name;
                    if (snapshot.data['name'] == null &&
                        channel.state.members.length == 2) {
                      final otherMember = channel.state.members
                          .firstWhere((member) => member.user.id != ViewModel.currentUser.id);
                      name = otherMember.user.name;
                    } else {
                      name = snapshot.data['name'] ?? channel.id;
                    }

                    name = StringHelper.getInitials(name);

                    return Text(
                      name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    );
                  },
                ),
              ),
              title: Padding(                                                 /// last message of the chat
                padding: EdgeInsets.only(bottom: 5),                          /// or typing status
                  child: StreamBuilder(                                       /// chat message status builder
                    initialData: channel.state.unreadCount,
                      stream: channel.state.unreadCountStream,
                      builder: (context, snapshot) {
                        return TypingIndicator(
                          channel: channel,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey
                          ),
                          alternativeWidget: StreamBuilder<List<Message>>(
                            stream: channel.state.messagesStream,
                            initialData: channel.state.messages,
                            builder: (context, snapshot) {
                              final lastMessage = snapshot.data?.lastWhere(
                                    (m) => m.shadowed != true,
                                orElse: () => null,
                              );
                              if (lastMessage == null) {
                                return SizedBox();
                              }

                              var text = lastMessage.text;
                              if (lastMessage.isDeleted) {
                                text = 'This message was deleted.';
                              } else if (lastMessage.attachments != null) {
                                final prefix = lastMessage.attachments
                                    .map((e) {
                                  if (e.type == 'image') {
                                    return '📷';
                                  } else if (e.type == 'video') {
                                    return '🎬';
                                  } else if (e.type == 'giphy') {
                                    return 'GIF';
                                  }
                                  return null;
                                })
                                    .where((e) => e != null)
                                    .join(' ');

                                text = '$prefix ${lastMessage.text ?? ''}';
                              }

                              return Text(
                                text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey
                                )
                              );
                            },
                          ),
                        );
                      },
                    ),
                )
            ),
            AnimatedCrossFade(
                firstChild: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(ChattingScreen(channel: channel)),
                            child: Text(
                              'Reply',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          width: 1,
                          height: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async => await channel.markRead(),
                            child: Text(
                              'Mark as read',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                secondChild: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter Message..',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pinkAccent)
                          ),
                        ).copyWith(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5)
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    InkWell(
                      onTap: (){
                        setState(() {
                          openChat = !openChat;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                crossFadeState: openChat ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300)
            ),
          ],
        ),
      ),
    );
  }
}
