import 'package:app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class ResultScreen extends StatefulWidget {
  final List<String> tableData;

  const ResultScreen({super.key, required this.tableData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final translator = GoogleTranslator();

  @override
  void didUpdateWidget(covariant ResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> _translate(String text) async {
      var translation = await translator.translate(text,
          to: Provider.of<LocaleProvider>(context, listen: false)
              .locale
              .languageCode);
      return translation.text;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          children: [
            for (var data in widget.tableData)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Future<String> response = _translate(data);
                    response
                        .then((value) => {
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Translation'),
                                      content: Text(value),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'OK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Know more',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .fontSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
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
                                child: Text(
                                  'OK',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      // return {};
                    });
                  },
                  child: Text(
                    data,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
