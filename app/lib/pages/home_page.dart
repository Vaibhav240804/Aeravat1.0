import 'package:animate_do/animate_do.dart';
import 'package:app/pages/uploaddoc.dart';
import 'package:app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final translator = GoogleTranslator();
  Future<String> _translate(String text) async {
    var translation = await translator.translate(text,
        to: Provider.of<LocaleProvider>(context, listen: false)
            .locale
            .languageCode);
    return translation.text;
  }

  String _translatedText = "";

  @override
  void initState() {
    // TODO: implement initState
    UserProvider userprovider =
        Provider.of<UserProvider>(context, listen: false);
    if (userprovider.smsMessage != "") {
      try {
        userprovider.classifyMsg();
      } catch (e) {
        debugPrint(e.toString());
      }
      _translate(userprovider.smsMessage).then((value) {
        setState(() {
          _translatedText = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userprovider =
        Provider.of<UserProvider>(context, listen: true);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 30,
              surfaceTintColor:
                  Provider.of<UserProvider>(context, listen: false).isSpam
                      ? Colors.red
                      : Colors.green,
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: userprovider.smsMessage == ""
                      ? const Text('No message')
                      : Column(
                          children: [
                            Text(
                              'Sender: ${userprovider.smsColumn.address}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Message Body: ${_translatedText == "" ? userprovider.smsMessage : _translatedText}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                          ],
                        )),
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
