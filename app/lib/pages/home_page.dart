import 'package:animate_do/animate_do.dart';
import 'package:app/pages/uploaddoc.dart';
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
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 30,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child:  userprovider.smsMessage == "" ? const Text('No message') : 
                Column(
                  children: [
                    Text(
                      'Sender: ${userprovider.smsColumn.address}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Message Body: ${userprovider.smsColumn.body}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height:20),
                  ],
                )
                
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilePickerDemo(),
                ),
              );
            },
            child: Text(
              'Get your bank statement analysed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
