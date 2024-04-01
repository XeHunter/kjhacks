import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    try {
      // Check if the email exists in Firestore
      QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email!)
          .get();

      if (emailSnapshot.docs.isNotEmpty) {
        // Email exists in the database, sign in the user
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        if (userCredential.user != null) {

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Move to DrawerMain and store user information in shared preferences
          DocumentSnapshot userSnapshot = emailSnapshot.docs.first;
          await prefs.setString('userName', userSnapshot['name']);
          await prefs.setString('userEmail', userSnapshot['email']);
          await prefs.setString('userPhone', userSnapshot['phoneNumber']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DrawerMain()),
          );
        }
      } else {
        // Email not found in the database, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please register.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please register.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    } catch (e) {
      print("$e error!!!"); // Print the error message to understand what went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading1 = true;
    });

    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Check if the email exists in Firestore
        QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: googleUser.email)
            .get();

        if (emailSnapshot.docs.isNotEmpty) {
          // Email exists in the database
          DocumentSnapshot userSnapshot = emailSnapshot.docs.first;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userName', userSnapshot['name']);
          await prefs.setString('userEmail', userSnapshot['email']);
          await prefs.setString('userPhone', userSnapshot['phone']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DrawerMain()),
          );
        } else {
          // Email not found in the database, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found. Please register.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          );
        }
      }
    } catch (e) {
      // Your existing error handling...
    } finally {
      setState(() {
        _isLoading1 = false;
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
                                padding: EdgeInsets.symmetric(horizontal: 50),
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
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child:
                                  Center(
                                      child: Text(
                                          "-OR-",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Belanosima",
                                          )
                                      )
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed:_handleGoogleSignIn,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff009b97),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: _isLoading1
                                            ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                            :Row(
                                          mainAxisSize: MainAxisSize.min,

                                          children: [
                                            Image.asset("assets/google.png", width: 24, height: 24), // Your Google icon
                                            SizedBox(width: 10),
                                            Text(
                                              "Login with Google",
                                              style: TextStyle(
                                                fontFamily: "Belanosima",
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
