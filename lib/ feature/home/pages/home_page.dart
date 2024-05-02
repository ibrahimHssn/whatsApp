import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/%20feature/auth/controller/auth_controller.dart';
import 'package:whatsappchat/%20feature/home/pages/chat_home_page.dart';
import 'package:whatsappchat/common/widget/custom_icon_button.dart';

import 'call_home_page.dart';
import 'status_home_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
class _HomePageState extends ConsumerState<HomePage> {
  late Timer timer;
  updateUserPresence(){
    return ref.read(authControllerProvider).updateUserPresence();
  }
  @override
  void initState(){
    updateUserPresence();
    timer=Timer.periodic(const Duration(minutes: 1), (timer) =>setState(() {}));
    super.initState();
  }

  void dispose(){
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        title:const Text('WhatsApp',style: TextStyle(letterSpacing: 1),),
      elevation: 1,
        actions: [
          CustomIconButton(onTap: (){}, icon: Icons.search),
          CustomIconButton(onTap: (){}, icon: Icons.more_vert),
        ],
        bottom: const TabBar(
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            splashFactory: NoSplash.splashFactory,
            tabs: [
          Tab(text: 'CHATS'),
          Tab(text: 'STATUS'),
          Tab(text: 'CALLS'),
        ]),
      ),
      body: const TabBarView(children: [
        ChatHomePage(),
        StatusHomePage(),
        CallHomePage(),
      ]),
    ),
    );
  }
}
