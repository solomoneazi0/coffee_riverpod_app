import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/screens/onboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase - replace the placeholders with your project values
  await Supabase.initialize(
    url: 'https://xbbojgzcryjlkunwrxje.supabase.co',
    anonKey: 'sb_publishable_xougwQ2_rE6gsW3u5kg-3Q_O9DBpx3a',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Use the registered font family so ShockedUp is the default app font.
        fontFamily: 'ShockedUp',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'ShockedUp',
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'ShockedUp',
            fontSize: 22,
          ),
        ),
      ),
      home: const OnboardScreen(),
    );
  }
}
