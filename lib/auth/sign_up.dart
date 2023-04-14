// ignore_for_file: use_build_context_synchronously

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/auth/confirm_account.dart';
import 'package:wordsleuth/auth/sign_in.dart';
import 'package:wordsleuth/pages/lander_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool passwordVisible = false;
  bool isSignUpComplete = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _togglePasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> signUpUser() async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: emailController.text,
        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
        username: usernameController.text,
        password: passwordConfirmController.text,
        // ignore: deprecated_member_use
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmAccountPage(
                  title: widget.title, username: usernameController.text)));
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            body: ListView(
              shrinkWrap: false,
              padding: const EdgeInsets.all(15.0),
              children: <Widget>[
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      const Text('Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20)),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          } else {
                            return null;
                          }
                        },
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          labelText: "Username",
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null;
                          }
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            labelText: "New Password",
                            suffixIcon: IconButton(
                                onPressed: _togglePasswordVisible,
                                icon: Icon(!passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please verify your password';
                          } else {
                            return null;
                          }
                        },
                        controller: passwordConfirmController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Verify Password",
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      MaterialButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            if (usernameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                passwordConfirmController.text.isNotEmpty &&
                                (passwordController.text ==
                                    passwordConfirmController.text)) {
                              signUpUser();
                            }
                          }
                        },
                        minWidth: 350.0,
                        height: 50.0,
                        color: Colors.deepPurple,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SignInPage(title: widget.title)));
              },
              tooltip: 'Go Home',
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.home),
            )));
  }
}
