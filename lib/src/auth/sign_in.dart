import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/src/auth/sign_up.dart';
import 'package:wordsleuth/src/screens/lander_page.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LanderPage(title: 'Word Slut 2.0'),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

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
        Navigator.of(context).push(_createRoute());
      }
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      setState(() {
        isSignedIn = false;
      });
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      setState(() {
        isSignedIn = false;
      });
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                  icon: const Icon(Icons.account_circle,
                      color: Colors.white, size: 24.0),
                  onPressed: () {
                    signOutCurrentUser().then((value) =>
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignInPage(title: widget.title))));
                  })
            ]),
        body: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: false,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                children: <Widget>[
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Center(
                    child: Text('Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                  ),
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
                            icon: Icon(passwordVisible
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
                        textScaleFactor: 1.15,
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
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ],
                  )
                ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Go Home',
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.home),
        ));
  }
}
