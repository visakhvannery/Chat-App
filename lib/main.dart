import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'screens/login_screen.dart';
import 'screens/chat_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // Initialize Firebase only if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // ✅ Force correct region URL for DB
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      'https://talk......app',
    );

    await db.ref('testConnection').set({
      'connectedAt': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    // Optional: print the error for debugging
    print('Firebase init error: $e');
  }


  runApp(const TalkyApp());
}

class TalkyApp extends StatelessWidget {
  const TalkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Talky',
        theme: ThemeData.light().copyWith(
          primaryColor: const Color(0xFF6366F1),
          useMaterial3: false,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF6366F1),
        ),
        themeMode: ThemeMode.system,
        routes: {
          '/': (context) => const Root(),
          '/chats': (context) => const ChatListScreen(),
        },
      ),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state, show a splash/loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: snapshot.hasData
              ? const ChatListScreen()
              : const LoginScreen(),
        );

        // If user is logged in → go to chats
        if (snapshot.hasData) {
          return const ChatListScreen();
        }

        // If user is logged out → show login screen
        return const LoginScreen();
      },
    );
  }
}
