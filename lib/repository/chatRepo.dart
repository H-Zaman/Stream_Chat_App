import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/repository/streamChat.dart';
import 'package:streamchat/viewModel/viewModel.dart';

class ChatRepo{
  static Future<Channel> createChat(String channelId, String userId) async{
    final channel = SConfig.client.channel(
      'messaging',
      id: channelId,
      extraData: {
        'members' : [
          ViewModel.currentUser.id,
          userId
        ]
      }
    );


    await channel.create();

    await channel.watch();

    return channel;
  }
}