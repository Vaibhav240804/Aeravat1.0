import 'package:app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Card selectlangCard(BuildContext context) {

  Map<String, String> lang = {
    'English': 'en',
    'हिन्दी': 'hi', // Hindi
    'मराठी': 'mr', // Marathi
    'বাংলা': 'bn', // Bengali
    'தமிழ்': 'ta', // Tamil
    'ಕನ್ನಡ': 'kn', // Kannada
  };
  return Card(
    elevation: 1,
  surfaceTintColor: Colors.white,
    child: Wrap(
      spacing: 7,
      children: lang.entries
          .map((e) => Padding(
                padding: const EdgeInsets.all(6),
                child: ChoiceChip(
                  label: Text(
                    e.key,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onSelected: (value) =>
                      Provider.of<LocaleProvider>(context, listen: false)
                          .setLocale(Locale(e.value)),
                  selected: Locale(e.value) ==
                      Provider.of<LocaleProvider>(context).locale,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                ),
              ))
          .toList(),
    ),
  );
}
