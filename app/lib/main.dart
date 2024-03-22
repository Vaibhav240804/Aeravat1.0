import 'package:app/pages/login_page.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/routes.dart';
import 'package:app/pages/signup_page.dart';
import 'package:app/providers/providers.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'lang/localization_delegate.dart';
import 'package:telephony/telephony.dart';

backgrounMessageHandler(SmsMessage message) async {
  print("Background message: ${message.body}");
}

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Telephony telephony = Telephony.instance;

  Future<void> checkPermissions() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      print("Permissions granted");
    } else {
      print("Permissions not granted");
    }
  }

  late String _message;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    final inbox = telephony.getInboxSms();
    

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print("New message: ${message.body}");
        setState(() {
          _message = message.body!;
        });
      },
      onBackgroundMessage: backgrounMessageHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      title: "Krishi Sahayak",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          secondary: Colors.greenAccent,
          primary: Colors.white12,
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 12.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 20.0),
        ),
        useMaterial3: true,
      ),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const LogInPage(),
      locale: Provider.of<LocaleProvider>(context).locale,
      routes: {
        '/profile': (context) => const Profile(),
        '/home': (context) => const Routes(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignUpPage(),
      },
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
        Locale('hi'),
        Locale('kn'),
        Locale('ta'),
        Locale('bn')
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
