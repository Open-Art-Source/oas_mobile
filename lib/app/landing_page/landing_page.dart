import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/artist/my_artworks_page.dart';
import 'package:oas_mobile/app/mobx_stores/my_artworks_store.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/sign_in/sign_in_page.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final oasServerApis = Provider.of<OasServerApis>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }

            return Provider<MyArtworksStore>(
              create: (_) => MyArtworksStore(oasServerApis),
              child: MyArtworksPage(),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
