import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _numberError;
  String? _passwordError;

  bool _isFormValid = false;

  String? _name;
  String? _email;
  String? _number;
  String? _password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _validateForm() {
    setState(() {
      _nameError = _validateName(nameController.text.trim());
      _emailError = _validateEmail(emailController.text.trim());
      _numberError = _validateNumber(numberController.text.trim());
      _passwordError = _validatePassword(passwordController.text.trim());

      _isFormValid =
          _nameError == null && _emailError == null && _numberError == null && _passwordError == null;

      if (_isFormValid) {
        _name = nameController.text.trim();
        _email = emailController.text.trim();
        _number = numberController.text.trim();
        _password = passwordController.text.trim();
      }
    });
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
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );

      final user = userCredential.user;

      if (user != null) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        await prefs.setString('userName', _name!);
        await prefs.setString('userEmail', _email!);
        await prefs.setString('userPhone', _number!);

        final userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.set({
          'name': _name,
          'email': _email,
          'phoneNumber': _number,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DrawerMain()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already registered. Please login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
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
        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final userEmail = user.email;

          // Check if the user email exists in the Firestore database
          final userDoc = _firestore.collection('users').where('email', isEqualTo: userEmail).get();
          if ((await userDoc).docs.isNotEmpty) {
            // Email exists, navigate to Login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          } else {
            // Email does not exist, save user data and navigate to Home screen
            final newUserDoc = _firestore.collection('users').doc(user.uid);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);

            await prefs.setString('userName', user.displayName!);
            await prefs.setString('userEmail', user.email!);
            await prefs.setString('userPhone', user.phoneNumber!);

            await newUserDoc.set({
              'name': user.displayName,
              'email': user.email,
              'phoneNumber': '',
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DrawerMain()),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading1 = false;
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
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



  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }

    if (value.contains(' ')) {
      return 'Please clear blank space';
    }

    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
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
                                  controller: nameController,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _nameError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Enter your name',
                                      labelStyle: TextStyle(
                                          color: _nameError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _nameError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _nameError,
                                      suffixIcon: Icon(Icons.person),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_nameError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _nameError = _validateName(value);
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
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: _numberError != null ? Colors.red : Color(0xff009b97), width: 2.0),
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
                                      labelText: 'Mobile Number',
                                      labelStyle: TextStyle(
                                          color: _numberError != null ? Colors.red : Colors.black54,
                                          fontFamily: "Belanosima"
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          color: _numberError != null ? Colors.red : Color(0xff009b97),
                                          fontFamily: "Belanosima"
                                      ),
                                      errorText: _numberError,
                                      suffixIcon: Icon(Icons.phone),
                                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                                      states.contains(MaterialState.focused) ? (_numberError != null ? Colors.red : Color(0xff009b97))
                                          : Colors.black54,
                                      )
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _numberError = _validateNumber(value);
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
                              Center(
                                  child: Text(
                                      "Register With",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Belanosima",
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
                                        onPressed: _handleGoogleSignIn,
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
                                              "Register with Google",
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
