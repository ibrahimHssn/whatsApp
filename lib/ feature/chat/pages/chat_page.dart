import 'package:flutter/material.dart';
import 'package:whatsappchat/common/models/user_model.dart';
import 'package:whatsappchat/common/widget/custom_icon_button.dart';

class ChatPage extends StatelessWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {Navigator.of(context).pop();},
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.profileImageUrl),
              )
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(user.userName,style:const TextStyle(fontSize: 18,color: Colors.white)),
          const SizedBox(height: 3,),
          const Text("last Seen 2 min ago",style: TextStyle(fontSize: 12),),
        ],
        ),
        actions: [
          CustomIconButton(onTap: (){}, icon: Icons.video_call),
          CustomIconButton(onTap: (){}, icon: Icons.call),
          CustomIconButton(onTap: (){}, icon: Icons.more_vert),
        ],
      ),
    );
  }
}
