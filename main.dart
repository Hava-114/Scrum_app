import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scrum_app/view/login.dart';
import 'package:scrum_app/view/myapp.dart';
import 'package:scrum_app/view/newtask.dart';
import 'package:scrum_app/view/profile.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'firebase.dart';
import 'package:provider/provider.dart';
import 'view_model/login_vm.dart';
import 'view/home.dart';
import 'view_model/home_vm.dart';
import 'view_model/new_task.dart';
import 'package:gsheets/gsheets.dart';
import 'view_model/credentials.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  tzdata.initializeTimeZones();
  await GsheetIntit();
  final india = tz.getLocation('Asia/Kolkata');
  final now = tz.TZDateTime.now(india);
  print("Current IST time: $now");
  // Initialize Firebase: pass web options only on web; on native platforms
  // Firebase picks up configuration from google-services.json / plist.
  final options = DefaultFirebaseOptions.currentPlatform;
  if (options != null) {
    await Firebase.initializeApp(options: options);
  } else {
    await Firebase.initializeApp();
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginVM()),
        ChangeNotifierProvider(create: (_) => HomeVm()), // 🔥 REQUIRED
        ChangeNotifierProvider(create: (_) => UserTask()),
      ],
      child: const MyApp(),
    ),
  );

}

