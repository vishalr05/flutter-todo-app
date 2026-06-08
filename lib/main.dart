import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'themes/app_theme.dart';
import 'screens/splash_screen.dart';

/// ──────────────────────────────────────────────
/// TaskFlow — Main Entry Point
/// ──────────────────────────────────────────────
///
/// Initializes Hive storage, registers providers,
/// and launches the app starting from the splash screen.
void main() async {
  // Ensure Flutter bindings are initialized before async work
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage (registers adapters, opens boxes, seeds mock data)
  await StorageService().init();

  // Run the app
  runApp(const TaskFlowApp());
}

/// Root widget of the TaskFlow application.
///
/// Uses MultiProvider to provide state management to the entire widget tree:
///   - TaskProvider: Task CRUD, filtering, and search
///   - OnboardingProvider: First-launch onboarding state
///   - ThemeProvider: Light/dark mode toggle
class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Task state management
        ChangeNotifierProvider(
          create: (_) => TaskProvider()..loadTasks(),
        ),
        // Onboarding state
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider()..loadState(),
        ),
        // Theme state
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadState(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'TaskFlow',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Start with splash screen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
