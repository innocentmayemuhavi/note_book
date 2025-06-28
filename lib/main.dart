import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/_app_wrapper.dart';
import 'controllers/note_controller.dart';
import 'controllers/theme_controller.dart';
import 'shared/_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    Get.put(NoteController());

    return Obx(
      () => GetMaterialApp(
        title: 'Note Book',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode,
        home: const AppWrapper(),
        debugShowCheckedModeBanner: false,
        // Listen to system theme changes
        builder: (context, child) {
          // Update theme controller when system theme changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final brightness = MediaQuery.of(context).platformBrightness;
            if (themeController.isSystemTheme &&
                themeController.isDarkMode != (brightness == Brightness.dark)) {
              themeController.onSystemThemeChanged();
            }
          });
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
