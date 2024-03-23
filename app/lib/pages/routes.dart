import 'package:app/pages/chat_bot.dart';
import 'package:app/pages/doc_help.dart';
import 'package:app/pages/uploaddoc.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/abs_lan.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/providers/providers.dart';
import 'package:app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  int _currentIndex = 0;

  Map<String, String> langs = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'kn': 'ಕನ್ನಡ',
    'ta': 'தமிழ்',
    'bn': 'বাংলা'
  };
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          Languages.of(context)!.appName,
          // "Krishi Sahayak",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.logOut();
              Navigator.pushNamed(context, '/login');
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              // we have provider
              LocaleProvider localeProvider =
                  Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return [
                const Locale('en'),
                const Locale('hi'),
                const Locale('mr'),
                const Locale('kn'),
                const Locale('ta'),
                const Locale('bn')
              ]
                  .map<PopupMenuItem<Locale>>(
                    (Locale locale) => PopupMenuItem<Locale>(
                      value: locale,
                      child: Text(langs[locale.languageCode]!),
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
      body: Center(
        child: _buildPageContent(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: Languages.of(context)!.home,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera),
            label: Languages.of(context)!.scanner,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.assistant_outlined,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: Languages.of(context)!.pdfanalytics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.assistant_outlined,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: Languages.of(context)!.pdfanalytics,
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CamScreen();
      case 2:
        return const FilePickerDemo();
      case 3:
        return const ChatBot();
      default:
        return Container();
    }
  }
}
