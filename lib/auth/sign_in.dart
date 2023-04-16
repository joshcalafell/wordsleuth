import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/auth/sign_up.dart';
import 'package:wordsleuth/pages/lander_page.dart';

class SignIn {}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title});

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool passwordVisible = false;
  bool isSignedIn = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Future<void> signInUser(String username, String password, context) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      setState(() {
        isSignedIn = result.isSignedIn;
      });

      if (result.isSignedIn) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LanderPage(title: widget.title)));
      }
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: false,
                padding: const EdgeInsets.all(15.0),
                children: <Widget>[
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Text('Sign In',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  const SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        return 'Please enter your password';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        suffixIcon: IconButton(
                            onPressed: _togglePasswordVisible,
                            icon: Icon(!passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility))),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (usernameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          signInUser(usernameController.text,
                              passwordController.text, context);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    minWidth: 350.0,
                    height: 50.0,
                    color: Colors.deepPurple,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Text(
                        'Don\'t have an account?',
                        textScaleFactor: 1.3,
                      )),
                      TextButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignUpPage(title: widget.title)));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            signOutCurrentUser().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignInPage(title: widget.title))));
          },
          tooltip: 'Go Home',
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.home),
        ));
  }
}
