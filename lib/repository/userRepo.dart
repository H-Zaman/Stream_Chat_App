import 'package:dio/dio.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/viewModel/viewModel.dart';

import 'streamChat.dart';

class UserRepo{
  static Future<String> getImage() async{
    Response response = await SConfig.dio.get(
      'https://api.unsplash.com/photos/random/?count=1',
    );

    // var data = imageResponseFromJson(response.data);
    return response.data[0]['urls']['regular'];
  }

  static updateUser(String imageLink, String name) async{
    await SConfig.client.updateUser(
        User(
            id: ViewModel.currentUser.id,
            extraData: imageLink == null ? {
              'name' : name ?? ViewModel.currentUser.name,
            } : {
              'image' : imageLink
            }
        )
    );
  }
}