import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'chat_list_screen.dart';
import '../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final NotificationService _notif = NotificationService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _notif.init();
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    final user = await _auth.signInWithGoogle();
    setState(() => _loading = false);
    if (user != null) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Talky', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFF6366F1), fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Sign in with Google to start chatting', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _signIn,
              icon: const Icon(Icons.login),
              label: Text(_loading ? 'Signing in...' : 'Sign in with Google'),
            )
          ]),
        ),
      ),
    );
  }
}
