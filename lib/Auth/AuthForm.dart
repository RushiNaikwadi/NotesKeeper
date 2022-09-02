import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  //------------------- Private Fields -----------------------------------------//
  final _formkey = GlobalKey<FormState>();
  var _username = '';
  var _email = '';
  var _password = '';
  bool isLoginPage = false;
  //----------------------------------------------------------------------------//

  startAuthentication() {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity!) {
      _formkey.currentState?.save();
      submitForm(_username, _email, _password);
    }
  }

  submitForm(String Username, String Email, String Password) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(email: Email, password: Password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(email: Email, password: Password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username' : Username,
          'email': Email
        });
      }
    } catch(err) {

    }
  }
  //----------------------------------------------------------------------------//



  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width * 0.90,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (isLoginPage) (
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.deepPurpleAccent,
                          ),
                        )
                    ) else (
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.deepPurpleAccent,
                          ),
                        )
                    ),
                    if (!isLoginPage) (
                        const SizedBox(height: 20)
                    ),
                    if (!isLoginPage) (
                        TextFormField(
                          keyboardType: TextInputType.text,
                          key: const ValueKey('Username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(),
                            ),
                            label: const Text(
                              'Username',
                            ),
                            labelStyle: GoogleFonts.roboto(),
                          ),
                        )
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('Email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(),
                        ),
                        label: const Text(
                            'Email',
                        ),
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      key: const ValueKey('Password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Invalid Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(),
                        ),
                        label: const Text('Password'),
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (isLoginPage) (
                        SizedBox(
                            width: 150,
                            child: FloatingActionButton.extended(
                                onPressed: () {
                                  startAuthentication();
                                },
                                label: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                  ),
                                ),
                                backgroundColor: Colors.blue[900]
                            )
                        )
                    ) else (
                        SizedBox(
                          width: 150,
                          child: FloatingActionButton.extended(
                              onPressed: () {
                                startAuthentication();
                              },
                              label: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                              ),
                              backgroundColor: Colors.blue[900]
                        )
                      )
                    ),
                    const SizedBox(height: 10),
                    if (isLoginPage) (
                        Container(
                            alignment: Alignment.center,
                            width: 300,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.grey[850],
                              onPressed: () {
                                setState(() {
                                  isLoginPage = !isLoginPage;
                                });
                              },
                              label: const Text(
                                'Not a member ?',
                                style: TextStyle(
                                    color: Colors.yellow
                                ),
                              ),
                              elevation: 0,
                            )
                        )
                    ) else (
                        Container(
                          alignment: Alignment.center,
                          width: 300,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.grey[850],
                            onPressed: () {
                              setState(() {
                                isLoginPage = !isLoginPage;
                              });
                            },
                            label: const Text(
                              'Already a member ?',
                              style: TextStyle(
                                color: Colors.yellow
                              ),
                            ),
                            elevation: 0,
                          )
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
