import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/repository/streamChat.dart';
import 'package:streamchat/view/chat/chattingScreen.dart';
import 'package:streamchat/viewModel/viewModel.dart';

class FCMHandler{
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static init() async{
    print('FCM INITIALIZED');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.configure(
        onMessage: FCMHandler.onMessageHandler,
        onBackgroundMessage: FCMHandler.backgroundMessageHandler,
        onLaunch: FCMHandler.onLaunchHandler,
        onResume: FCMHandler.onResumeHandler
    );
    await SConfig.client.addDevice(await _firebaseMessaging.getToken(), PushProvider.firebase);
  }

  /// execute when app is the foreground
  static Future<dynamic> onMessageHandler(Map<String, dynamic> message) async {
    print('------------------onMessageHandler');
    print(message['data']['channel']);

  }

  /// execute when app is terminated
  /// auto show notification
  static Future<dynamic> onLaunchHandler(Map<String, dynamic> message) async {
    print('------------------onLaunchHandler');
    ViewModel.screenLoading(true);
    await SConfig.client.connect();
    List<Channel> channels = await SConfig.client.queryChannels(
        filter: {
          'members': {
            '\$in': [ViewModel.currentUser.id]
          }
        }
    );
    ViewModel.screenLoading(false);
    channels.forEach((element) {
      if(element.id == message['data']['channel']){
        Get.to(ChattingScreen(channel: element));
      }
    });
  }

  /// when app is in background
  /// auto show notification
  static Future<dynamic> onResumeHandler(Map<String, dynamic> message) async {
    print('------------------onResumeHandler');
    ViewModel.screenLoading(true);
    await SConfig.client.connect();
    List<Channel> channels = await SConfig.client.queryChannels(
      filter: {
        'members': {
          '\$in': [ViewModel.currentUser.id]
        }
      }
    );
    ViewModel.screenLoading(false);
    channels.forEach((element) {
      if(element.id == message['data']['channel']){
        Get.to(ChattingScreen(channel: element));
      }
    });
  }

  static Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async  {
    print('------------------backgroundMessageHandler');
    ViewModel.screenLoading(true);
    await SConfig.client.connect();
    List<Channel> channels = await SConfig.client.queryChannels(
        filter: {
          'members': {
            '\$in': [ViewModel.currentUser.id]
          }
        }
    );
    ViewModel.screenLoading(false);
    channels.forEach((element) {
      if(element.id == message['data']['channel']){
        Get.to(ChattingScreen(channel: element));
      }
    });
  }
}