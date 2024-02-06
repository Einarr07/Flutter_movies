import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/registration_screen.dart';
import 'package:movies/screens/ForumPage.dart';
import 'package:movies/modal_class/movie.dart';

class LoginScreen extends StatefulWidget {
  final ThemeData? themeData;
  LoginScreen({this.themeData});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData!.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: widget.themeData!.colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Log In',
          style: widget.themeData!.textTheme.headline5,
        ),
      ),
      body: Container(
        color: widget.themeData!.primaryColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: widget.themeData!.textTheme.bodyText1,
              ),
              style: widget.themeData!.textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: widget.themeData!.textTheme.bodyText1,
              ),
              style: widget.themeData!.textTheme.bodyText1,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // Si el inicio de sesión es exitoso, redirige al foro
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ForumPage()),
                  );
                } catch (e) {
                  print("Error al iniciar sesión: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: widget.themeData!.primaryColor,
                onPrimary: widget.themeData!.colorScheme.secondary,
              ),
              child: Text(
                'Log In',
                style: widget.themeData!.textTheme.button,
              ),
            ),

            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationScreen(themeData: widget.themeData)
                  )
                );
              },
              child: Text(
                'Create an Account',
                style: widget.themeData!.textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
