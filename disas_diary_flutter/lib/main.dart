import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'providers/app_state.dart';
import 'services/persistence_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable wakelock to keep screen on during gameplay
  await WakelockPlus.enable();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  final persistenceService = PersistenceService(prefs);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(persistenceService),
      child: const DisasDiaryApp(),
    ),
  );
}

class DisasDiaryApp extends StatelessWidget {
  const DisasDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'Disas Diary',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.themeMode,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
