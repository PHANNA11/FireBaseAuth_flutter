import 'package:firebase6_7/second_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'Enter Email',
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_sharp),
                    hintText: 'Enter Email',
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var status = await signInAccount(emailController.text.trim(),
                      passwordController.text.trim());
                  if (status == '200') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecondScreen(),
                        ));
                  } else {
                    print(status);
                  }
                },
                child: const SizedBox(
                    height: 45,
                    width: 100,
                    child: Center(child: Text('Login'))))
          ],
        ),
      ),
    );
  }

  Future<String> signInAccount(String email, String password) async {
    String message = 'Error';
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      message = '200';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          message = e.code;
          break;
        case 'invalid-password':
          message = e.code;
          break;
        case 'wrong-password':
          message = e.code;
          break;
        case 'user-not-found':
          message = e.code;
          break;
      }
    }
    return message;
  }
}
