import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';
import 'package:oas_mobile/flutx/themes/app_theme_notifier.dart';
import 'package:oas_mobile/app/landing_page/landing_page_v3.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider<FxAppThemeNotifier>(
      create: (context) => FxAppThemeNotifier(),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  static String blockChain = "Stacks";
  @override
  Widget build(BuildContext context) {
    return Consumer<FxAppThemeNotifier>(
      builder: (BuildContext context, FxAppThemeNotifier value, Widget? child) {
        return MultiProvider(
          providers: [
            Provider<Auth>(
              create: (_) => OasFirebaseAuth(),
            ),
            ProxyProvider<Auth, OasServerApis>(
              update: (_, auth, __) => OasServerApis(auth: auth),
            ),
            ProxyProvider<Auth, STXOasServerApis>(
              update: (_, auth, __) => STXOasServerApis(auth: auth),
            ),
          ],
          child: MaterialApp(
            title: 'Open Art Source',
            theme: FxAppTheme.getThemeFromThemeMode(),
            home: LandingPageV3(),
          ),
        );
      },
    );
  }
}
