import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'bottomNavBar.dart';
import 'gradient.dart';
import 'dart:convert';

class SignupScreen extends StatelessWidget {
    final TextEditingController _loginController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _firstnameController = TextEditingController();
    final TextEditingController _lastnameController = TextEditingController();
    bool loginResult = true;

  SignupScreen({super.key});

    void _handleSignup(BuildContext context) async {
        String email = _emailController.text;
        String password = _passwordController.text;
        String login = _loginController.text;
        String firstname = _firstnameController.text;
        String lastname = _lastnameController.text;

        final data = {
        'email': email,
        'password': password,
        'login': login,
        'firstname': firstname,
        'lastname': lastname,
        };

        final jsonData = jsonEncode(data);
        final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        };
        
        final response = await http.post(Uri.parse('https://poosd-large-project-group-8-1502fa002270.herokuapp.com/Users/api/signup'),
        headers: headers,
        body: jsonData,
        );

        if (response.statusCode == 200) {
          loginResult = true;
          _navigateToNextScreen(context);

        Fluttertoast.showToast(
          msg: 'Signup successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        } else {
        Fluttertoast.showToast(
          msg: 'Signup Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        body: Stack(
            children: [
              Center(
        child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/LandingPageBG.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              ClipPath(
                  clipper: GradientClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    ),
                  ),
                ),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    text: const TextSpan(
                        text: 'TopTier',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 72.0)
                    )
                ),
                const SizedBox(height: 24.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)), // Remove the default border
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: TextField(
                    controller: _loginController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)), // Remove the default border
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)), // Remove the default border
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                  ),
                ),
              const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: TextField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)), // Remove the default border
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)), // Remove the default border
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _handleSignup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Sign Up'),
              ),
            ]
            )
            ]
            ) 
            ),
              Positioned(
                top: 30,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  },
                ),
              ),
        ]
        )
        );
    }

    Future _navigateToNextScreen(BuildContext context) async{

      Navigator.push(context,MaterialPageRoute(builder: (context) =>const HomePage()));

    }
}