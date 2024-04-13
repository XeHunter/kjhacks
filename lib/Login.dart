import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kj/DrawerMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _obscurePassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _isFormValid = false;

  String? _email;
  String? _password;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _validateForm() {
    setState(() {
      _emailError = _validateEmail(emailController.text.trim());
      _passwordError = _validatePassword(passwordController.text.trim());

      _isFormValid = _emailError == null && _passwordError == null;

      if (_isFormValid) {
        _email = emailController.text.trim();
        _password = passwordController.text.trim();
      }
    });
  }

  void _navigateToHome(BuildContext context) {
    _validateForm();

    if (_isFormValid) {
      _loginUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill all fields correctly.'),
            duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_email == null || _password == null) {
      // Handle the case where email or password is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email or password is missing.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://1534-115-112-43-148.ngrok-free.app/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _email!,
          'password': _password!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        final String? token = userData['token']; // Assuming the token is returned in the response

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', token ?? ''); // Store the token, use an empty string if token is null

        // Fetch user data using the token
        final userResponse = await http.get(
          Uri.parse('https://1534-115-112-43-148.ngrok-free.app/user'),
          headers: <String, String>{
            'Authorization': 'Token $token',
          },
        );

        if (userResponse.statusCode == 200) {
          final Map<String, dynamic> userDetails = jsonDecode(userResponse.body);

          // Ensure all values are strings before storing them in shared preferences
          await prefs.setString('username', userDetails['username'].toString());
          await prefs.setString('email', userDetails['email'].toString());
          await prefs.setString('first_name', userDetails['first_name'].toString());
          await prefs.setString('last_name', userDetails['last_name'].toString());
          await prefs.setString('standard', userDetails['standard'].toString());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DrawerMain()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch user data.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      print("$e error!!!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    TextStyle defaultStyle = TextStyle(color: Colors.black, fontFamily: "Belanosima");
    TextStyle linkStyle = TextStyle(color: Color(0xff009b97),fontFamily: "Belanosima");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image(image: AssetImage("assets/login.png")),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xff009b97),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))
                ),

                child: Column(
                    children:[
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff009b97),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Belanosima',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xfffcdcf4),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                          ),
                          child: ListView(
                            children: [
                              SizedBox(height: 35,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Enter the registered email & password to verify your login.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Belanosima",
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(height: 35,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: TextField(
                                  controller: emailController,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _emailError != null ? Colors.red : Color(0xff009b97), width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 2.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                          color: _emailError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _emailError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _emailError,
                                      suffixIcon: Icon(Icons.email),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_emailError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _emailError = _validateEmail(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: TextField(
                                  controller: passwordController,
                                  cursorColor: Colors.black54,
                                  obscureText: _obscurePassword, // Add this line
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _passwordError != null ? Colors.red : Color(0xff009b97),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black54, width: 2.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: _passwordError != null ? Colors.red : Colors.black54,
                                      fontFamily: "Belanosima",
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: _passwordError != null ? Colors.red : Color(0xff009b97),
                                      fontFamily: "Belanosima",
                                    ),
                                    errorText: _passwordError,
                                    suffixIcon: Builder(
                                      builder: (context) {
                                        return IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          color: MaterialStateColor.resolveWith((states) =>
                                          states.contains(MaterialState.focused)
                                              ? (_passwordError != null ? Colors.red : Color(0xff009b97))
                                              : Colors.black54),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        );
                                      },
                                    ),

                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _passwordError = _validatePassword(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 30),
                                child: ElevatedButton(
                                  onPressed: () => _navigateToHome(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff009b97),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    minimumSize: Size(50.0, 50.0),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Belanosima",
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 100,),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultStyle,
                                    children: [
                                      TextSpan(
                                        text: "Don't have an account?",
                                      ),
                                      TextSpan(
                                        style: linkStyle,
                                        text: " Register here",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Register()),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
