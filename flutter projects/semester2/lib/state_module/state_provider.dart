import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';
import 'theme_logic.dart';
import 'gridstyle_logic.dart';
import 'splash_screen.dart';

Widget stateProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CounterLogic()),
      ChangeNotifierProvider(create: (context) => ThemLogic()),
      ChangeNotifierProvider(create: (context) => GridStyleLogic()),
    ],
    child: SplashScreen(),
  );
}
