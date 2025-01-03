import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/themeprovider.dart';

void showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Theme",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              Divider(thickness: 0.5, color: theme.colorScheme.onPrimaryContainer),
              _buildThemeTile(
                context,
                icon: Icons.wb_sunny,
                title: "Light Theme",
                description: "Bright and clear theme",
                isSelected: themeProvider.themeMode == ThemeMode.light,
                onTap: () {
                  themeProvider.toggleTheme(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              _buildThemeTile(
                context,
                icon: Icons.nightlight_round,
                title: "Dark Theme",
                description: "Elegant and eye-friendly",
                isSelected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () {
                  themeProvider.toggleTheme(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              _buildThemeTile(
                context,
                icon: Icons.brightness_auto,
                title: "System Default",
                description: "Follows your system preferences",
                isSelected: themeProvider.themeMode == ThemeMode.system,
                onTap: () {
                  themeProvider.toggleTheme(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}


Widget _buildThemeTile(
    BuildContext context, {
      required IconData icon,
      required String title,
      required String description,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : theme
            .colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer.withOpacity(
                        0.8)
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}