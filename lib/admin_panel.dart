import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lecturer email address is required';
    }
    final emailText = value.trim().toLowerCase();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailText)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _provisionLecturer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final String nameText = _nameController.text.trim();
    final String emailText = _emailController.text.trim().toLowerCase();
    final String passwordText = _passwordController.text;

    // Capture the primary active Firebase app instance options
    FirebaseApp currentApp = Firebase.app();

    try {
      // 1. Initialize an isolated secondary background app context
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'BackgroundProvisioner',
        options: currentApp.options,
      );

      // 2. Instantiate a temporary Auth pipeline dedicated to this background app context
      FirebaseAuth backgroundAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      // 3. Register the lecturer credentials cleanly via the isolated pipeline
      UserCredential userCredential = await backgroundAuth.createUserWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      if (userCredential.user != null) {
        final String lecturerUid = userCredential.user!.uid;

        // 4. Update the newly created user's display name metadata directly
        await userCredential.user!.updateDisplayName(nameText);

        // 5. Injects the permanent authorization record directly into primary Firestore collection
        await FirebaseFirestore.instance.collection('users').doc(lecturerUid).set({
          'name': nameText,
          'email': emailText,
          'role': 'lecturer', // Enforced natively for staff provisioned through this module
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 6. Delete and close out the background instance session completely
      await secondaryApp.delete();

      if (!mounted) return;
      
      // Success response notification feedback
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lecturer account successfully provisioned!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset the layout input controller blocks
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during provisioning.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email address is already assigned to a user.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password profile provided is too weak.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red[800]),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red[800]),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Faculty Management Portal', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06), 
                  blurRadius: 15, 
                  offset: const Offset(0, 4)
                )
              ],
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school, color: Color(0xFF1E3A8A), size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Register Lecturer',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xFF1E3A8A)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an isolated authentication profile and assign systematic access layers inside Cloud Firestore.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: "Lecturer Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name identifier is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Official Email Address",
                      prefixIcon: const Icon(Icons.email_outlined),
                      helperText: 'e.g., facultyname@uoeld.ac.ke',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Temporary Access Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Password structural length must be >= 6 characters' : null,
                  ),
                  const SizedBox(height: 28),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : _provisionLecturer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text(
                            'Provision Lecturer Profile', 
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}