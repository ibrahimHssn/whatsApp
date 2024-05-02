import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/%20feature/auth/repository/auth_repository.dart';
import 'package:whatsappchat/common/models/user_model.dart';
final authControllerProvider=Provider((ref){
  final authRepository=ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});
final userInfoAuthProvider=FutureProvider((ref){
  final authController=ref.watch(authControllerProvider);
  return authController.getCurrentUserInfo();
});
class AuthController{final AuthRepository authRepository;
 ProviderRef ref;

  AuthController({required this.authRepository,required this.ref});
void updateUserPresence(){
  return authRepository.updateUserPresence();
}
Future<UserModel?>getCurrentUserInfo()async{
  UserModel? user=await authRepository.getCurrentUserInfo();
  return user;
}
void saveUserInfoToFireStore({
  required String username,
  required var profileImage,
  required BuildContext context,
  required bool mounted,
}){
  authRepository.saveUserInfoToFireStore(username: username, profileImage: profileImage, ref: ref, context: context, mounted: mounted);
}
  void verifySmsCode({required BuildContext context, required String smsCodeId,required String smsCode,required bool mounted})async{
    authRepository.verifySmsCode(context: context, smsCodeId: smsCodeId, smsCode: smsCode, mounted: mounted);
  }

  void  sendSmsCode({required BuildContext context,required String phoneNumber})async{
    authRepository.sendSmsCode(context: context, phoneNumber: phoneNumber);
  }
}