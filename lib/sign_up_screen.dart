import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/sign_In_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _signUpInProgress = false;

  @override
  void initState() {
    super.initState(); 
    FirebaseCrashlytics.instance.log('Into Sign Up Screen');
    
  }


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
                TextFormField(
                  controller: _confirmPasswordTEController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                  ),
                  validator: (String? value) {
                    if ((value ?? '') != _passwordTEController.text) {
                      return 'Does not match with Password';
                    }
                  },
                ),
                Visibility(
                  visible: _signUpInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onTapSignUp,
                    child: Text('Sign Up'),
                  ),
                ),

                TextButton(onPressed: _onTapSignInButton,
                    child: Text('Sign In')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()),
    );
  }

  Future<void> _onTapSignUp() async {
    FirebaseCrashlytics.instance.log(' Tapped on Sing Up button');
    if (_formkey.currentState!.validate()) {
      //TODO: Create a new user
      try {
        _signUpInProgress = true;
        setState(() {});
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailTEController.text.trim(),
              password: _passwordTEController.text,
            );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New account has been created!')));
        _clearTextFiled();
      } on Exception catch (e) {

        FirebaseCrashlytics.instance.log('Sign Up exception $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        _signUpInProgress = false;
        setState(() {});
      }
    }
  }

  void _clearTextFiled(){
    _emailTEController.clear();
    _passwordTEController.clear();
    _confirmPasswordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
