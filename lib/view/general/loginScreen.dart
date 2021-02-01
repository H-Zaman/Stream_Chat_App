import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streamchat/_demoData/users.dart';
import 'package:streamchat/model/userModel.dart';
import 'package:streamchat/view/chat/chatListScreen.dart';
import 'package:streamchat/repository/streamChat.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:streamchat/view/widgets/screenLoading.dart';
import 'package:streamchat/viewModel/viewModel.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(()=>IsScreenLoading(
      screenLoading: ViewModel.appLoading.value,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a user to login',
                  style: TextStyle(
                      fontSize: 24
                  ),
                ),
                SizedBox(height: 28,),
                Flexible(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: .7
                    ),
                    itemCount: DemoUsers.users.length,
                    itemBuilder: (_, index){
                      UserModel user = DemoUsers.users[index];
                      return GestureDetector(
                        onTap: () async{
                          /// SIMULATING LOGIN

                          ViewModel.screenLoading(true);
                          ViewModel.currentUser = user;

                          ///THIS SETS THE USER IN STREAM CHAT
                          ///
                          /// IF THE USER EXIST IT LOGS IT SELF IN
                          /// IF THE USER DOES NOT EXIST IT CREATES THE USER AND THEN LOG IN
                          await SConfig.client.setUser(
                              User(
                                  id: user.id,
                                  extraData: {
                                    'name' : user.name,
                                    'image': user.image
                                  }
                              ),
                              SConfig.client.devToken(user.id)
                          );

                          ViewModel.screenLoading(false);

                          Get.offAll(ChatListScreen());
                        },
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: user.image,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (_,__,___) => CircularProgressIndicator(),
                              ),
                            ),
                            Text(
                              user.name,
                              style: TextStyle(
                                  fontSize: 12
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
      ),
    ));
  }
}
