import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userprovider =
        Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: 
                Text(
                    userprovider.smsMessage == "" ? "Couldn't fetch latest messages": userprovider.smsMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
