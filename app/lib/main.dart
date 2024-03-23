import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/otp_field.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/routes.dart';
import 'package:app/pages/signup_page.dart';
import 'package:app/providers/providers.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'lang/localization_delegate.dart';
import 'package:telephony/telephony.dart';

backgrounMessageHandler(SmsMessage message) async {
  debugPrint("Background message: ${message.toString()}");
  UserProvider().setMessage(message);
}

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

Future<bool> requestCameraPermission() async {
  
  final status = await Permission.camera.request();
  if (status.isGranted) {
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Telephony telephony = Telephony.instance;
  UserProvider user = UserProvider();

  Future<void> checkPermissions() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      debugPrint("Permissions granted");
    } else {
      debugPrint("Permissions not granted");
    }
  }

  late SmsMessage _message;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        debugPrint("New message: ${message.body}");
        setState(() {
          _message = message;
        });
        Provider.of<UserProvider>(context, listen: false).setMessage(message);
      },
      onBackgroundMessage: backgrounMessageHandler,
    );
    final inbox = telephony.getInboxSms();

    inbox.then((value) {
      setState(() {
        _message = value[0];
      });
      Provider.of<UserProvider>(context, listen: false).setMessage(value[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: true).setMessage(_message);
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
      home: const Routes(),
      locale: Provider.of<LocaleProvider>(context).locale,
      routes: {
        '/profile': (context) => const Profile(),
        '/home': (context) => const Routes(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignUpPage(),
        '/otpverify': (context) => const OTPScreen(),
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
