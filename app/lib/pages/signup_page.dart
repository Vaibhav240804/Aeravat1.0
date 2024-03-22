import 'dart:async';
import 'package:app/lang/abs_lan.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/providers.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
  final TextEditingController _nameController = TextEditingController();
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
                Languages.of(context)!.appName,
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.name,
                    // labelText: 'Name',
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    _user = User(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                    );

                    Future<String> response =
                        Provider.of<UserProvider>(context, listen: false)
                            .signUp(_user);
                    response
                        .then((value) => {
                              {Navigator.pushReplacementNamed(context, '/home')}
                            })
                        .catchError((error) async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error Occured {$error.toString()}'),
                            content: Text(error.toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return {};
                    });
                  },
                  child: Text(
                    Languages.of(context)!.signup,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    Languages.of(context)!.login,
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
