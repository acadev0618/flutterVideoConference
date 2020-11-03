import 'package:flutter/widgets.dart';
import './screens/login.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  '/' : (BuildContext context) => LoginScreen(),

  // '/login': (BuildContext context) => new Login(),
};
