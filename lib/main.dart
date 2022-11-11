import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/firebase_options.dart';
import 'package:service_admin/theme/theme.dart';
import 'package:service_admin/ui/pages/login/auth_page.dart';
import 'ui/pages/home/home_page.dart';
import 'ui/pages/home/providers/screen_mode_provider.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF1B1C1F), // navigation bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initializeDependencyInjection();
    // await Future.delayed(Duration(seconds: 3));
    print("READY");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialize(),
      builder: (context, future) {
        if (future.connectionState != ConnectionState.done){
          return const Center(child: CircularProgressIndicator());
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ScreenModeProvider())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Service Admin',
            darkTheme: getTheme(Brightness.dark),
            theme: getTheme(Brightness.light),
            home: locator<Auth>().hasCurrentUser ? HomePage.providerWrapped() : const AuthPage(),
          ),
        );
      }
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
