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
          seedColor: Colors.brown.shade300,
          secondary: Colors.lime.shade400,
          primary: Colors.brown,
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 12.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 20.0),
        ),
        // push notification if soil data is not available-->
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.amber.shade400,
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.amber.shade400,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          selectedIconTheme: const IconThemeData(size: 30.0),
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
