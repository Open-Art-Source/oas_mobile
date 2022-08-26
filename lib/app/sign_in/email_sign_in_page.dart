import 'package:flutter/material.dart';
import 'package:oas_mobile/app/sign_in/sign_in_page_v2.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OasAppBar(
        title: 'Sign In',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            //child: EmailSignInFormBlockBased.create(context),
            child: SignInForm.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
