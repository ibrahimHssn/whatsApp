
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappchat/%20feature/welcome/widget/language_button.dart';
import 'package:whatsappchat/%20feature/welcome/widget/privacy_and_terms.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/routes/routes.dart';
import 'package:whatsappchat/common/utils/coloors.dart';
import 'package:whatsappchat/common/widget/custom_elevated_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  navigateToLoginPage(context){
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(
        children: [
          Expanded(child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
              child: Image.asset("assets/images/circle.png",color:  context.theme.circleImageColor,),
            ),
          )),
           const SizedBox(height: 40,),
           Expanded(
               child:Column(
            children: [
              const Text("Welcome to WhatsApp",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              PrivacyAndTerms(),
              CustomElevatedButton( text: 'AGREE AND CONTINUE',onPressed:() =>  navigateToLoginPage(context),),
              const SizedBox(height: 50,),
              const LanguageButton(),
            ],
          )
          ),
        ],
      )
    );
  }
}

