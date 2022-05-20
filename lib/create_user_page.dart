import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  String email = '';
  String password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _success = false;
  String _userEmail= '';

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New User',style: TextStyle(color: Colors.white),),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width/3,
              ),
              Container(
                width: MediaQuery.of(context).size.width/20*15,
                // height: 200.0,
                //decoration: const BoxDecoration(color: Colors.blueGrey),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                            hintText: 'Type your mail',
                            labelText: 'example@gmail.com'
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },

                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Type your password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/20,
                      ),

                      ElevatedButton(
                          onPressed: () async {
                            //FirebaseAuth.instance.createUserWithEmailAndPassword(email: userNameController.text, password: passwordController.text);//.then((FirebaseUser user){ _firebaseUser = user;})
                            //FirebaseAuth.instance.createUserWithEmailAndPassword(email: userNameController.text, password: passwordController.text);
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }

                            //Navigator.pop(context);
                          },
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text(
                          //       _success == null
                          //           ? ''
                          //           : (_success
                          //           ? 'Successfully registered ' + _userEmail
                          //           : 'Registration failed')
                          //   ),
                          // ));
                          child:
                          const Text('Create New User')),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _register() async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );
      //final user = credential.user;
      if (credential.user != null) {
        setState(() {
          _userEmail = credential.user!.email!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                    'Successfully registered ' + _userEmail,
              ),
            ),
          );
        });
        Navigator.pop(context);
      } else if(credential.user == null) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Register Failed ' ,
            ),
          ),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The password provided is too weak. Min 6 digit.'
          ),
        ));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The account already exists for that email.'
          ),
        ));
      }
      else if (e.code == 'invalid-email') {
        print('Invalid email');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Invalid email provided.'
          ),
        ));
      }

      // final User? user = (await
      // _auth.createUserWithEmailAndPassword(
      //   email: userNameController.text,
      //   password: passwordController.text,
      // )
      // ).user;
      // if (user != null) {
      //   setState(() {
      //     _success = true;
      //     _userEmail = user.email!;
      //   });
      // } else {
      //   setState(() {
      //     _success = false;
      //   });
      // }
    }
  }
}

