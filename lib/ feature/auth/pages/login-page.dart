import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/%20feature/auth/controller/auth_controller.dart';
import 'package:whatsappchat/common/widget/custom_icon_button.dart';
import 'package:whatsappchat/%20feature/auth/widget/custom_text_field.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/helper/show_alert_dialog.dart';
import 'package:whatsappchat/common/utils/coloors.dart';
import 'package:whatsappchat/common/widget/custom_elevated_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;
  sendCodeToPhone() {
    final String phoneNumber = phoneNumberController.text;
    final String countryName = countryNameController.text;
    final String countryCode = countryCodeController.text;

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter your phone number"),
      ));
      return;
    }
    else if (phoneNumber.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("The Phone number you entered is too short for the country: $countryName.\n\nInclude your area code if you haven't"),
      ));
      return;
    }
    else if (phoneNumber.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("The phone number you entered is too long for the country: $countryName"),
      ));
      return;
    }
    //request a verification code
    ref.read(authControllerProvider).sendSmsCode(context: context, phoneNumber: '+$countryCode$phoneNumber');
  }
  showCountryCodePicker(){
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: ['Eg'],
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 600,
        backgroundColor: Theme.of(context).backgroundColor,
        flagSize: 22,
        borderRadius: BorderRadius.circular(20),
        textStyle: TextStyle(color: context.theme.greyColor),
        inputDecoration: InputDecoration(
          labelStyle: TextStyle(color: context.theme.greyColor),
          prefixIcon: const Icon(Icons.language,color: Coloors.greenDark,),
          hintText: 'Search country code or name',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: context.theme.greyColor!.withOpacity(0.2),
            )
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Coloors.greenDark,
              )
          ),

        )
      ),
      onSelect: (value) {
        countryNameController.text=value.name;
        countryCodeController.text=value.phoneCode;
      },
    );
  }
  @override
  void initState(){
    countryNameController=TextEditingController(text: "Egypt");
    countryCodeController=TextEditingController(text: "20");
    phoneNumberController=TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    countryNameController.dispose();
    countryCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title:  Text("Enter your phone number",style: TextStyle(color:context.theme.authAppbarTextColor ),),
        centerTitle: true,
        actions:  [
          CustomIconButton(onTap: () {}, icon: Icons.more_vert,),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
              text: "WhatsApp will need to verify your phone number. ",
              style: TextStyle(
                color: context.theme.greyColor,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "What's my number?",
                  style: TextStyle(
                    color: context.theme.blueColor,
                  ),
                )
              ]
            )),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding:  const EdgeInsets.symmetric(horizontal: 50),
            child: CustomTextField(
              onTap:showCountryCodePicker ,
              controller: countryNameController,
              readOnly: true,
              suffixIcon: const Icon(Icons.arrow_drop_down,color: Coloors.greenDark,),

            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              children: [
                SizedBox(width: 70,
                child:CustomTextField(
                  onTap:  showCountryCodePicker,
                  controller: countryCodeController,
                  prefixText: '+',
                  readOnly: true,

                ) ,
                ),
                const SizedBox(width: 10,),
                Expanded(child: CustomTextField(
                  controller:phoneNumberController,
                  hintText: "Phone number",
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Text("Carrier charges may apply",style: TextStyle(color: context.theme.greyColor),)

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(onPressed: sendCodeToPhone, text: "NEXT",buttonWidth: 90,),
    );
  }


}
