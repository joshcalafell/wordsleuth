import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wordsleuth/auth/sign_in.dart';

class ConfirmAccountPage extends StatefulWidget {
  const ConfirmAccountPage(
      {super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  bool isSignUpComplete = false;

  final codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> confirmUser() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: widget.username, confirmationCode: codeController.text);

      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
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
                    const Text('Confirm Account',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your code from email';
                        } else {
                          return null;
                        }
                      },
                      controller: codeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.code),
                        labelText: "Code",
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MaterialButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.

                          if (codeController.text.isNotEmpty) {
                            confirmUser().whenComplete(() =>
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInPage(title: widget.title))));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        }
                      },
                      minWidth: 350.0,
                      height: 50.0,
                      color: Colors.deepPurple,
                      child: const Text(
                        "Confirm Account",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
