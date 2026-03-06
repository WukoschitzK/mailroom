import 'package:flutter/material.dart';
import '../globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    client.auth.seedUsers().catchError((e) => debugPrint("Seeder Fehler: $e"));
  }

  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final user = await client.auth.login(_pinController.text);
      if (user != null) {
        currentUserSignal.value = user;
      } else {
        setState(() => _errorMessage = 'Falscher PIN. Bitte erneut versuchen.');
        _pinController.clear();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Verbindungsfehler zum Server.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_person, size: 64, color: Colors.blueGrey),
              const SizedBox(height: 16),
              const Text('Poststellen Scanner', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Bitte PIN eingeben', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, letterSpacing: 16),
                decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                onChanged: (val) { if (val.length == 4) _handleLogin(); },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              if (_isLoading) const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}