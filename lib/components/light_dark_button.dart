import 'package:flutter/material.dart';

class LightDarkButton extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggle;

  const LightDarkButton({
    super.key,
    required this.themeMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
    );
  }
}