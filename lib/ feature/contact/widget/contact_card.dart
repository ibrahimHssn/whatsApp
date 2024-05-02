import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/models/user_model.dart';
import 'package:whatsappchat/common/utils/coloors.dart';

class ContactCard extends StatelessWidget {
  final UserModel contactSource;
  final VoidCallback onTap;
  const ContactCard({super.key, required this.contactSource, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:onTap ,
      contentPadding: const EdgeInsets.only(left: 20,right: 10,top: 0,bottom: 0),
      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor!.withOpacity(0.3),
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty?NetworkImage(contactSource.profileImageUrl):null,
        child: contactSource.profileImageUrl.isEmpty?  const Icon(Icons.person,size: 30,color: Colors.white,):null,
      ),
      title: Text(contactSource.userName,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
      subtitle: contactSource.profileImageUrl.isEmpty?null:Text("Hey there! I'm using WhatsApp",style: TextStyle(color: context.theme.greyColor,fontWeight: FontWeight.w600),),
      trailing:contactSource.profileImageUrl.isEmpty? TextButton(onPressed:()=>onTap,style: TextButton.styleFrom(foregroundColor: Coloors.greenDark), child: const Text('INVITE')):null,

    );
  }
}
