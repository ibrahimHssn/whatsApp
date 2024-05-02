import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappchat/%20feature/auth/controller/auth_controller.dart';
import 'package:whatsappchat/%20feature/auth/pages/image_picker_page.dart';
import 'package:whatsappchat/%20feature/auth/widget/custom_text_field.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/helper/show_alert_dialog.dart';
import 'package:whatsappchat/common/utils/coloors.dart';
import 'package:whatsappchat/common/widget/custom_elevated_button.dart';
import 'package:whatsappchat/common/widget/custom_icon_button.dart';
import 'package:whatsappchat/common/widget/short_h_bar.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String? profileImageUrl;

  const UserInfoPage({super.key, this.profileImageUrl});
  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  File?imageCamera;
  Uint8List? imageGallery;
  late TextEditingController userNameController;
  saveUserDataToFirebase(){
    String username=userNameController.text;
    if(username.isEmpty){
      showAlertDialog(context: context, message: 'please provide a username');
    }else if(username.length<3 ||username.length>20){
      showAlertDialog(context: context, message: 'A username length should be between 3-20');
    }
    ref.read(authControllerProvider).saveUserInfoToFireStore(
        username: username,
        profileImage: imageCamera ?? imageGallery ??widget.profileImageUrl?? '',
        context: context,
        mounted: mounted);
  }
  imagePickerTypeBottomSheet(){
    return showModalBottomSheet( context: context, builder: (BuildContext context) {
      return   Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShortHBar(),
          Row(
            children: [
              const SizedBox(width: 20,),
              const Text("Profile photo",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),),
              const Spacer(),
              CustomIconButton(onTap: ()=>Navigator.pop(context), icon: Icons.close),
              const SizedBox(width: 15,),
            ],
          ),
          Divider(color: context.theme.greyColor!.withOpacity(0.3),),
          const SizedBox(height: 5,),
          Row(children: [
            const SizedBox(width: 25,),
            imagePickerIcon(onTap: pickImageFromCamera, icon: Icons.camera_alt_rounded, text: "Camera"),
            const SizedBox(width: 20,),
            imagePickerIcon(onTap: ()async{
              Navigator.pop(context);
            final image= await Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) => const ImagePickerPage(),)
              );
            if(image==null)return;
            setState(() {
              imageGallery=image;
              imageCamera=null;
            });
            }, icon: Icons.photo_camera, text: "Gallery"),
          ],),
          const SizedBox(width: 15,),

        ],
      );
    });
  }
  pickImageFromCamera()async{
    Navigator.of(context).pop();
    final image= await ImagePicker().pickImage(source: ImageSource.camera);
    try{
      setState(() {
        imageCamera =File(image!.path);
        imageGallery =null;
      });
    }catch(e){
      showAlertDialog(context: context, message: e.toString());
    }
  }
  imagePickerIcon({
    required VoidCallback onTap,
    required icon,
    required String text,
}){
    return Column(
      children: [
        CustomIconButton(onTap: onTap,
            icon: icon,iconColor: Coloors.greenDark,
          minWidth: 50,
          border: Border.all(
            color: context.theme.greyColor!.withOpacity(.2),
            width: 1,
          ),
        ),
        const SizedBox(height: 5,),
        Text(text,style: TextStyle(color: context.theme.greyColor),),
      ],
    );
  }
  @override

  void initState(){
    userNameController=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: Text('Profile info',style: TextStyle(color: context.theme.authAppbarTextColor,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Text("Please provide your name and an optional profile photo",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.theme.greyColor),),
            ),
            const SizedBox(height: 40,),
            GestureDetector(
              onTap: imagePickerTypeBottomSheet,
              child: Container(
                  padding: const EdgeInsets.all(26),
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.photoIconBgColor,
                    border: Border.all(
                      color: imageCamera==null&&imageGallery==null?Colors.transparent :context.theme.greyColor!.withOpacity(0.4),
                    ),
                      image: imageCamera != null || imageGallery != null || widget.profileImageUrl ==null
                          ? DecorationImage(
                              fit: BoxFit.contain,
                              image: imageGallery != null
                                  ? MemoryImage(imageGallery!) as ImageProvider
                                  :widget.profileImageUrl ==null?NetworkImage(widget.profileImageUrl!): FileImage(imageCamera!) as ImageProvider,
                            )
                          : null),
                  child: Center(
                      child: Icon(
                    Icons.add_a_photo_rounded,
                    size: 48,
                    color: imageCamera == null && imageGallery == null &&widget.profileImageUrl==null
                        ? context.theme.photoIconColor
                        : Colors.transparent,
                  ))),
            ),
            const SizedBox(height: 40,),
             Row(
              children: [
                const SizedBox(width: 20,),
                 Expanded(child: CustomTextField(
                  controller: userNameController,
                  hintText: 'Type your name here',
                  textAlign: TextAlign.left,
                  autoFocus: true,

                )),
                const SizedBox(width: 10,),
                Icon(Icons.emoji_emotions_outlined,color: context.theme.photoIconColor,),
                const SizedBox(width: 20,),


              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(onPressed: saveUserDataToFirebase, text: 'NEXT',buttonWidth: 90,),
    );
  }
}
