import 'package:animate_do/animate_do.dart';
import 'package:app/components/select_lang.dart';
import 'package:app/lang/abs_lan.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool validateEmail(String email) {
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regExp = RegExp(pattern);

  return regExp.hasMatch(email);
}

bool validatePassword(String password) {
  return password.length >= 6;
}


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Locale chooseLang = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          Languages.of(context)!.appName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                          child: selectlangCard(context),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          duration: const Duration(
                            milliseconds: 1200,
                          ),
                          child: makeInput(
                            label: Languages.of(context)!.email,
                            controller: _emailController,
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: makeInput(
                            label: Languages.of(context)!.password,
                            obscureText: true,
                            controller: _passwordController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      // title: Text(Languages.of(context)!.error),
                                      // content: Text(Languages.of(context)!.fieldsEmpty),
                                      title: const Icon(Icons.error,
                                          color: Colors.red),
                                      content:
                                          const Text('Fields cannot be empty'),
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
                              } 
                              else if(
                                !validateEmail(_emailController.text) || !validatePassword(_passwordController.text)
                              ){
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Icon(Icons.error,
                                          color: Colors.red),
                                      content: const Text('Invalid email or password'),
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
                              }
                              else {
                                var _user = User(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: '',
                                );
                                Future<String> response =
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .logIn(_user);
                                response
                                    .then((value) => {
                                          {
                                            Navigator.pushNamed(
                                                context, '/otpverify')
                                          }
                                        })
                                    .catchError(
                                  (error) async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Icon(Icons.error,
                                              color: Colors.red),
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
                                  },
                                );
                              }
                            },
                            color: Colors.greenAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              Languages.of(context)!.login,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      )),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                              child: Text(
                                "Don't have an account? Sign up",
                                style: Theme.of(context).textTheme.titleSmall,
                              )),
                        ],
                      ))
                ],
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
