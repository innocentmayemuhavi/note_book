import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/widgets/_setting_section_card.dart';
import '../../controllers/note_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../shared/_themes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final noteController = Get.find<NoteController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          // App Info Section
          buildSectionCard(context, 'App Information', [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('App Information'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Note Book App'),
                        SizedBox(height: 8),
                        Text('Version: 1.0.0'),
                        SizedBox(height: 8),
                        Text(
                          'A beautiful note-taking app with GetX state management.',
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Obx(
              () => ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Total Notes'),
                subtitle: Text('${noteController.notes.length} notes stored'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ]),

          const SizedBox(height: 5),

          // Appearance Section
          buildSectionCard(context, 'Appearance', [
            // Theme Mode Selection
            ListTile(
              leading: Obx(() => Icon(themeController.themeIcon)),
              title: const Text('Theme'),
              subtitle: Obx(() => Text(themeController.themeStatusText)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(themeController),
            ),

            // Quick theme toggle (if not using system theme)
            Obx(
              () => themeController.isSystemTheme
                  ? const SizedBox.shrink()
                  : SwitchListTile(
                      secondary: Icon(
                        themeController.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        themeController.isDarkMode
                            ? 'Dark theme enabled'
                            : 'Light theme enabled',
                      ),
                      value: themeController.isDarkMode,
                      onChanged: (_) => themeController.toggleTheme(),
                      activeColor: primaryColor,
                    ),
            ),
          ]),

          const SizedBox(height: 5),

          // Data Management Section
          buildSectionCard(context, 'Data Management', [
            ListTile(
              leading: const Icon(Icons.backup, color: success),
              title: const Text('Backup Notes'),
              subtitle: const Text('Export your notes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.snackbar(
                  'Feature Coming Soon',
                  'Backup functionality will be available in the next update',
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  colorText: primaryColor,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: warning),
              title: const Text('Restore Notes'),
              subtitle: const Text('Import your notes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.snackbar(
                  'Feature Coming Soon',
                  'Restore functionality will be available in the next update',
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  colorText: primaryColor,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: error),
              title: const Text('Clear All Notes'),
              subtitle: const Text('Delete all notes permanently'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showClearAllDialog(context, noteController),
            ),
          ]),

          const SizedBox(height: 5),

          buildSectionCard(context, 'About', [
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const SingleChildScrollView(
                      child: Text(
                        'This app stores your notes locally on your device. '
                        'No data is sent to external servers. '
                        'Your notes are private and secure.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Help & Support'),
                    content: const Text(
                      'Need help? Here are some tips:\n\n'
                      '• Tap + to create a new note\n'
                      '• Long press to pin/unpin notes\n'
                      '• Use search to find notes quickly\n'
                      '• Organize notes with categories and tags\n'
                      '• Change note status to track progress',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              'Made with ❤️ using Flutter & GetX',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(ThemeController themeController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => RadioListTile<String>(
                title: const Text('System'),
                subtitle: const Text('Use system setting'),
                value: 'system',
                groupValue: themeController.isSystemTheme
                    ? 'system'
                    : (themeController.isDarkMode ? 'dark' : 'light'),
                onChanged: (_) {
                  themeController.useSystemTheme();
                  Get.back();
                },
                activeColor: primaryColor,
              ),
            ),
            Obx(
              () => RadioListTile<String>(
                title: const Text('Light'),
                subtitle: const Text('Light theme'),
                value: 'light',
                groupValue: themeController.isSystemTheme
                    ? 'system'
                    : (themeController.isDarkMode ? 'dark' : 'light'),
                onChanged: (_) {
                  themeController.setLightTheme();
                  Get.back();
                },
                activeColor: primaryColor,
              ),
            ),
            Obx(
              () => RadioListTile<String>(
                title: const Text('Dark'),
                subtitle: const Text('Dark theme'),
                value: 'dark',
                groupValue: themeController.isSystemTheme
                    ? 'system'
                    : (themeController.isDarkMode ? 'dark' : 'light'),
                onChanged: (_) {
                  themeController.setDarkTheme();
                  Get.back();
                },
                activeColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog(
    BuildContext context,
    NoteController noteController,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Notes'),
        content: const Text(
          'Are you sure you want to delete all notes? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              // Clear all notes
              for (final note in List.from(noteController.notes)) {
                await noteController.deleteNote(note.id);
              }
              Get.back();
              Get.snackbar(
                'Success',
                'All notes have been deleted',
                backgroundColor: success.withValues(alpha: 0.1),
                colorText: success,
              );
            },
            style: TextButton.styleFrom(foregroundColor: error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
