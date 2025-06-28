import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controllers/theme_controller.dart';
import 'package:note_book/pages/archived/archived_notes_page.dart';
import 'package:note_book/utils/utils.dart';
import 'controllers/note_controller.dart';
import 'pages/home/home_page.dart';

import 'pages/add_note/add_note_page.dart';
import 'pages/settings/settings_page.dart';
import 'shared/_themes.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    ArchivedNotesPage(),
    const SettingsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${getGreeting()}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                '${noteController.filteredNotes.length} notes',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: noteController.clearFilters,
            icon: const Icon(Icons.filter_list_off),
            tooltip: 'Clear Filters',
            color: Colors.white,
          ),
          IconButton(
            onPressed: themeController.toggleTheme,
            icon: Obx(() => Icon(themeController.themeIcon)),
            tooltip: 'Toggle Theme',
            color: Colors.white,
          ),
        ],
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Obx(() {
              final archivedCount = noteController.archivedNotes.length;
              return Badge(
                isLabelVisible: archivedCount > 0,
                label: Text(
                  archivedCount > 99 ? '99+' : archivedCount.toString(),
                ),
                child: const Icon(Icons.archive_outlined),
              );
            }),
            selectedIcon: Obx(() {
              final archivedCount = noteController.archivedNotes.length;
              return Badge(
                isLabelVisible: archivedCount > 0,
                label: Text(
                  archivedCount > 99 ? '99+' : archivedCount.toString(),
                ),
                child: const Icon(Icons.archive),
              );
            }),
            label: 'Archived',
          ),

          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(1),
          backgroundColor: primaryColor,
        ),
        onPressed: () => Get.to(() => const AddNotePage()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
