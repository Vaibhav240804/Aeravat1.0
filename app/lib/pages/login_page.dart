import 'package:flutter/material.dart';
import 'package:app/lang/abs_lan.dart';
import 'package:app/providers/providers.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  Locale chooseLang = const Locale('en');

  Map<String, String> lang = {
    'English': 'en',
    'हिन्दी': 'hi', // Hindi
    'मराठी': 'mr', // Marathi
    'বাংলা': 'bn', // Bengali
    'தமிழ்': 'ta', // Tamil
    'ಕನ್ನಡ': 'kn', // Kannada
  };

  late User _user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 50),
              Text(
                // Languages.of(context)!.appName,
                'Krishi Sahayak',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 50),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                elevation: 1,
                child: Wrap(
                  spacing: 5,
                  children: lang.entries
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(6),
                            child: ChoiceChip(
                              label: Text(
                                e.key,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              onSelected: (value) =>
                                  Provider.of<LocaleProvider>(context,
                                          listen: false)
                                      .setLocale(Locale(e.value)),
                              selected: Locale(e.value) ==
                                  Provider.of<LocaleProvider>(context).locale,
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.email,
                    // labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.password,
                    // labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _user = User(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: '',
                    );
                    // Provider.of<UserProvider>(context, listen: false).logIn(user: _user);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    // Languages.of(context)!.login,
                    'Login',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Text(
                    // Languages.of(context)!.signup,
                    'Sign Up',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
