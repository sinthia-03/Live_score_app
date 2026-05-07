import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            autovalidateMode: .onUserInteraction,
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  controller: _emailTEController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your email';
                    }
                  },
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    if ((value?.length ?? 0) < 5) {
                      return 'Enter your password at least 6 letters';
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: _signInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onTapSignUp,
                    child: Text('Sign Up'),
                  ),
                ),
                TextButton(onPressed: _onTapSignUPButton, child: Text('Sign Up')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUPButton(){
    Navigator.pop(context, MaterialPageRoute(builder: (context)=>SignInScreen()),
    );
  }

  Future<void> _onTapSignUp() async {
    if (_formkey.currentState!.validate()) {
      //TODO: Create a new user
      try {
        _signInProgress = true;
        setState(() {});
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailTEController.text.trim(),
          password: _passwordTEController.text,
        );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),
            (predicate)=>false,
        );
      } on Exception catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        _signInProgress = false;
        setState(() {});
      }
    }
  }

  void _clearTextFiled(){
    _emailTEController.clear();
    _passwordTEController.clear();

  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();

    // TODO: implement dispose
    super.dispose();
  }
}
