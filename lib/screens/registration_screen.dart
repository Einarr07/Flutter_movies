import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  final ThemeData? themeData;
  RegistrationScreen({this.themeData});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Puedes realizar acciones adicionales después del registro si es necesario.
      print('Usuario registrado con éxito: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es débil');
      } else if (e.code == 'email-already-in-use') {
        print('La cuenta ya existe para este correo electrónico');
      } else {
        print('Error de registro: ${e.message}');
      }
    } catch (e) {
      print('Error inesperado: $e');
    }
  }

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
          'Register',
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
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                primary: widget.themeData!.primaryColor,
                onPrimary: widget.themeData!.colorScheme.secondary,
              ),
              child: Text(
                'Register',
                style: widget.themeData!.textTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
