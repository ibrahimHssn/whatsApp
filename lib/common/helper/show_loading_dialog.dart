import 'package:flutter/material.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/utils/coloors.dart';

showLoadingDialog({required BuildContext context,required String massage})async{
  return await showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const CircularProgressIndicator(color:  Coloors.greenDark,),
            const SizedBox(width: 20,),
            Expanded(child: Text(massage,style:  TextStyle(fontSize: 15,color: context.theme.greyColor,height: 1.5),))
          ],)
      ],),
    );
  },);
}