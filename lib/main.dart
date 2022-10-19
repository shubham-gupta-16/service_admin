import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_admin/api/di/provider_di.dart';
import 'package:service_admin/firebase_options.dart';
import 'package:service_admin/theme/theme.dart';

import 'ui/pages/home_page.dart';
import 'ui/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF1B1C1F), // navigation bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Admin',
      darkTheme: getTheme(Brightness.dark),
      theme: getTheme(Brightness.light),
      home: const SplashPage(),
    );
  }
}

// class SplashPage extends StatelessWidget {
//   const SplashPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: const Text('Open'),
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const HomePage()));
//           },
//         ),
//       ),
//     );
//   }
// }
