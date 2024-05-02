import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/common/helper/show_alert_dialog.dart';
import 'package:whatsappchat/common/helper/show_loading_dialog.dart';
import 'package:whatsappchat/common/models/user_model.dart';
import 'package:whatsappchat/common/repository/firebase_storage_repository.dart';
import 'package:whatsappchat/common/routes/routes.dart';
final authRepositoryProvider=Provider((ref) {return  AuthRepository(auth: FirebaseAuth.instance,realtime: FirebaseDatabase.instance,firestore: FirebaseFirestore.instance);});
class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase  realtime;

  AuthRepository({required this.auth, required this.firestore, required this.realtime});

  void verifySmsCode({required BuildContext context, required String smsCodeId,required String smsCode,required bool mounted})async{
    try{
      showLoadingDialog(context: context, massage: 'Verifying code ...');
      final credential=PhoneAuthProvider.credential(verificationId: smsCodeId, smsCode: smsCode);
     await auth.signInWithCredential(credential);
      UserModel? user =await getCurrentUserInfo();
     if(!mounted)return;
     Navigator.of(context).pushNamedAndRemoveUntil(Routes.userInfo, (route) => false,
     arguments: user?.profileImageUrl,
     );
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void updateUserPresence()async{
    Map<String,dynamic> online={
      'active':true,
      'lastSeen':DateTime.now().microsecondsSinceEpoch,
    };
    Map<String,dynamic> offline={
      'active':false,
      'lastSeen':DateTime.now().microsecondsSinceEpoch,
    };
    final connectedRef=realtime.ref('.info/connected');
    connectedRef.onValue.listen((event) async{
      final isConnected=event.snapshot.value as bool? ?? false;
      if(isConnected){
        await realtime.ref().child(auth.currentUser!.uid).update(online);

      }else{
        realtime.ref().child(auth.currentUser!.uid).onDisconnect().update(offline);
      }
    });
  }

  Future<UserModel?>getCurrentUserInfo()async{
    UserModel? user;
    final userInfo=await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if(userInfo.data()==null)return user;
    user=UserModel.fromMap(userInfo.data()!);
    return user;
  }

  void saveUserInfoToFireStore({
    required String username,
    required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
})async{
    try{
      showLoadingDialog(context: context, massage: 'Saving user info ...');
      String uid=auth.currentUser!.uid;
      String profileImageUrl=profileImage is String ? profileImage:'';
      if(profileImageUrl !=null && profileImage is! String ){
        profileImageUrl=await ref.read(firebaseStorageRepositoryProvider).storeFileToFirebase('profileImage/$uid', profileImage);
      }
      UserModel user = UserModel(userName: username.toString(),
          uid: uid,
          profileImageUrl: profileImageUrl,
          active: true,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      if(!mounted)return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }catch(e){
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }

  }
  void sendSmsCode({required BuildContext context,required String phoneNumber})async{
    try{
      showLoadingDialog(context: context, massage: "Sending a verification code to $phoneNumber");
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential)async{await auth.signInWithCredential(credential);},
          verificationFailed: (e){showAlertDialog(context: context, message: e.toString());},
          codeSent: (smsCodeId,resendSmsCodeId){
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.verification, (route) => false,
          arguments: {
            'phoneNumber':phoneNumber,
            'smsCodeId':smsCodeId,
              }
          );
          },
          codeAutoRetrievalTimeout: (String smsCodeId){}
      );
    }on FirebaseAuth catch(e){
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }
}