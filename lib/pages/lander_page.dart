import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/auth/sign_in.dart';

class LanderPage extends StatefulWidget {
  const LanderPage({super.key, required this.title});

  final String title;

  @override
  State<LanderPage> createState() => _LanderPageState();
}

class _LanderPageState extends State<LanderPage> {
  @override
  void initState() {
    super.initState();
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
        body: ListView(
          shrinkWrap: false,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            const SizedBox(
              height: 25.0,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Text('Hello, you are signed in...',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            signOutCurrentUser().then((value) => Navigator.pushReplacement(
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
