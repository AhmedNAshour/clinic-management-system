import 'package:clinic/components/forms/text_field_container.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.validator,
    this.obsecureText,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final bool obsecureText;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none),
      ),
    );
  }
}
