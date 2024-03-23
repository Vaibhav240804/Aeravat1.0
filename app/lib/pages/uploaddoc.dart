import 'package:app/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({super.key});

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  FilePickerResult? _result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_result != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Selected file:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _result!.files.single.name,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Provider.of<UserProvider>(context, listen: false)
                            .analysis
                            .isEmpty
                        ? ElevatedButton(
                            onPressed: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .getAnalysis();
                            },
                            child: Text(
                              "Generate Report",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Column(
                            children: [
                              const Text(
                                'Analysis:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              for (var entry in Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .analysis
                                  .entries)
                                Text(
                                  '${entry.key} : ${entry.value}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                  ],
                ),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['pdf']);
                  if (_result == null) {
                    print("No file selected");
                  } else {
                    for (var element in _result!.files) {
                      print(element.name);
                      Provider.of<UserProvider>(context, listen: false)
                          .setFile(element);
                      setState(() {
                        _result = _result;
                      });
                    }
                  }
                },
                child: Text(
                  "File Picker",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
