import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChattingScreen extends StatelessWidget {
  final channel;
  ChattingScreen({
    @required this.channel
});
  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Scaffold(
        appBar: ChannelHeader(),
        body: Column(
          children: [
            Expanded(child: MessageListView()),
            MessageInput()
          ],
        ),
      ),
    );
  }
}
