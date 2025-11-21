import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // IMPORTANT: Replace these with your real Supabase credentials
  await Supabase.initialize(
    url: "https://vcsawpofjdrphqmusnjf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZjc2F3cG9mamRycGhxbXVzbmpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2MTEwNzIsImV4cCI6MjA3ODE4NzA3Mn0.rW94pvg5mxD0QJUOWpJDexVFUm9EV-eVDs1x1yCbnTI",
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;

    // AUTH LISTENER (SAFE)
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      // Delay navigation until widget is mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // --- USER LOGGED OUT ---
        if (event == AuthChangeEvent.signedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }

        // --- USER LOGGED IN ---
        if (event == AuthChangeEvent.signedIn) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationScreen()),
            (_) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return MaterialApp(
      title: 'EMI Calculator',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),

      // Initial screen (based on login status)
      home: user == null ? const LoginScreen() : const NavigationScreen(),
    );
  }
}
