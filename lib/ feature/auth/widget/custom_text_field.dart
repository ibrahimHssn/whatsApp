import 'package:flutter/material.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/utils/coloors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController?  controller;
  final String? hintText;
  final bool? readOnly;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final String? prefixText;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final double? fontSize;
  final bool? autoFocus;
  const CustomTextField({super.key,  this.controller, this.hintText,  this.readOnly, this.textAlign,  this.keyboardType, this.prefixText, this.onTap, this.suffixIcon, this.onChanged, this.fontSize, this.autoFocus});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller:controller,
      readOnly: readOnly??false,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(fontSize: fontSize),
      autofocus: autoFocus?? false,
      keyboardType: readOnly==null ?keyboardType:null,
      onChanged:onChanged,
      decoration: InputDecoration(
        isDense: true,
        prefixText: prefixText,
        suffix: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: context.theme.greyColor),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Coloors.greenDark)
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Coloors.greenDark,width: 2
        ),
      ),
    ));
  }
}
