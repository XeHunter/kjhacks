import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:kavach_app/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kj/DrawerMain.dart';
import 'package:kj/Home.dart';
import 'package:kj/Login.dart';
import 'package:kj/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _obscurePassword = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController standardController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _standardError;
  String? _passwordError;

  bool _isFormValid = false;

  String? _username;
  String? _email;
  String? _standard;
  String? _password;


  void _validateForm() {
    setState(() {
      _usernameError = _validateUsername(usernameController.text.trim());
      _emailError = _validateEmail(emailController.text.trim());
      _standardError = _validateStandard(standardController.text.trim());
      _passwordError = _validatePassword(passwordController.text.trim());

      _isFormValid = _usernameError == null && _emailError == null && _standardError == null && _passwordError == null;

      if (_isFormValid) {
        _username = usernameController.text.trim();
        _email = emailController.text.trim();
        _standard = standardController.text.trim();
        _password = passwordController.text.trim();
      }
    });
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Add more complex email validation if needed
    return null;
  }

  String? _validateStandard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your standard';
    }
    int? standard = int.tryParse(value);
    if (standard == null || standard < 1 || standard > 12) {
      return 'Standard must be between 1 and 12';
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

  void _navigateToHome(BuildContext context) {
    _validateForm();

    if (_isFormValid) {
      _registerUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.'), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://1534-115-112-43-148.ngrok-free.app/signup'),
        headers: {
          "ngrok-skip-browser-warning": "69420", // Add the custom header here
        },
        body: {
          'username': _username!,
          'email': _email!,
          'first_name': firstnameController.text.trim(),
          'last_name': lastnameController.text.trim(),
          'standard': _standard!,
          "user_type": "student",
          'password': _password!,
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, navigate to the home screen.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username!);
        await prefs.setString('email', _email!);
        await prefs.setString('first_name', firstnameController.text.trim());
        await prefs.setString('last_name', lastnameController.text.trim());
        await prefs.setString('standard', _standard!);
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DrawerMain()),
        );
      } else {
        // If the server returns an error response, throw an exception.
        throw Exception('Failed to register user');
      }
    } catch (e) {
      // Handle any errors here.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              child: Image(image: AssetImage("assets/sigmup.png")),
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
                              "Create New Account",
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
                                child: TextField(
                                  controller: usernameController,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _usernameError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Enter your Username',
                                      labelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _usernameError,
                                      suffixIcon: Icon(Icons.person),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_usernameError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _usernameError = _validateUsername(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
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
                                  controller: firstnameController,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _usernameError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Enter your Firstname',
                                      labelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _usernameError,
                                      suffixIcon: Icon(Icons.person),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_usernameError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _usernameError = _validateUsername(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: TextField(
                                  controller: lastnameController,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _usernameError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Enter your Lastname',
                                      labelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _usernameError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _usernameError,
                                      suffixIcon: Icon(Icons.person),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_usernameError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _usernameError = _validateUsername(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: TextField(
                                  controller: standardController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _standardError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Standard',
                                      labelStyle: TextStyle(
                                          color: _standardError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _standardError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _standardError,
                                      suffixIcon: Icon(Icons.phone),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_standardError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _standardError = _validateStandard(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                        color: _passwordError != null ? Colors.red : Color(0xff009b97),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
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
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Belanosima",
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: defaultStyle,
                                      children: [
                                        TextSpan(
                                          text: "Already have an account?",
                                        ),
                                        TextSpan(
                                          style: linkStyle,
                                          text: " Login here",
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Login()),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
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
