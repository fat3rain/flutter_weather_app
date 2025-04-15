import 'package:flutter/material.dart';
import 'package:group_notification_app/features/city_list/city_list.dart';

import 'package:group_notification_app/theme/theme.dart';

class GroupNotificApp extends StatelessWidget {
  const GroupNotificApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: standTheme,
      debugShowCheckedModeBanner: false,
      initialRoute:'/',
      routes: {
        '/':(context) => const CityListScreen(title: '')
      },

      // routes: routes,
    );
  }
}
