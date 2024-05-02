import 'package:flutter/material.dart';
import 'package:whatsappchat/%20feature/auth/pages/login-page.dart';
import 'package:whatsappchat/%20feature/auth/pages/user_info_page.dart';
import 'package:whatsappchat/%20feature/auth/pages/verification_page.dart';
import 'package:whatsappchat/%20feature/chat/pages/chat_page.dart';
import 'package:whatsappchat/%20feature/contact/pages/contact_page.dart';
import 'package:whatsappchat/%20feature/home/pages/home_page.dart';
import 'package:whatsappchat/%20feature/welcome/pages/welcome_page.dart';
import 'package:whatsappchat/common/models/user_model.dart';

class Routes{
  static const String welcome='welcome';
  static const String login='login';
  static const String verification='verification';
  static const String userInfo='user-Info';
  static const String home='home';
  static const String contact='contact';
  static const String chat='chat';

  static Route<dynamic>onGenerateRoure(RouteSettings settings){
    switch(settings.name){
      case welcome:
        return MaterialPageRoute(builder: (context) => const WelcomePage(),);
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage(),);
      case verification:
        final Map args =settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => VerificationPage(
            smsCodeId: args['smsCodeId'] as String,
            phoneNumber: args['phoneNumber'] as String,
          ),
        );
      case userInfo:
        final String? profileImageUser=settings.arguments as String?;
        return MaterialPageRoute(builder: (context) =>  UserInfoPage(profileImageUrl: profileImageUser,),);
      case home:
        return MaterialPageRoute(builder: (context) => const HomePage(),);
      case contact:
        return MaterialPageRoute(builder: (context) => const ContactPage(),);
        case chat:
          final UserModel user=settings.arguments as UserModel;
        return MaterialPageRoute(builder: (context) =>  ChatPage(user: user,),);
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('No pages Route Provided')),
            ),
        );
    }
  }
}