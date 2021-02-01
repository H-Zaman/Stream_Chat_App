import 'package:streamchat/model/userModel.dart';
import 'package:get/get.dart';



class ViewModel{
  static UserModel currentUser = UserModel();

  static var appLoading = false.obs;
  static screenLoading(bool status) => appLoading.value = status;
}