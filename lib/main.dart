import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/src/auth/sign_in.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Word Sleuth 2.0';

    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(brightness: Brightness.dark),
          primarySwatch: Colors.deepPurple,
        ),
        home: const MyHomePage(
          title: appTitle,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    if (!Amplify.isConfigured) {
      _configureAmplify();
    }
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignInPage(title: widget.title);
  }
}
