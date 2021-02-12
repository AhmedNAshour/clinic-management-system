import 'package:clinic/components/forms/text_field_container.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    Key key,
    this.hintText,
    this.onChanged,
    this.validator,
    this.obsecureText,
    this.labelText,
    this.initialValue,
    this.iconPath,
  }) : super(key: key);

  final String hintText;
  final String iconPath;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final bool obsecureText;
  final String labelText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: kPrimaryColor,
          ),
          icon: SvgPicture.asset(
            iconPath,
            color: kPrimaryTextColor,
            // width: size.width * 0.0,
            // height: size.width * 0.07,
          ),
          hintText: hintText,
          focusColor: kPrimaryColor,
        ),
      ),
    );
  }
}
