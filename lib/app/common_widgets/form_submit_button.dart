import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oas_mobile/app/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          height: 44.0,
          color: Colors.black54,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
