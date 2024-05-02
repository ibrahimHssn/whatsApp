import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/%20feature/auth/controller/auth_controller.dart';
import 'package:whatsappchat/%20feature/home/pages/home_page.dart';
import 'package:whatsappchat/%20feature/welcome/pages/welcome_page.dart';
import 'package:whatsappchat/common/theme/dark_theme.dart';
import 'package:whatsappchat/common/theme/light_theme.dart';

import 'common/routes/routes.dart';
import 'firebase_options.dart';

void main() async{
 WidgetsBinding widgetsBinding= WidgetsFlutterBinding.ensureInitialized();
 FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Chat',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home:ref.watch(userInfoAuthProvider).when(data: (user) {
        FlutterNativeSplash.remove();
        if(user==null)return const WelcomePage();
        return const HomePage();
      }, error: (error, stackTrace) {
        return const Scaffold(body: Center(child: Text("Something wrong happened!")),);
      }, loading: () {
        return const SizedBox.shrink();
          //Scaffold(body: Center(child: Image.asset('assets/icon/whatsapp.ico',height: 50,)),);
      },), //UserInfoPage(),
      onGenerateRoute: Routes.onGenerateRoure,
    );
  }
}

