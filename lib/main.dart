import 'package:flutter/material.dart';

import 'app.dart';

// Quando o Firebase estiver configurado (`flutterfire configure`, ver
// README), inicialize antes de rodar o app:
//
//   import 'package:firebase_core/firebase_core.dart';
//   import 'firebase_options.dart';
//
//   void main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     runApp(const UniBusApp());
//   }
void main() {
  runApp(const UniBusApp());
}
