import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool emailSent = false;

  void handlePasswordRecovery() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        setState(() {
          emailSent = true; // Mark email as sent
        });
      } catch (e) {
        // Handle error (e.g., user not found)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending email: $e')),
        );
      }

      // Clear the email field after a successful attempt
      Future.delayed(const Duration(seconds: 2), () {
        emailController.clear();
        setState(() {
          emailSent = false; // Reset emailSent after feedback
        });
      });
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your email address below and we will send you instructions to reset your password.',
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  validator: validateEmail,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: handlePasswordRecovery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Send Recovery Email', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                if (emailSent)
                  const Text('Recovery email sent successfully!', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the login screen
                  },
                  child: Text('Back to Login', style: TextStyle(color: Colors.blue.shade900)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}