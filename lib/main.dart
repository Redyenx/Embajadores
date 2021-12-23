import 'dart:io';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/authentication/sign_in_page.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

var initialRoute = '/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final prefs = UserPreferences();
  await prefs.initPrefs();
  configLoading();
  runApp(const Embajadores());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black38
    ..indicatorColor = Colors.white70
    ..textColor = Colors.lightBlueAccent
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false;
}

class Embajadores extends StatefulWidget {
  const Embajadores({Key? key}) : super(key: key);

  @override
  _EmbajadoresState createState() => _EmbajadoresState();
}

class _EmbajadoresState extends State<Embajadores> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => APIService()),
      ChangeNotifierProvider(create: (_) => CounterProvider()),
      ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
      locale: const Locale('es'),
      builder: EasyLoading.init(),
      title: 'Embajadores',
      theme: theme.darkTheme ? dark : light,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  final prefs = UserPreferences();
  Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (prefs.checkUserId() == false) {
      return SignInPage();
    } else {
      return const HomePage();
    }
  }
}
