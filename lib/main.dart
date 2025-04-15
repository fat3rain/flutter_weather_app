import 'package:flutter/material.dart';
import 'package:group_notification_app/city_list_app.dart';
import 'package:group_notification_app/features/city_list/storage/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await storage.init();
  runApp(const GroupNotificApp());
}
