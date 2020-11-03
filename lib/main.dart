import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './locale/app_localization.dart';
import './theme/style.dart';
import './routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('configurations');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  AppLocalizationDelegate _localeOverrideDelegate = 
  AppLocalizationDelegate(Locale('en','US'));
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        _localeOverrideDelegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('tk', 'TK'),
      ],
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      title: 'Flutter FunsTrans App',
      initialRoute: '/',
      routes: routes,
    );
  }
}
