import 'package:flutter/material.dart';
import 'package:oas_mobile/app/common_widgets/show_alert_dialog.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:provider/provider.dart';

mixin Logout {
  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut!) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      auth.signOut();
    } catch (e) {
      // todo: ERROR HANDLING
      print(e.toString());
    }
  }
}