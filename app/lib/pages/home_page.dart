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
          Text(
            "test",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: 100,
            height: 100,
            curve: Curves.bounceInOut,
            child: userprovider.smsMessage == ""
                ? const Icon(Icons.message)
                : Text(
                    userprovider.smsMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
