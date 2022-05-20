import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskito_task_management/create_user_page.dart';
import 'package:taskito_task_management/tasks_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.createUserWithEmailAndPassword(email: "email@gmail.com", password: "password");
    return MaterialApp(
      title: 'ToDo APP',
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.indigo.shade50,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.indigo.shade400),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String email = '';
  String password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  String _userEmail= '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management Application',style: const TextStyle(color: Colors.black),),
      ),
      body: Form(
        key: _formKey,
        child: Center(
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
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (String text) {
                        email = text;
                      },
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type your mail',
                          labelText: 'example@gmail.com'),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (String text) {
                        password = text;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Type your password',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/30,
                    ),

                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        child: const Text('Log In')
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/60,
                    ),

                    ElevatedButton(
                        onPressed: () {
                          _gotoCreateUser(context);
                        },
                        child: const Text('Create New User')

                    ),
                    ElevatedButton(onPressed: () {
                      _gotoTasks(context);
                    },
                        child: Text('Giris'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //final user = credential.user;
      if (credential.user != null) {
        setState(() {
          _userEmail = credential.user!.email!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Successfully Logged In ' + _userEmail,
            ),
          ),
          );
        });
        _gotoTasks(context);
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Log In Failed ' + _userEmail,
            ),
          ),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'No user found for that email.'
          ),
        ));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Wrong password provided for that user.'
          ),
        ));
      } else if (e.code == 'invalid-email') {
        print('Invalid email');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Invalid email provided.'
          ),
        ));
      }
    }
  }

  void _gotoTasks(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return const TasksPage();
    },));
  }
  void _gotoCreateUser(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return const CreateUserPage();
    },));
  }

}

